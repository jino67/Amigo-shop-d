import 'dart:convert';

class NagadInitPaymentBody {
  const NagadInitPaymentBody({
    required this.accountNumber,
    required this.dateTime,
    required this.sensitiveData,
    required this.signature,
  });

  final String accountNumber;
  final String dateTime;
  final String sensitiveData;
  final String signature;

  Map<String, dynamic> toMap() => {
        "accountNumber": accountNumber,
        "dateTime": dateTime,
        "sensitiveData": sensitiveData,
        "signature": signature,
      };

  String toJson() => json.encode(toMap());
}

class NagadInitSensitiveData {
  const NagadInitSensitiveData({
    required this.merchantId,
    required this.dateTime,
    required this.orderId,
    required this.challenge,
  });

  final String challenge;
  final String dateTime;
  final String merchantId;
  final String orderId;

  Map<String, dynamic> toMap() => {
        "merchantId": merchantId,
        "datetime": dateTime,
        "orderId": orderId,
        "challenge": challenge,
      };

  String toJson() => json.encode(toMap());
}

class NagadInitDecryptedData {
  NagadInitDecryptedData({
    required this.referenceId,
    required this.challenge,
    required this.acceptDateTime,
  });

  factory NagadInitDecryptedData.fromJson(String source) =>
      NagadInitDecryptedData.fromMap(json.decode(source));

  factory NagadInitDecryptedData.fromMap(Map<String, dynamic> map) =>
      NagadInitDecryptedData(
        acceptDateTime: map["acceptDateTime"],
        challenge: map["challenge"],
        referenceId: map["paymentReferenceId"],
      );

  final String acceptDateTime;
  final String challenge;
  final String referenceId;

  Map<String, dynamic> toMap() => {
        "paymentReferenceId": referenceId,
        "challenge": challenge,
        "acceptDateTime": acceptDateTime,
      };

  String toJson() => json.encode(toMap());
}
