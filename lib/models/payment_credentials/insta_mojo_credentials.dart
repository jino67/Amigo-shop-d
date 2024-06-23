class InstaMojoCredentials {
  InstaMojoCredentials({
    required this.note,
    required this.apiKey,
    required this.authToken,
    required this.salt,
    required this.isSandbox,
  });

  factory InstaMojoCredentials.fromMap(Map<String, dynamic> map) {
    return InstaMojoCredentials(
      note: map["note"],
      apiKey: map["api_key"],
      authToken: map["auth_token"],
      salt: map["salt"],
      isSandbox: map["is_sandbox"] ?? true,
    );
  }

  final String note;
  final String apiKey;
  final String authToken;
  final String salt;
  final bool isSandbox;
}
