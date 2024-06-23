import 'dart:async';

import 'package:e_com/core/core.dart';
import 'package:e_com/feature/check_out/providers/provider.dart';
import 'package:e_com/feature/check_out/repository/checkout_repo.dart';
import 'package:e_com/feature/payment/payment_gateway/nagad/nagad_payment_ctrl.dart';
import 'package:e_com/feature/payment/payment_gateway/payment_gateway.dart';
import 'package:e_com/models/models.dart';
import 'package:e_com/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final paymentCtrlProvider =
    StateNotifierProvider<PaymentCtrl, PaymentData?>((ref) {
  return PaymentCtrl(ref);
});

class PaymentCtrl extends StateNotifier<PaymentData?> {
  PaymentCtrl(this._ref) : super(null);

  final Ref _ref;

  Future<bool> _setPaymentLog(String orderUid, PaymentData method) async {
    final repo = _ref.read(checkoutRepoProvider);
    final res = await repo.getPaymentLog(orderUid, method.id);
    final pref = _ref.read(sharedPrefProvider);
    return await res.fold(
      (l) {
        Toaster.showError(l);
        return false;
      },
      (r) async {
        return await pref.setString(CachedKeys.orderBase, r.data.toJson());
      },
    );
  }

  Future<void> payNow(
    BuildContext context,
    String orderUid,
    PaymentData method,
  ) async {
    Toaster.showLoading('Loading...');
    final didSetLog = await _setPaymentLog(orderUid, method);
    Toaster.remove();

    if (!didSetLog || !context.mounted) return;

    RouteNames.orderPlaced.pushNamed(context, query: {'from': 'payNow'});
  }

  Future<void> initializePaymentWithMethod(
    BuildContext context, {
    PaymentData? method,
  }) async {
    if (_order == null) {
      Toaster.showError(Translator.somethingWentWrong(context));
      return;
    }

    if (method == null) {
      Toaster.showError(Translator.somethingWentWrong(context));
      return;
    }

    state = method;

    
    final paymentMethod = PaymentMethod.fromName(state?.name);


    return switch (paymentMethod) {
      PaymentMethod.stripe => _payWithStripe(context),
      PaymentMethod.paypal => _payWithPaypal(context),
      PaymentMethod.payStack => _payWithPayStack(context),
      PaymentMethod.flutterWave => _payWithFlutterWave(context),
      PaymentMethod.razorPay => _payWithRazorPay(context),
      PaymentMethod.instaMojo => _payWithInstaMojo(context),
      PaymentMethod.bkash => _payWithBkash(context),
      PaymentMethod.nagad => _payWithNagad(context),
      null => Future(() => Translator.somethingWentWrong(context)),
    };
  }

  Future<String> _payWithStripe(BuildContext context) async {
    final stripeCtrl = _ref.read(stripePaymentCtrlProvider(state!).notifier);
    await stripeCtrl.initializePaymentWEB(context);
    return '';
  }

  Future<String> _payWithPaypal(BuildContext context) async {
    final paypalCtrl = _ref.read(paypalPaymentCtrlProvider(state!).notifier);
    await paypalCtrl.initializePayment(context);
    return '';
  }

  Future<String> _payWithPayStack(BuildContext context) async {
    final payStackCtrl = _ref.read(paystackCtrlProvider(state!).notifier);
    await payStackCtrl.initializePayment(context);
    return '';
  }

  Future<String> _payWithFlutterWave(BuildContext context) async {
    await _ref
        .read(flutterWaveCtrlProvider(state!).notifier)
        .initializePayment(context);
    return '';
  }

  Future<String> _payWithRazorPay(BuildContext context) async {
    await _ref
        .read(razorPayPaymentCtrlProvider((state!)))
        .initializePayment(context);
    return '';
  }

  Future<String> _payWithInstaMojo(BuildContext context) async {
    await _ref
        .read(instaMojoCtrlProvider(state!).notifier)
        .initializePayment(context);
    return '';
  }

  Future<String> _payWithBkash(BuildContext context) async {
    await _ref
        .read(bkashPaymentCtrlProvider(state!).notifier)
        .initializePayment(context);
    return '';
  }

  Future<String> _payWithNagad(BuildContext context) async {
    await _ref
        .read(nagadPaymentCtrlProvider(state!).notifier)
        .initializePayment(context);
    return '';
  }

  OrderBaseModel? get _order => _ref.read(checkoutStateProvider);
}
