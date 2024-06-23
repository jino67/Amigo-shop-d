import 'dart:convert';

class NagadConfirmPaymentBody {
  const NagadConfirmPaymentBody({
    required this.callbackURL,
    required this.additionalInfo,
    required this.sensitiveData,
    required this.signature,
  });

  final String callbackURL;
  final Map<String, String> additionalInfo;
  final String sensitiveData;
  final String signature;

  Map<String, dynamic> toMap() => {
        "merchantCallbackURL": callbackURL,
        "additionalMerchantInfo": Map<String, String>.from(additionalInfo),
        "sensitiveData": sensitiveData,
        "signature": signature,
      };

  String toJson() => json.encode(toMap());
}

class NagadConfirmSensitiveData {
  const NagadConfirmSensitiveData({
    required this.merchantId,
    required this.amount,
    required this.orderId,
    required this.challenge,
    this.currencyCode = '050',
  });

  final String currencyCode;
  final String amount;
  final String merchantId;
  final String orderId;
  final String challenge;

  Map<String, dynamic> toMap() => {
        "merchantId": merchantId,
        "amount": amount,
        "orderId": orderId,
        "currencyCode": currencyCode,
        "challenge": challenge,
      };

  String toJson() => json.encode(toMap());
}
