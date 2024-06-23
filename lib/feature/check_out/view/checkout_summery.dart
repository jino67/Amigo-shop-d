import 'package:collection/collection.dart';
import 'package:e_com/core/core.dart';
import 'package:e_com/feature/auth/controller/auth_ctrl.dart';
import 'package:e_com/feature/cart/controller/carts_ctrl.dart';
import 'package:e_com/feature/check_out/controller/checkout_ctrl.dart';
import 'package:e_com/feature/region_settings/provider/region_provider.dart';
import 'package:e_com/models/user_content/carts_model.dart';
import 'package:e_com/routes/routes.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CheckoutSummeryView extends HookConsumerWidget {
  const CheckoutSummeryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final local = ref.watch(localeCurrencyStateProvider);
    final carts = ref
        .watch(cartCtrlProvider.select((data) => data.valueOrNull?.listData));
    final checkout = ref.watch(checkoutCtrlProvider);
    final checkoutCtrl =
        useCallback(() => ref.read(checkoutCtrlProvider.notifier));
    final isLoggedIn = ref.read(authCtrlProvider);
    final isLoading = useState(false);

    //! Calculation

    final subTotal = carts?.map((e) => e.total).sum ?? 0;
    final shipping = checkout.shipping?.price ?? 0;
    final rate = isLoggedIn ? 1 : (local.currency?.rate ?? 1);
    final total = (subTotal * rate) + shipping;
    final charge = (total / 100) * (checkout.payment?.percentCharge ?? 0);

    final couponCodeCtrl = useTextEditingController();

    return Scaffold(
      appBar: KAppBar(
        title: Text(Translator.summery(context)),
        leading: SquareButton.backButton(
          onPressed: () => context.pop(),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: defaultPaddingAll,
        child: SubmitButton(
          width: context.width,
          isLoading: isLoading.value,
          onPressed: () async {
            if (couponCodeCtrl.text.isNotEmpty) {
              checkoutCtrl().setCoupon(couponCodeCtrl.text);
            }
            isLoading.value = true;
            final result = await checkoutCtrl().submitOrder();
            isLoading.value = false;

            if (!context.mounted) return;
            if (result) RouteNames.orderPlaced.goNamed(context);
          },
          child: Text(Translator.submitOrder(context)),
        ),
      ),
      body: SingleChildScrollView(
        physics: defaultScrollPhysics,
        padding: defaultPadding.copyWith(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //! shipping
            Container(
              decoration: BoxDecoration(
                borderRadius: defaultRadius,
                color: context.colorTheme.secondaryContainer.withOpacity(0.05),
              ),
              padding: defaultPaddingAll,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: context.width),
                  Text(
                    Translator.shippingDetails(context),
                    style: context.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    checkout.billingAddress?.fullName ?? 'N/A',
                    style: context.textTheme.titleMedium,
                  ),
                  Text(
                    checkout.billingAddress?.phone ?? 'N/A',
                    style: context.textTheme.titleMedium,
                  ),
                  Text(
                    checkout.billingAddress?.email ?? 'N/A',
                    style: context.textTheme.titleMedium,
                  ),
                  Text(
                    checkout.billingAddress?.fullAddress ?? 'N/A',
                    style: context.textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),

            //! shipping method
            Container(
              decoration: BoxDecoration(
                borderRadius: defaultRadius,
                color: context.colorTheme.secondaryContainer.withOpacity(0.05),
              ),
              padding: defaultPaddingAll,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Translator.shippingBy(context),
                    style: context.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: defaultRadius,
                        child: HostedImage.square(
                          checkout.shipping?.image ?? 'N/A',
                          dimension: 50,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            checkout.shipping?.methodName ?? 'N/A',
                            style: context.textTheme.titleMedium,
                          ),
                          Text(
                            '${Translator.estimated(context)}: ${checkout.shipping?.duration ?? 'N/A'} days',
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),

            //! payment method
            Container(
              decoration: BoxDecoration(
                borderRadius: defaultRadius,
                color: context.colorTheme.secondaryContainer.withOpacity(0.05),
              ),
              padding: defaultPaddingAll,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Translator.paymentMethod(context),
                    style: context.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (checkout.payment?.isCOD ?? false)
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: defaultRadius,
                            color: context.colorTheme.surface,
                          ),
                          height: 50,
                          width: 50,
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Image.asset(Assets.logo.cod.path),
                          ),
                        )
                      else
                        ClipRRect(
                          borderRadius: defaultRadius,
                          child: HostedImage.square(
                            checkout.payment?.image ?? '',
                            dimension: 50,
                          ),
                        ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            checkout.payment?.name ?? 'N/A',
                            style: context.textTheme.titleMedium,
                          ),
                          Text(
                            '${Translator.charge(context)}: ${checkout.payment?.percentCharge}%',
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (checkout.inputs.isNotEmpty)
              Container(
                decoration: BoxDecoration(
                  borderRadius: defaultRadius,
                  color:
                      context.colorTheme.secondaryContainer.withOpacity(0.05),
                ),
                padding: defaultPaddingAll,
                width: context.width,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payment Information',
                      style: context.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    for (var MapEntry(:key, :value) in checkout.inputs.entries)
                      Text(
                        '$key : $value',
                        style: context.textTheme.titleMedium,
                      ),
                  ],
                ),
              ),

            const SizedBox(height: 15),
            //! Products
            Container(
              decoration: BoxDecoration(
                borderRadius: defaultRadius,
                color: context.colorTheme.secondaryContainer.withOpacity(0.05),
              ),
              padding: defaultPaddingAll,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${Translator.products(context)}: [${carts?.length}]',
                    style: context.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  if (carts == null)
                    Text(Translator.somethingWentWrong(context))
                  else
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: carts.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: CheckoutProductCard(cart: carts[index]),
                        );
                      },
                    ),
                ],
              ),
            ),
            const Divider(height: 40),
            if (isLoggedIn) ...[
              Text(
                Translator.couponCode(context),
                style: context.textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: couponCodeCtrl,
                onSubmitted: (v) {
                  checkoutCtrl().setCoupon(v);
                  couponCodeCtrl.clear();
                },
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.discount_outlined),
                  hintText: Translator.enterCoupon(context),
                  suffixIcon: TextButton(
                    onPressed: () {
                      checkoutCtrl().setCoupon(couponCodeCtrl.text);
                      couponCodeCtrl.clear();
                    },
                    child: Text(Translator.apply(context)),
                  ),
                ),
              ),
              if (checkout.couponCode.isNotEmpty) ...[
                const SizedBox(height: 10),
                SpacedText.diffStyle(
                  leftText: Translator.yourCoupon(context),
                  rightText: checkout.couponCode,
                  styleRight: context.textTheme.titleMedium,
                  rightAction: IconButton(
                    padding: const EdgeInsets.all(3),
                    constraints: const BoxConstraints(),
                    onPressed: () => checkoutCtrl().setCoupon(''),
                    icon: const Icon(Icons.cancel_outlined),
                  ),
                ),
                const Row(
                  children: [
                    Icon(Icons.info_outline_rounded),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text('The coupon will be applied at checkout'),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 15),
            ],
            Container(
              decoration: BoxDecoration(
                borderRadius: defaultRadius,
                color: context.colorTheme.secondaryContainer.withOpacity(0.05),
              ),
              padding: defaultPaddingAll,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Translator.billingInfo(context),
                    style: context.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  SpacedText(
                    leftText: Translator.subTotal(context),
                    rightText: subTotal.fromLocal(local, !isLoggedIn),
                  ),
                  const SizedBox(height: 5),
                  SpacedText(
                    leftText: Translator.shippingCharge(context),
                    rightText:
                        checkout.shipping?.price.fromLocal(local) ?? 'N/A',
                  ),
                  SpacedText(
                    leftText: Translator.charge(context),
                    rightText: charge.fromLocal(local),
                  ),
                  const SizedBox(height: 5),
                  SpacedText(
                    leftText: Translator.total(context),
                    rightText: (total + charge).fromLocal(local),
                    style: context.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
            const SizedBox(height: 10),
            if (!isLoggedIn) ...[
              Card(
                elevation: 0,
                color: context.colorTheme.secondaryContainer.withOpacity(0.05),
                child: CheckboxListTile(
                  title: Text(Translator.registerWithEmail(context)),
                  controlAffinity: ListTileControlAffinity.leading,
                  value: checkout.createAccount,
                  onChanged: (v) => checkoutCtrl().toggleCreateAccount(),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.info_outline_rounded),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(Translator.submitWithoutAccountWarn(context)),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

class CheckoutProductCard extends ConsumerWidget {
  const CheckoutProductCard({
    required this.cart,
    super.key,
  });
  final CartData cart;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final local = ref.watch(localeCurrencyStateProvider);
    return Container(
      decoration: BoxDecoration(
        borderRadius: defaultRadius,
        color: context.colorTheme.surface,
      ),
      child: Padding(
        padding: defaultPaddingAll,
        child: Row(
          children: [
            ClipRRect(
              child: HostedImage.square(
                cart.product.featuredImage,
                dimension: 80,
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cart.product.name,
                    style: context.textTheme.bodyLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    (cart.product.isDiscounted
                            ? cart.product.discountAmount
                            : cart.product.price)
                        .fromLocal(local),
                    style: context.textTheme.bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text('x${cart.quantity}'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
