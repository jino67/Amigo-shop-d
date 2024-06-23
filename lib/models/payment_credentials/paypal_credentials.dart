class PaypalCredentials {
  PaypalCredentials({
    required this.environment,
    required this.clientId,
    required this.secret,
    required this.note,
  });

  factory PaypalCredentials.fromMap(Map<String, dynamic> map) {
    return PaypalCredentials(
      environment: map["environment"],
      clientId: map["client_id"],
      secret: map["secret"],
      note: map["note"],
    );
  }

  final String environment;
  final String clientId;
  final String secret;
  final String note;
  bool get isSandbox => environment == 'sandbox';
}
