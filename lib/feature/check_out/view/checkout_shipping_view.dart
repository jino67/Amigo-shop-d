import 'package:e_com/core/core.dart';
import 'package:e_com/feature/auth/controller/auth_ctrl.dart';
import 'package:e_com/feature/check_out/controller/checkout_ctrl.dart';
import 'package:e_com/feature/check_out/view/local/address_card.dart';
import 'package:e_com/feature/check_out/view/local/billing_address_fields.dart';
import 'package:e_com/feature/check_out/view/local/selectable_card.dart';
import 'package:e_com/feature/region_settings/provider/region_provider.dart';
import 'package:e_com/feature/settings/controller/settings_ctrl.dart';
import 'package:e_com/feature/settings/provider/settings_provider.dart';
import 'package:e_com/models/user_content/billing_address.dart';
import 'package:e_com/routes/routes.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CheckoutShippingView extends HookConsumerWidget {
  const CheckoutShippingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final local = ref.watch(localeCurrencyStateProvider);
    final settings = ref.watch(settingsProvider);

    final checkoutCtrl =
        useCallback(() => ref.read(checkoutCtrlProvider.notifier));
    final checkout = ref.watch(checkoutCtrlProvider);

    final formKey = useMemoized(GlobalKey<FormBuilderState>.new);

    final isLoggedIn = ref.watch(authCtrlProvider);
    if (settings == null) return ErrorView.withScaffold('Settings not found');

    return Scaffold(
      appBar: KAppBar(
        title: Text(Translator.checkout(context)),
        leading: SquareButton.backButton(
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: defaultPadding,
        child: RefreshIndicator(
          onRefresh: () => ref.read(settingsCtrlProvider.notifier).reload(),
          child: SingleChildScrollView(
            physics: defaultScrollPhysics,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                //! shipping details
                if (!isLoggedIn)
                  FormBuilder(
                    key: formKey,
                    child: const BillingAddressFields(),
                  )
                else
                  AddressCard(checkout: checkout),

                const SizedBox(height: 30),

                //! Delivery Method
                Text(
                  Translator.shoppingMethod(context),
                  style: context.textTheme.titleLarge,
                ),
                const SizedBox(height: 15),
                ScrollableFlex(
                  clipBehavior: Clip.none,
                  children: [
                    ...settings.shippingData.data.map(
                      (e) => SelectableCard(
                        header: HostedImage(
                          e.image,
                          height: 50,
                          width: 90,
                          fit: BoxFit.contain,
                        ),
                        isSelected: checkout.shipping?.uid == e.uid,
                        onTap: () {
                          checkoutCtrl().setShipping(e);
                        },
                        title: Text(
                          e.methodName,
                          textAlign: TextAlign.center,
                        ),
                        subTitle: Text(e.price.fromLocal(local)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: defaultPaddingAll,
        child: SubmitButton(
          width: context.width,
          onPressed: () {
            // if user is Guest validate billing fields and save them
            if (!isLoggedIn) {
              final isValid = formKey.currentState?.saveAndValidate(
                autoScrollWhenFocusOnInvalid: true,
              );
              if (isValid != true) return;

              final data = formKey.currentState!.value;
              checkoutCtrl().setBilling(BillingAddress.fromMap(data));
            }

            if (checkout.shipping == null) {
              Toaster.showError(Translator.selectShippingMethod(context));
              return;
            }

            if (ref.watch(checkoutCtrlProvider).billingAddress == null) {
              Toaster.showError(Translator.nextPay(context));
              return;
            }
            RouteNames.checkoutPayment.pushNamed(context);
          },
          child: Text(Translator.nextPay(context)),
        ),
      ),
    );
  }
}
