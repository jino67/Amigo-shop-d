import 'dart:convert';

import 'package:e_com/models/models.dart';

class OrderBaseModel {
  OrderBaseModel({
    required this.message,
    required this.order,
    required this.paymentLog,
    this.accessToken,
  });

  factory OrderBaseModel.fromJson(String json) {
    return OrderBaseModel.fromMap(jsonDecode(json));
  }

  factory OrderBaseModel.fromMap(Map<String, dynamic> map) {
    return OrderBaseModel(
      message: map['message'] ?? '',
      order: OrderModel.fromMap(map['order']),
      paymentLog: PaymentLog.fromMap(map['payment_log']),
      accessToken: map['access_token'] is String ? map['access_token'] : null,
    );
  }

  final String message;
  final String? accessToken;
  final OrderModel order;
  final PaymentLog paymentLog;

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'order': order.toMap(),
      'payment_log': paymentLog.toMap(),
      'access_token': accessToken,
    };
  }

  String toJson() => jsonEncode(toMap());
}
