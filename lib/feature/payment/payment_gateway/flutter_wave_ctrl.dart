import 'dart:io';

import 'package:dio/dio.dart';
import 'package:e_com/core/core.dart';
import 'package:e_com/feature/check_out/providers/provider.dart';
import 'package:e_com/feature/payment/repository/payment_repo.dart';
import 'package:e_com/models/models.dart';
import 'package:e_com/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final flutterWaveCtrlProvider =
    StateNotifierProvider.family<FlutterWaveCtrlNotifier, String, PaymentData>(
        (ref, paymentData) {
  return FlutterWaveCtrlNotifier(ref, paymentData);
});

class FlutterWaveCtrlNotifier extends StateNotifier<String> {
  FlutterWaveCtrlNotifier(this._ref, this.paymentData) : super('');

  final Ref _ref;
  final PaymentData paymentData;

  FlutterWaveCredentials get _creds =>
      FlutterWaveCredentials.fromMap(paymentData.paymentParameter);

  OrderBaseModel? get _order => _ref.read(checkoutStateProvider);


  String get redirectUrl =>
      '${paymentData.callbackUrl}/${_order!.paymentLog.trx}';

  String get transactionId => _order!.paymentLog.trx;

  String get amount => _order!.paymentLog.finalAmount.round().toString();

  bool get isPerSlice => _order!.paymentLog.method.id == 7 ? true : false;



  Future<void> initializePayment(BuildContext context) async {
    print(redirectUrl);

    RouteNames.flutterWavePayment.goNamed(context, extra: "extra");
  }

  Future<void> confirmPayment(context, String transaction_id) async {
    final data ={"tx_ref":transactionId,"status":"success"};
    final callBack =
        '${paymentData.callbackUrl}/${data['tx_ref']}/${data['status']}';

    await PaymentRepo().confirmPayment(context, data, callBack);
  }

  Future<void> addSlice(context, dynamic amount, String transaction_id)
  async {
     final data ={"transaction_id":transactionId,"amount":amount};

     await PaymentRepo().addSlice(context, data);
  }

   Future<void> declinePayment(context) async {
      RouteNames.afterPayment.goNamed(
        context,
        query: {'status': 'f'},
      );
  }
}
