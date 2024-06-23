class SSLcommerzCredentials {
  SSLcommerzCredentials({
    required this.storeId,
    required this.storePassword,
    required this.environment,
  });

  factory SSLcommerzCredentials.fromMap(Map<String, dynamic> map) {
    return SSLcommerzCredentials(
      storeId: map['store_id'] ?? '',
      storePassword: map['store_password'] ?? '',
      environment: map['environment'] == 'sandbox' ? true : false,
    );
  }

  final bool environment;
  final String storeId;
  final String storePassword;
}
