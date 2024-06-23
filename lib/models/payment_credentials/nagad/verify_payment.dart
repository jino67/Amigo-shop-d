import 'dart:convert';

import 'package:e_com/core/core.dart';
import 'package:e_com/models/models.dart';

class NagadVerifyPaymentData {
  NagadVerifyPaymentData({
    required this.merchantId,
    required this.orderId,
    required this.paymentRefId,
    required this.amount,
    required this.clientMobileNo,
    required this.merchantMobileNo,
    required this.orderDateTime,
    required this.issuerPaymentDateTime,
    required this.issuerPaymentRefNo,
    required this.additionalMerchantInfo,
    required this.status,
    required this.statusCode,
  });

  factory NagadVerifyPaymentData.fromJson(String source) =>
      NagadVerifyPaymentData.fromMap(json.decode(source));

  factory NagadVerifyPaymentData.fromMap(Map<String, dynamic> map) {
    return NagadVerifyPaymentData(
      merchantId: map['merchantId'] ?? '',
      orderId: map['orderId'] ?? '',
      paymentRefId: map['paymentRefId'] ?? '',
      amount: map['amount'] ?? '',
      clientMobileNo: map['clientMobileNo'] ?? '',
      merchantMobileNo: map['merchantMobileNo'] ?? '',
      orderDateTime: map['orderDateTime'] ?? '',
      issuerPaymentDateTime: map['issuerPaymentDateTime'] ?? '',
      issuerPaymentRefNo: map['issuerPaymentRefNo'] ?? '',
      additionalMerchantInfo: map['additionalMerchantInfo'] ?? '',
      status: NagadPaymentStatus.fromString(map['status']),
      statusCode: map['statusCode'] ?? '',
    );
  }

  final String additionalMerchantInfo;
  final String amount;
  final String clientMobileNo;
  final String issuerPaymentDateTime;
  final String issuerPaymentRefNo;
  final String merchantId;
  final String merchantMobileNo;
  final String orderDateTime;
  final String orderId;
  final String paymentRefId;
  final NagadPaymentStatus status;
  final String statusCode;

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'merchantId': merchantId});
    result.addAll({'orderId': orderId});
    result.addAll({'paymentRefId': paymentRefId});
    result.addAll({'amount': amount});
    result.addAll({'clientMobileNo': clientMobileNo});
    result.addAll({'merchantMobileNo': merchantMobileNo});
    result.addAll({'orderDateTime': orderDateTime});
    result.addAll({'issuerPaymentDateTime': issuerPaymentDateTime});
    result.addAll({'issuerPaymentRefNo': issuerPaymentRefNo});
    result.addAll({'additionalMerchantInfo': additionalMerchantInfo});
    result.addAll({'status': status.name.titleCaseSingle});
    result.addAll({'statusCode': statusCode});

    return result;
  }

  String toJson() => json.encode(toMap());
}
