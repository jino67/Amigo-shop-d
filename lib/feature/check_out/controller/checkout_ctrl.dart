import 'package:e_com/core/core.dart';
import 'package:e_com/feature/auth/controller/auth_ctrl.dart';
import 'package:e_com/feature/cart/controller/carts_ctrl.dart';
import 'package:e_com/feature/check_out/repository/checkout_repo.dart';
import 'package:e_com/feature/settings/provider/settings_provider.dart';
import 'package:e_com/feature/user_dash/controller/dash_ctrl.dart';
import 'package:e_com/feature/user_dash/provider/user_dash_provider.dart';
import 'package:e_com/locator.dart';
import 'package:e_com/models/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final checkoutCtrlProvider =
    AutoDisposeNotifierProvider<CheckoutCtrlNotifier, CheckoutModel>(
        CheckoutCtrlNotifier.new);

class CheckoutCtrlNotifier extends AutoDisposeNotifier<CheckoutModel> {
  @override
  CheckoutModel build() {
    final billing = ref
        .watch(userDashProvider.select((value) => value?.user.billingAddress));

    final carts = ref
        .watch(cartCtrlProvider.select((data) => data.valueOrNull?.listData));

    return CheckoutModel.empty.copyWith(
      billingAddress: billing?.firstOrNull,
      carts: carts,
    );
  }

  CheckoutRepo get _repo => ref.watch(checkoutRepoProvider);

  void setShipping(ShippingData shippingUid) =>
      state = state.copyWith(shippingUid: shippingUid);

  void setPayment(PaymentData payment) {
    final iCodActive = ref.watch(
        settingsProvider.select((v) => v?.settings.cashOnDelivery ?? false));
    if (payment.isCOD && !iCodActive) {
      Toaster.showError('Cash on delivery is not available');
      return;
    }

    state = state.copyWith(payment: payment, inputs: {});
  }

  void setCodPayment() =>
      state = state.copyWith(payment: PaymentData.codPayment);

  void setBilling(BillingAddress billing) =>
      state = state.copyWith(billingAddress: billing);

  void setCoupon(String coupon) => state = state.copyWith(couponCode: coupon);

  void toggleCreateAccount() {
    state = state.copyWith(createAccount: !state.createAccount);
  }

  void setCustomInputData(Map<String, dynamic> inputs) {
    state = state.copyWith(inputs: inputs);
  }

  Future<bool> submitOrder() async {
    final isLoggedIn = ref.read(authCtrlProvider);

    final res = await _repo.submitOrder(state, !isLoggedIn);

    return await res.fold(
      (l) async {
        Toaster.showError(l);
        return false;
      },
      (r) async {
        if (state.createAccount && r.data.accessToken != null) {
          await ref
              .read(authCtrlProvider.notifier)
              .setWildAccessToken(r.data.accessToken!);
        }

        await _setOrderBaseState(r.data);
        await ref.read(cartCtrlProvider.notifier).clearGuestCart();

        if (isLoggedIn) await ref.read(userDashCtrlProvider.notifier).reload();

        Toaster.showSuccess(r.data.message);
        return true;
      },
    );
  }

  _setOrderBaseState(OrderBaseModel order) async {
    final pref = locate<SharedPreferences>();
    await pref.setString(CachedKeys.orderBase, order.toJson());
  }

  Future<void> buyNow({
    required String productUid,
    required String digitalUid,
    required int paymentUid,
    required String email,
    Function()? onSuccess,
  }) async {
    final isLoggedIn = ref.read(authCtrlProvider);
    final data = {
      'product_uid': productUid,
      'payment_id': paymentUid,
      'digital_attribute_uid': digitalUid,
      // 'country': 'Bangladesh',
      if (!isLoggedIn) 'email': email,
    };

    Toaster.showLoading('Loading...');
    final res = await _repo.submitDigitalOrder(data: data);

    res.fold(
      (l) => Toaster.showError(l),
      (r) async {
        await _setOrderBaseState(r.data);
        Toaster.showSuccess(r.data.message);
        onSuccess?.call();
      },
    );
    if (isLoggedIn) ref.read(userDashCtrlProvider.notifier).reload();
  }
}
