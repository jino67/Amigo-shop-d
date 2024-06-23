import 'dart:io' as io;

class TicketCreateModel {
  TicketCreateModel({
    required this.name,
    required this.email,
    required this.subject,
    required this.message,
    required this.files,
  });

  final String email;
  final List<io.File> files;
  final String message;
  final String name;
  final String subject;

  TicketCreateModel copyWith({
    String? email,
    List<io.File>? files,
    String? message,
    String? name,
    String? subject,
  }) {
    return TicketCreateModel(
      email: email ?? this.email,
      files: files ?? this.files,
      message: message ?? this.message,
      name: name ?? this.name,
      subject: subject ?? this.subject,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'subject': subject,
      'message': message,
    };
  }

  static TicketCreateModel empty = TicketCreateModel(
    email: '',
    files: [],
    message: '',
    name: '',
    subject: '',
  );
}
