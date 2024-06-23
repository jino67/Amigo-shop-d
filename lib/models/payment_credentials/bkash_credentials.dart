class BkashCredentials {
  BkashCredentials({
    required this.isSandbox,
    required this.userName,
    required this.password,
    required this.apiKey,
    required this.apiSecret,
    required this.note,
  });

  factory BkashCredentials.fromMap(Map<String, dynamic> map) {
    return BkashCredentials(
      apiKey: map['api_key'] ?? '',
      apiSecret: map['api_secret'] ?? '',
      isSandbox: map['environment'] == 'sandbox',
      note: map['note'] ?? '',
      password: map['password'] ?? '',
      userName: map['user_name'] ?? '',
    );
  }

  final String apiKey;
  final String apiSecret;
  final bool isSandbox;
  final String note;
  final String password;
  final String userName;
}
