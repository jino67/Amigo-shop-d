// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:e_com/core/core.dart';
import 'package:e_com/feature/check_out/providers/provider.dart';
import 'package:e_com/feature/payment/repository/payment_repo.dart';
import 'package:e_com/models/models.dart';
import 'package:e_com/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final paystackCtrlProvider =
    StateNotifierProvider.family<PaystackCtrlNotifier, String, PaymentData>(
        (ref, paymentData) {
  return PaystackCtrlNotifier(ref, paymentData);
});

class PaystackCtrlNotifier extends StateNotifier<String> {
  PaystackCtrlNotifier(this._ref, this.paymentData) : super('');

  final Ref _ref;
  final PaymentData paymentData;

  final _dio = Dio()..interceptors.add(talk.dioLogger);

  PaystackCredentials get _cred =>
      PaystackCredentials.fromMap(paymentData.paymentParameter);

  String get callbackUrl =>
      '${paymentData.callbackUrl}/${_order!.paymentLog.trx}';

  final _baseUrl = 'https://api.paystack.co/transaction';

  Future<void> initializePayment(BuildContext context) async {
    try {
      Toaster.showLoading('Redirecting to paystack...');
      final headers = {'Authorization': 'Bearer ${_cred.secretKey}'};

      final response = await _dio.post(
        '$_baseUrl/initialize',
        options: Options(headers: headers),
        data: {
          'email': _order!.order.billingInformation!.email,
          'amount': _order!.paymentLog.finalAmount.round(),
          'callback_url': callbackUrl,
        },
      );

      state = response.data['data']['reference'];
      final uri = response.data['data']['authorization_url'];
      Toaster.remove();
      RouteNames.paystackPayment.goNamed(context, extra: uri);
    } on DioException catch (e) {
      Toaster.showError(e.response?.data['message']);
    }
  }

  Future<void> executePayment(BuildContext context, Uri? url) async {
    final body = url!.queryParameters;
    final trx = _order!.paymentLog.trx;
    final callbackUrl = '${paymentData.callbackUrl}/$trx';
    await PaymentRepo().confirmPayment(context, body, callbackUrl);
  }

  OrderBaseModel? get _order => _ref.read(checkoutStateProvider);
}
