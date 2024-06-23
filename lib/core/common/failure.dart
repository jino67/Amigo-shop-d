import 'package:fpdart/fpdart.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;

class Failure {
  const Failure(this.message, {this.stackTrace, this.error});

  final String message;
  final Object? error;
  final StackTrace? stackTrace;

  Failure copyWith({
    String? message,
    String? error,
    StackTrace? stackTrace,
  }) {
    return Failure(
      message ?? this.message,
      stackTrace: stackTrace ?? this.stackTrace,
      error: error ?? this.error,
    );
  }

  @override
  String toString() {
    return 'Failure(\nmessage: $message,\nerror: $error\n)';
  }
}
