import 'dart:io';

import 'package:dio/dio.dart';
import 'package:e_com/core/core.dart';
import 'package:e_com/models/models.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final supportTicketRepoProvider = Provider<SupportTicketRepo>((ref) {
  return SupportTicketRepo(ref);
});

class SupportTicketRepo {
  SupportTicketRepo(this._ref);

  final Ref _ref;
  DioClient get _dio => DioClient(_ref);

  FutureEither<ApiResponse<SupportTicketList>> getTickets() async {
    try {
      final response = await _dio.get(Endpoints.tickets);

      final res = ApiResponse.fromMap(
        response.data,
        (map) => SupportTicketList.fromMap(map['tickets']),
      );

      return right(res);
    } on DioException catch (e) {
      final failure = DioExp(e).toFailure();
      return left(failure);
    }
  }

  FutureEither<ApiResponse<SupportTicketList>> getTicketsFromUrl(
      String url) async {
    try {
      final response = await _dio.get(url);

      final res = ApiResponse.fromMap(
        response.data,
        (map) => SupportTicketList.fromMap(map['tickets']),
      );

      return right(res);
    } on DioException catch (e) {
      final failure = DioExp(e).toFailure();
      return left(failure);
    }
  }

  FutureEither<ApiResponse<TicketData>> getTicketDetails(
    String ticketNumber,
  ) async {
    try {
      final response = await _dio.get(Endpoints.ticket(ticketNumber));

      final res = ApiResponse.fromMap(
        response.data,
        (map) => TicketData.fromMap(map),
      );

      return right(res);
    } on DioException catch (e) {
      final failure = DioExp(e).toFailure();
      return left(failure);
    }
  }

  FutureEither<ApiResponse<TicketData>> createTicket(
      TicketCreateModel ticket) async {
    try {
      final multiFiles = <MultipartFile>[];
      for (var file in ticket.files) {
        multiFiles.add(await MultipartFile.fromFile(file.path));
      }
      final response = await _dio.post(
        Endpoints.ticketStore,
        data: {
          ...ticket.toMap(),
          'file[]': multiFiles,
        },
      );

      final res = ApiResponse.fromMap(
        response.data,
        (map) => TicketData.fromMap(map),
      );

      return right(res);
    } on DioException catch (e) {
      final failure = DioExp(e).toFailure();
      return left(failure);
    }
  }

  FutureEither<ApiResponse<String>> closeTicket(String ticketId) async {
    try {
      final response = await _dio.get(
        Endpoints.closeTicket(ticketId),
      );

      final res = ApiResponse.fromMap(
        response.data,
        (map) => map['message'] as String,
      );

      return right(res);
    } on DioException catch (e) {
      final failure = DioExp(e).toFailure();
      return left(failure);
    }
  }

  FutureEither<ApiResponse<String>> getDownloadUrl(int fileId) async {
    try {
      final response = await _dio.get(
        Endpoints.ticketFileDownload(fileId.toString()),
      );

      final res = ApiResponse.fromMap(
        response.data,
        (map) => map['url'] as String,
      );

      return right(res);
    } on DioException catch (e) {
      final failure = DioExp(e).toFailure();
      return left(failure);
    }
  }

  FutureEither<ApiResponse<TicketData>> sendReply(
    String ticketId,
    String message,
    List<File> files,
  ) async {
    try {
      final multiFiles = <MultipartFile>[];
      for (var file in files) {
        multiFiles.add(await MultipartFile.fromFile(file.path));
      }

      final response = await _dio.post(
        Endpoints.ticketReply(ticketId),
        data: {
          'message': message,
          'file[]': multiFiles,
        },
      );

      final res = ApiResponse.fromMap(
        response.data,
        (map) => TicketData.fromMap(map),
      );

      return right(res);
    } on DioException catch (e) {
      final failure = DioExp(e).toFailure();
      return left(failure);
    }
  }
}
