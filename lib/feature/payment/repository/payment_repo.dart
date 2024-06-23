import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:e_com/core/core.dart';
import 'package:e_com/routes/routes.dart';
import 'package:flutter/material.dart';

class PaymentRepo {
  PaymentRepo();

  Future<void> confirmPayment(
    BuildContext context,
    Map<String, dynamic> body,
    String callBack, {
    String method = 'POST',
  }) async {
    try {
      final dio = Dio()..interceptors.add(talk.dioLogger);

      final options = Options(
        method: method,
        headers: {'Accept': 'application/json'},
      );

      final response =
          await dio.request(callBack, data: body, options: options);

      final res = json.decode(response.data);

      if (!context.mounted) {
        Toaster.showInfo('Unknown error\n${res['message']}');
        return;
      }

      RouteNames.afterPayment.goNamed(
        context,
        query: {'status': 's'},
      );
    } on DioException catch (e) {
      Toaster.showError(e.response?.data['message']);
    }
  }


   Future<void> addSlice(
    BuildContext context,
    Map<String, dynamic> body, {
    String method = 'POST',
  }) async {
    try {
      final dio = Dio()..interceptors.add(talk.dioLogger);

      final options = Options(
        method: method,
        headers: {'Accept': 'application/json'},
      );

      final response =
          await dio.request("https://amigo-shop.goaicorporation.org/api/payment/slice", data: body, options: options);


      RouteNames.afterPayment.goNamed(
        context,
        query: {'status': 's'},
      );
    } on DioException catch (e) {
      Toaster.showError(e.response?.data['message']);
    }
  }
}
