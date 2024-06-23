import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_com/core/core.dart';
import 'package:e_com/feature/auth/controller/auth_ctrl.dart';
import 'package:e_com/feature/check_out/controller/checkout_ctrl.dart';
import 'package:e_com/feature/check_out/view/checkout_payment_view.dart';
import 'package:e_com/feature/products/view/local/digital_product_card_animated.dart';
import 'package:e_com/feature/region_settings/provider/region_provider.dart';
import 'package:e_com/feature/settings/provider/settings_provider.dart';
import 'package:e_com/models/models.dart';
import 'package:e_com/routes/routes.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DigitalProductShowcase extends HookConsumerWidget {
  const DigitalProductShowcase({super.key, required this.data});
  final List<DigitalProduct> data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = useState(0);
    final autoScroll = useState(true);
    return CarouselSlider.builder(
      options: CarouselOptions(
        autoPlayCurve: Curves.easeOutQuart,
        viewportFraction: context.onMobile ? 0.75 : 0.4,
        onPageChanged: (index, reason) => currentIndex.value = index,
        clipBehavior: Clip.none,
        autoPlay: autoScroll.value,
        height: 400,
      ),
      itemCount: data.length,
      itemBuilder: (context, index, _) {
        return DigitalProductCardAnimated(
          product: data[index],
          height: 200,
          isExpanded: index == currentIndex.value,
          onButtonTap: () async {
            autoScroll.value = false;
            await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              showDragHandle: true,
              builder: (_) => DigitalBuySheet(product: data[index]),
            );
            autoScroll.value = true;
          },
        );
      },
    );
  }
}

class DigitalBuySheet extends HookConsumerWidget {
  const DigitalBuySheet({
    super.key,
    required this.product,
  });

  final DigitalProduct product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = useAnimationController();
    final paymentMethods =
        ref.watch(settingsProvider.select((value) => value?.paymentMethods));
    final local = ref.watch(localeCurrencyStateProvider);

    final digitalUid = useState<String?>(null);
    final paymentUid = useState<int?>(null);
    final fieldKey = useMemoized(GlobalKey<FormBuilderFieldState>.new);

    return SizedBox(
      height: context.height * 0.7,
      child: Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(10),
          child: SubmitButton(
            onPressed: product.attribute.isEmpty
                ? null
                : () async {
                    if (!ref.watch(authCtrlProvider)) {
                      final isValid = fieldKey.currentState?.validate();
                      if (isValid != true) return;
                    }

                    if (digitalUid.value == null) {
                      Toaster.showError(Translator.selectItemDigital(context));
                      return;
                    }
                    if (paymentUid.value == null) {
                      Toaster.showError(
                          Translator.selectPaymentMethod(context));
                      return;
                    }

                    await ref.read(checkoutCtrlProvider.notifier).buyNow(
                          productUid: product.uid,
                          digitalUid: digitalUid.value!,
                          paymentUid: paymentUid.value!,
                          email: fieldKey.currentState?.value ?? '',
                          onSuccess: () =>
                              RouteNames.orderPlaced.goNamed(context),
                        );
                  },
            child: Text(Translator.buyNow(context)),
          ),
        ),
        body: BottomSheet(
          animationController: ctrl,
          onClosing: () {},
          builder: (context) => SingleChildScrollView(
            padding: defaultPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: HostedImage.square(
                        product.featuredImage,
                        dimension: 60,
                        enablePreviewing: true,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(product.name, style: context.textTheme.titleLarge),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  Translator.attributes(context),
                  style: context.textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount:
                      product.attribute.isEmpty ? 1 : product.attribute.length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 10);
                  },
                  itemBuilder: (BuildContext context, int index) {
                    if (product.attribute.isEmpty) {
                      return Container(
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: context.colorTheme.error.withOpacity(.05),
                          borderRadius: defaultRadius,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          Translator.noAttribute(context),
                          style: context.textTheme.titleMedium,
                        ),
                      );
                    }
                    final attribute = product.attribute.entries.toList()[index];
                    final selected = digitalUid.value == attribute.value.uid;
                    return ListTile(
                      onTap: () {
                        selected
                            ? digitalUid.value = null
                            : digitalUid.value = attribute.value.uid;
                      },
                      title: Text(attribute.key),
                      subtitle: Text(attribute.value.price.fromLocal(local)),
                      leading: selected
                          ? const Icon(Icons.check_circle_rounded)
                          : const Icon(Icons.circle_outlined),
                      shape: RoundedRectangleBorder(
                        side: selected
                            ? BorderSide(
                                width: 1,
                                color: context.colorTheme.secondary,
                              )
                            : BorderSide.none,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      tileColor: context.colorTheme.secondaryContainer
                          .withOpacity(0.05),
                      iconColor: context.colorTheme.secondaryContainer,
                    );
                  },
                ),
                const SizedBox(height: 10),
                if (!ref.watch(authCtrlProvider)) ...[
                  Text(
                    Translator.email(context),
                    style: context.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 10),
                  FormBuilderTextField(
                    name: 'email',
                    key: fieldKey,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    decoration: InputDecoration(
                      hintText: Translator.email(context),
                    ),
                    validator: FormBuilderValidators.compose(
                      [
                        FormBuilderValidators.required(),
                        FormBuilderValidators.email(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                Text(
                  Translator.paymentMethod(context),
                  style: context.textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: context.onMobile ? 3 : 5,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: paymentMethods?.length ?? 1,
                  itemBuilder: (context, index) {
                    if (paymentMethods == null) {
                      return const Text('No Payment Method');
                    }
                    return SelectableCheckCard(
                      header: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: HostedImage(
                          paymentMethods[index].image,
                          height: 60,
                          width: 60,
                        ),
                      ),
                      title: Text(
                        paymentMethods[index].name,
                        textAlign: TextAlign.center,
                      ),
                      isSelected: paymentUid.value == paymentMethods[index].id,
                      onTap: () {
                        if (paymentUid.value == paymentMethods[index].id) {
                          return paymentUid.value = null;
                        }
                        paymentUid.value = paymentMethods[index].id;
                      },
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
