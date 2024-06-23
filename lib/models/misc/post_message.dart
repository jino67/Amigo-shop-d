class PostMessage {
  PostMessage({required this.message});

  factory PostMessage.fromMap(Map<String, dynamic> map) {
    return PostMessage(
      message: map['message'] ?? '',
    );
  }

  final String message;
}
