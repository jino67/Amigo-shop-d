class StripeParam {
  StripeParam({
    required this.publishableKey,
    required this.secretKey,
  });

  factory StripeParam.fromMap(Map<String, dynamic> map) {
    return StripeParam(
      publishableKey: map['publishable_key'] ?? '',
      secretKey: map['secret_key'] ?? '',
    );
  }

  final String publishableKey;
  final String secretKey;
}
