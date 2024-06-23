import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:e_com/core/core.dart';
import 'package:e_com/feature/support_ticket/repository/support_ticket_repo.dart';
import 'package:e_com/models/models.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

final fileDownloaderProvider =
    NotifierProvider<FileDownloaderNotifier, List<FileDownloaderQueueModel>>(
        FileDownloaderNotifier.new);

class FileDownloaderNotifier extends Notifier<List<FileDownloaderQueueModel>> {
  @override
  List<FileDownloaderQueueModel> build() {
    return [];
  }

  void addToQueue(TicketFile file, {bool openable = true}) async {
    final saveDir = await getApplicationDocumentsDirectory();
    final downloadPath = saveDir.path + file.fileName;
    final isExisting = await File(downloadPath).exists();

    state = [
      ...state,
      FileDownloaderQueueModel(
        id: file.id,
        url: '',
        progress: isExisting ? -1 : null,
        downloadPath: downloadPath,
      ),
    ];

    if (isExisting) {
      if (openable) await OpenFilex.open(downloadPath);
      return;
    }
    await _getUrlNDownload(file.id);
  }

  Future<void> _getUrlNDownload(int id) async {
    final res = await ref.watch(supportTicketRepoProvider).getDownloadUrl(id);
    res.fold(
      (l) => Toaster.showError(l),
      (r) async {
        state = [
          for (final file in state)
            if (file.id == id) file.copyWith(url: r.data) else file
        ];
        await _startDownload(id);
      },
    );
  }

  Future<void> _startDownload(int id) async {
    final queuedFile = state.firstWhere((element) => element.id == id);

    try {
      await Dio().download(
        queuedFile.url,
        queuedFile.downloadPath,
        lengthHeader: Headers.contentLengthHeader,
        options: Options(
          // Disables gzip
          headers: {HttpHeaders.acceptEncodingHeader: '*'},
        ),
        onReceiveProgress: (received, total) {
          double? progress = ((received / total) * 100) / 100;
          if (total <= 0) progress = null;
          state = [
            for (final file in state)
              if (file.id == id) file.updateProgress(progress) else file
          ];
        },
      );

      state = [
        for (final file in state)
          if (file.id == id) file.updateProgress(-1) else file
      ];
    } on PlatformException catch (e) {
      Toaster.showError(e.code);
    } on DioException catch (e) {
      Toaster.showError(e.message);
    }
  }
}
