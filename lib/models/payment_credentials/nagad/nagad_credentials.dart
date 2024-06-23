class NagadCredentials {
  const NagadCredentials({
    required this.publicKey,
    required this.privateKey,
    required this.merchantId,
    required this.merchantNumber,
    required this.isSandbox,
  });

  factory NagadCredentials.fromMap(Map<String, dynamic> map) =>
      NagadCredentials(
        isSandbox: map["environment"] == "sandbox",
        merchantId: map["merchant_id"],
        merchantNumber: map["merchant_number"],
        privateKey: map["private_key"],
        publicKey: map["public_key"],
      );

  final bool isSandbox;
  final String merchantId;
  final String merchantNumber;
  final String privateKey;
  final String publicKey;
}

enum NagadPaymentStatus {
  success,
  orderInitiated,
  ready,
  inProgress,
  cancelled,
  invalidRequest,
  fraud,
  aborted,
  unknownFailed;

  String checkOutStatus() => switch (this) {
        success => "success",
        orderInitiated => 'failed',
        ready => 'failed',
        inProgress => 'failed',
        cancelled => 'cancelled',
        invalidRequest => 'failed',
        fraud => 'failed',
        aborted => 'failed',
        unknownFailed => 'failed',
      };

  factory NagadPaymentStatus.fromString(String status) {
    switch (status) {
      case "Success":
        return NagadPaymentStatus.success;
      case "OrderInitiated":
        return NagadPaymentStatus.orderInitiated;
      case "Ready":
        return NagadPaymentStatus.ready;
      case "InProgress":
        return NagadPaymentStatus.inProgress;
      case "Cancelled":
        return NagadPaymentStatus.cancelled;
      case "InvalidRequest":
        return NagadPaymentStatus.invalidRequest;
      case "Fraud":
        return NagadPaymentStatus.fraud;
      case "Aborted":
        return NagadPaymentStatus.aborted;
      default:
        return NagadPaymentStatus.unknownFailed;
    }
  }
}
