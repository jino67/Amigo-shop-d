class RazorPayCredentials {
  RazorPayCredentials({
    required this.razorpayKey,
    required this.razorpaySecret,
  });

  factory RazorPayCredentials.fromMap(Map<String, dynamic> map) {
    return RazorPayCredentials(
      razorpayKey: map['razorpay_key'] ?? '',
      razorpaySecret: map['razorpay_secret'] ?? '',
    );
  }

  final String razorpayKey;
  final String razorpaySecret;
}
