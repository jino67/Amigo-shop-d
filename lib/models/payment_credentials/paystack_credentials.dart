class PaystackCredentials {
  PaystackCredentials({
    required this.publicKey,
    required this.secretKey,
  });

  factory PaystackCredentials.fromMap(Map<String, dynamic> map) {
    return PaystackCredentials(
      publicKey: map['public_key'] ?? '',
      secretKey: map['secret_key'] ?? '',
    );
  }

  final String publicKey;
  final String secretKey;

  @override
  String toString() => ' publicKey: $publicKey,\n secretKey: $secretKey';
}
