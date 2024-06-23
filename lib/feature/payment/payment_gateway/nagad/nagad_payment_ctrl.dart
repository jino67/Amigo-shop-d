// ignore_for_file: use_build_context_synchronously

import 'package:e_com/core/core.dart';
import 'package:e_com/feature/check_out/providers/provider.dart';
import 'package:e_com/feature/payment/repository/payment_repo.dart';
import 'package:e_com/models/models.dart';
import 'package:e_com/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import 'nagad_payment_repo.dart';

final nagadPaymentCtrlProvider =
    StateNotifierProvider.family<NagadPaymentCtrlNotifier, String, PaymentData>(
        (ref, data) {
  return NagadPaymentCtrlNotifier(ref, data);
});

class NagadPaymentCtrlNotifier extends StateNotifier<String> {
  NagadPaymentCtrlNotifier(this._ref, this.paymentData) : super('');

  final Ref _ref;
  final PaymentData paymentData;
  final _encrypter = KEncrypter();

  final callbackUrl = '${Endpoints.baseApiUrl}/nagad/payment/callback';

  NagadCredentials get _cred =>
      NagadCredentials.fromMap(paymentData.paymentParameter);

  NagadPaymentRepo get _repo => _ref.watch(nagadRepoProvider(_cred));
  OrderBaseModel? get _order => _ref.read(checkoutStateProvider);

  /// initialize NAGAD payment
  Future initializePayment(BuildContext context) async {
    try {
      Toaster.showLoading('Redirecting...');

      /// generate hash
      final hash = _encrypter.generateHashString(_orderId);

      /// sensitive data for NAGAD request body
      final sensitiveData = NagadInitSensitiveData(
        merchantId: _cred.merchantId,
        dateTime: _getTimeStamp,
        orderId: _orderId,
        challenge: hash,
      ).toJson();

      /// encrypt sensitive data with public key
      /// and sign with private key
      final encryptedData =
          _encrypter.encryptWithPublicKey(sensitiveData, _cred.publicKey);
      final signature =
          _encrypter.signWithPrivateKey(sensitiveData, _cred.privateKey);

      final body = NagadInitPaymentBody(
        accountNumber: _cred.merchantNumber,
        dateTime: _getTimeStamp,
        sensitiveData: encryptedData,
        signature: signature,
      );

      /// initialize payment request to Nagad api
      final response = await _repo.initializePayment(_orderId, body);

      NagadInitDecryptedData? initData;

      response.fold((l) => null, (r) => initData = r);
      if (initData == null) return;

      /// confirm payment request and get webview url
      final url = await _confirmPayment(initData!);

      Toaster.remove();
      if (url == null) return;

      RouteNames.nagadPayment.goNamed(context, extra: url);
    } on DioException catch (e) {
      Toaster.showError(e.message);
    }
  }

  /// confirm payment request and get webview url
  Future<String?> _confirmPayment(NagadInitDecryptedData data) async {
    /// set payment reference id to state to letter
    state = data.referenceId;

    /// sensitive data for NAGAD payment request confirm body
    final sensitive = NagadConfirmSensitiveData(
      merchantId: _cred.merchantId,
      orderId: _orderId,
      challenge: data.challenge,
      amount: _order!.paymentLog.finalAmount.toString(),
    ).toJson();

    /// encrypt sensitive data with public key
    /// and sign with private key
    final encryptedData =
        _encrypter.encryptWithPublicKey(sensitive, _cred.publicKey);
    final signature =
        _encrypter.signWithPrivateKey(sensitive, _cred.privateKey);

    final body = NagadConfirmPaymentBody(
      sensitiveData: encryptedData,
      signature: signature,
      additionalInfo: {},
      callbackURL: callbackUrl,
    );

    /// confirm payment request to Nagad api
    final response = await _repo.confirmPayment(data.referenceId, body);

    String? url;

    response.fold((l) => null, (r) => url = r);

    return url;
  }

  /// verify payment request and complete checkout
  Future verifyPayment(BuildContext context, Uri? uri) async {
    if (uri == null) return;

    final body = uri.queryParameters;
    final callBack = '${paymentData.callbackUrl}/${_order!.paymentLog.trx}';

    await PaymentRepo().confirmPayment(context, body, callBack);
  }

  String get _getTimeStamp {
    final now = DateTime.now();
    final timeStamp = DateFormat('yyyyMMddHHmmss').format(now);
    return timeStamp;
  }

  String get _orderId => _order!.paymentLog.trx.replaceAll('#', '');
}
