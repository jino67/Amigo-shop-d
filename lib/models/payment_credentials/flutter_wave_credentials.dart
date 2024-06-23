class FlutterWaveCredentials {
  FlutterWaveCredentials({
    required this.note,
    required this.publicKey,
    required this.secretKey,
    required this.secretHash,
    required this.isSandbox,
  });

  factory FlutterWaveCredentials.fromMap(Map<String, dynamic> map) {
    return FlutterWaveCredentials(
      note: map["note"],
      publicKey: map["public_key"],
      secretKey: map["secret_key"],
      secretHash: map["secret_hash"],
      isSandbox: map["is_sandbox"] ?? true,
    );
  }

  final String note;
  final String publicKey;
  final String secretKey;
  final String secretHash;
  final bool isSandbox;
}
