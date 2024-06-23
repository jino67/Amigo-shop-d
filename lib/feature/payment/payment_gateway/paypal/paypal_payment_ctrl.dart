// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:e_com/core/core.dart';
import 'package:e_com/feature/check_out/providers/provider.dart';
import 'package:e_com/feature/payment/repository/payment_repo.dart';
import 'package:e_com/models/models.dart';
import 'package:e_com/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final paypalPaymentCtrlProvider = StateNotifierProvider.autoDispose
    .family<PaypalPaymentCtrlNotifier, String?, PaymentData>(
        (ref, data) => PaypalPaymentCtrlNotifier(ref, data));

class PaypalPaymentCtrlNotifier extends StateNotifier<String?> {
  PaypalPaymentCtrlNotifier(this._ref, this.paymentData) : super(null);

  final PaymentData paymentData;
  final Ref _ref;

  OrderBaseModel? get _order => _ref.read(checkoutStateProvider);

  String get _baseUrl => _cred.isSandbox
      ? "https://api-m.sandbox.paypal.com"
      : "https://api.paypal.com/v1";

  String get authToken =>
      base64.encode(utf8.encode("${_cred.clientId}:${_cred.secret}"));

  Dio get _dio => Dio()
    ..options = BaseOptions(baseUrl: _baseUrl)
    ..interceptors.add(talk.dioLogger);

  String get returnURL => paymentData.callbackUrl;

  PaypalCredentials get _cred => PaypalCredentials(
        environment: 'sandbox',
        clientId:
            'AbtlUzBXZcWcG8Lh6Irv3Ek70zVVYgGw3wi2f44CEVcty2U41Q8ClOfl3EHIVtBfM32LDRwukaOQVfo1',
        secret:
            'EDKZl4w2XLskSXyIqgDPLcTmh-_g6T-erM9pBSdwm8uTIwiCdAjXo_lCB-stYIw_Mio4zNwuX4lxF5iB',
        note: '',
      );
  // PaypalCredentials get _cred =>
  //     PaypalCredentials.fromMap(paymentData.paymentParameter);

  Future<String> _getAccessToken() async {
    try {
      final data = {'grant_type': 'client_credentials'};

      final response = await _dio.post(
        '/v1/oauth2/token',
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Basic $authToken',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );

      final token = response.data['access_token'];

      return token;
    } on DioException {
      return '';
    }
  }

  Future<void> initializePayment(BuildContext context) async {
    try {
      Toaster.showLoading('Redirecting to PayPal...');
      final token = await _getAccessToken();

      if (token.isEmpty) {
        Toaster.showError(Translator.somethingWentWrong(context));
        return;
      }

      final response = await _dio.post(
        '/v2/checkout/orders',
        data: transactionData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      final body = response.data;

      final links = List<Map<String, dynamic>>.from(body['links']);

      String url = '';

      for (final link in links) {
        final parse = Map<String, String>.from(link);
        if (parse['rel'] == 'approve') {
          url = parse['href'] ?? '';
        }
      }

      if (url.isEmpty) {
        Toaster.showError(Translator.somethingWentWrong(context));
        return;
      }
      Toaster.remove();
      RouteNames.paypalPayment.goNamed(context, extra: url);
    } on DioException catch (err) {
      Toaster.showError(err.message);
    }
  }

  String get transactionData => json.encode(
        {
          "intent": "CAPTURE",
          "purchase_units": [
            {
              "invoice_id": _order!.paymentLog.trx,
              "amount": {
                "currency_code": paymentData.currency.name,
                "value": _order!.paymentLog.finalAmount,
              }
            }
          ],
          "application_context": {
            "return_url": returnURL,
            "cancel_url": "https://example.com/cancel"
          }
        },
      );

  executePayment(BuildContext context, Uri? url) async {
    final body = url!.queryParameters;
    final payerID = body['PayerID'];

    final trx = _order!.paymentLog.trx;

    final callbackUrl = '${paymentData.callbackUrl}/$trx/$payerID';
    await PaymentRepo().confirmPayment(context, body, callbackUrl);
  }
}
