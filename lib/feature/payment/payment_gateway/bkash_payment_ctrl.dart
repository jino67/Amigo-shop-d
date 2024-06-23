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

final bkashPaymentCtrlProvider =
    StateNotifierProvider.family<BkashPaymentCtrl, String?, PaymentData>(
        (ref, paymentData) {
  return BkashPaymentCtrl(ref, paymentData);
});

class BkashPaymentCtrl extends StateNotifier<String?> {
  BkashPaymentCtrl(this._ref, this.paymentData) : super(null);

  final Ref _ref;
  final PaymentData paymentData;
  BkashCredentials get _bkashCreds =>
      BkashCredentials.fromMap(paymentData.paymentParameter);

  _goToPage(BuildContext context, String url) =>
      RouteNames.bkashPayment.goNamed(context, extra: url);

  String get _baseUrl =>
      "https://tokenized.${_bkashCreds.isSandbox ? "sandbox" : "pay"}.bka.sh/v1.2.0-beta";

  String get callback => '${paymentData.callbackUrl}/${_order!.paymentLog.trx}';

  final _dio = Dio()..interceptors.add(talk.dioLogger);

  Future<String?> _createToken() async {
    try {
      final headers = {
        "accept": 'application/json',
        "username": _bkashCreds.userName,
        "password": _bkashCreds.password,
        'content-type': 'application/json'
      };
      final body = {
        "app_key": _bkashCreds.apiKey,
        "app_secret": _bkashCreds.apiSecret,
      };
      final response = await _dio.post(
        "$_baseUrl/tokenized/checkout/token/grant",
        options: Options(headers: headers),
        data: json.encode(body),
      );

      return response.data['id_token'];
    } on DioException catch (e) {
      Toaster.showError(e.message);
      return null;
    }
  }

  initializePayment(BuildContext context) async {
    try {
      Toaster.showLoading('Redirecting...');
      final token = await _createToken();
      state = token;

      final headers = {
        "accept": 'application/json',
        "Authorization": token,
        "X-APP-Key": _bkashCreds.apiKey,
        'content-type': 'application/json'
      };
      final body = {
        "mode": '0011',
        "payerReference": ' ',
        "callbackURL": callback,
        "amount": _order!.paymentLog.finalAmount,
        "currency": 'BDT',
        "intent": 'sale',
        "merchantInvoiceNumber": _order!.paymentLog.trx,
      };

      final response = await _dio.post(
        "$_baseUrl/tokenized/checkout/create",
        options: Options(headers: headers),
        data: json.encode(body),
      );

      Toaster.remove();

      _goToPage(context, response.data['bkashURL']);
    } on DioException catch (e) {
      Toaster.showError(e.message);
    }
  }

  paymentConfirmation(Uri uri, BuildContext context) async {
    final body = uri.queryParameters;
    final callBack = '${paymentData.callbackUrl}/${_order!.paymentLog.trx}';

    await PaymentRepo().confirmPayment(context, body, callBack);
  }

  OrderBaseModel? get _order => _ref.read(checkoutStateProvider);
}
