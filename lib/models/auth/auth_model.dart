enum LoginType {
  manual,
  oAuth;

  String get name => this == manual ? 'manual' : 'o_auth';
}

class AuthAccessToken {
  AuthAccessToken({
    required this.accessToken,
    required this.message,
  });

  factory AuthAccessToken.fromMap(Map<String, dynamic> map) {
    return AuthAccessToken(
      accessToken: map['access_token'],
      message: map['message'],
    );
  }

  final String? accessToken;
  final String? message;
}
