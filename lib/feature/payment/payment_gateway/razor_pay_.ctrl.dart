// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:e_com/core/core.dart';
import 'package:e_com/feature/check_out/providers/provider.dart';
import 'package:e_com/feature/payment/repository/payment_repo.dart';
import 'package:e_com/models/models.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

final razorPayPaymentCtrlProvider =
    Provider.family.autoDispose<RazorPayPaymentCtrl, PaymentData>((ref, data) {
  return RazorPayPaymentCtrl(ref, data);
});

class RazorPayPaymentCtrl {
  RazorPayPaymentCtrl(this._ref, this.paymentData);

  final PaymentData paymentData;
  final razorPay = Razorpay();

  final Ref _ref;

  Future<void> initializePayment(BuildContext context) async {
    razorPay.on(
      Razorpay.EVENT_PAYMENT_SUCCESS,
      (res) => _handlePaymentSuccess(context, res),
    );

    razorPay.on(
      Razorpay.EVENT_PAYMENT_ERROR,
      (res) => _handlePaymentError(context, res),
    );

    razorPay.on(
      Razorpay.EVENT_EXTERNAL_WALLET,
      (res) => _handleExternalWallet(context, res),
    );

    final details = _order!.order;
    final amount = _order!.paymentLog.finalAmount;
    final orderId = await createOrder();

    final options = {
      'key': _creds.razorpayKey,
      'amount': (amount * 100).toInt(),
      'name': details.orderDetails.firstOrNull?.product?.name ?? details.uid,
      'order_id': orderId,
      'currency': paymentData.currency.name,
      'description':
          'Payment for ${details.orderDetails.firstOrNull?.product?.name}',
      'prefill': {
        'name': details.billingInformation!.fullName,
        'contact': details.billingInformation!.phone,
        'email': details.billingInformation!.email,
      }
    };

    razorPay.open(options);
  }

  Future<String> createOrder() async {
    final dio = Dio()..interceptors.add(talk.dioLogger);

    final amount = _order!.paymentLog.finalAmount;
    final orderBody = {
      "amount": (amount * 100).toInt(),
      "currency": paymentData.currency.name,
      "receipt": _order!.paymentLog.trx,
    };
    final auth = base64
        .encode(utf8.encode('${_creds.razorpayKey}:${_creds.razorpaySecret}'));

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $auth'
    };

    final response = await dio.post(
      'https://api.razorpay.com/v1/orders',
      data: orderBody,
      options: Options(headers: headers),
    );

    return response.data['id'];
  }

  void clear() => razorPay.clear();

  RazorPayCredentials get _creds =>
      RazorPayCredentials.fromMap(paymentData.paymentParameter);

  void _handlePaymentSuccess(
    BuildContext context,
    PaymentSuccessResponse response,
  ) async {
    final data = <String, String?>{
      'razorpay_payment_id': response.paymentId,
      'razorpay_order_id': response.orderId,
      'razorpay_signature': response.signature,
    };

    await _confirmCheckout(context, data);
    clear();
  }

  void _handlePaymentError(context, PaymentFailureResponse response) async {
    final data = <String, dynamic>{
      'code': response.code,
      'message': response.message,
      'error': response.error,
    };

    await _confirmCheckout(context, data);
    clear();
  }

  void _handleExternalWallet(context, ExternalWalletResponse response) {
    clear();
  }

  // calls checkout api from backend
  Future<void> _confirmCheckout(context, Map<String, dynamic> data) async {
    final trx = _order!.paymentLog.trx;
    final callBack = '${paymentData.callbackUrl}/$trx';
    Toaster.showLoading('Confirming Payment...');

    await PaymentRepo().confirmPayment(context, data, callBack);
    Toaster.remove();
  }

  OrderBaseModel? get _order => _ref.read(checkoutStateProvider);
}
