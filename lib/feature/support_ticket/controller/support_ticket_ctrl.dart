import 'dart:async';
import 'dart:io';

import 'package:e_com/core/core.dart';
import 'package:e_com/feature/support_ticket/controller/file_downloader_ctrl.dart';
import 'package:e_com/feature/support_ticket/repository/support_ticket_repo.dart';
import 'package:e_com/models/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';

final supportTicketListProvider = AutoDisposeAsyncNotifierProvider<
    SupportTicketListNotifier,
    SupportTicketList>(SupportTicketListNotifier.new);

class SupportTicketListNotifier
    extends AutoDisposeAsyncNotifier<SupportTicketList> {
  @override
  FutureOr<SupportTicketList> build() async {
    final res = await ref.watch(supportTicketRepoProvider).getTickets();
    return res.fold(
      (l) => Future.error(l.message, l.stackTrace),
      (r) => r.data,
    );
  }

  Future<void> refresh() async => ref.invalidateSelf();

  Future<void> paginationHandler({required bool isNext}) async {
    final stateData = await future;
    state = const AsyncValue.loading();
    String? url = stateData.pagination.prevPageUrl;
    if (isNext) url = stateData.pagination.nextPageUrl;

    if (url == null) return;

    final res =
        await ref.watch(supportTicketRepoProvider).getTicketsFromUrl(url);
    res.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = AsyncValue.data(r.data),
    );
  }
}

/// --------------------------------------------------------
/// ticket chat ctrl
/// --------------------------------------------------------

final ticketChatCtrlProvider = AutoDisposeAsyncNotifierProviderFamily<
    TicketChatCtrlNotifier, TicketData, String>(TicketChatCtrlNotifier.new);

class TicketChatCtrlNotifier
    extends AutoDisposeFamilyAsyncNotifier<TicketData, String> {
  @override
  FutureOr<TicketData> build(arg) async {
    final res =
        await ref.watch(supportTicketRepoProvider).getTicketDetails(arg);

    return res.fold(
      (l) => Future.error(l.message, l.stackTrace),
      (r) {
        _fileExistenceCheck(r.data);
        return r.data;
      },
    );
  }

  Future<String?> createTicket(TicketCreateModel ticket) async {
    final res = await ref.read(supportTicketRepoProvider).createTicket(ticket);
    return res.fold(
      (l) => null,
      (r) => r.data.ticket.ticketNumber,
    );
  }

  Future<void> _fileExistenceCheck(TicketData stateData) async {
    final files = stateData.massages
        .map((e) => e.files)
        .expand((element) => element)
        .toList();

    for (var file in files) {
      final saveDir = await getApplicationDocumentsDirectory();
      final downloadPath = saveDir.path + file.fileName;
      final isExisting = await File(downloadPath).exists();
      if (isExisting) {
        ref
            .read(fileDownloaderProvider.notifier)
            .addToQueue(file, openable: false);
      }
    }
  }

  Future<void> sendReply(String reply, List<File> files) async {
    if (reply.isEmpty) return;
    final res =
        await ref.watch(supportTicketRepoProvider).sendReply(arg, reply, files);

    res.fold(
      (l) => Toaster.showError(l),
      (r) => state = AsyncValue.data(r.data),
    );
  }

  Future<void> closeTicket() async {
    final res = await ref.watch(supportTicketRepoProvider).closeTicket(arg);

    res.fold(
      (l) => Toaster.showError(l),
      (r) {
        Toaster.showSuccess(r.data);
        ref.invalidateSelf();
        ref.invalidate(supportTicketListProvider);
      },
    );
  }

  Future<List<File>> pickFiles() async {
    final picker = ref.read(filePickerProvider);

    final res = await picker.pickFiles(allowedExtensions: ticketFileTypes);

    return res.fold(
      (l) {
        Toaster.showError(l);
        return [];
      },
      (r) => r,
    );
  }
}

/// --------------------------------------------------------
/// ticket creation ctrl
/// --------------------------------------------------------

final ticketCreationProvider =
    AutoDisposeNotifierProvider<TicketCreationNotifier, TicketCreateModel>(
        TicketCreationNotifier.new);

class TicketCreationNotifier extends AutoDisposeNotifier<TicketCreateModel> {
  @override
  TicketCreateModel build() {
    return TicketCreateModel.empty;
  }

  setName(String name) => state = state.copyWith(name: name);
  setEmail(String email) => state = state.copyWith(email: email);
  setSubject(String sub) => state = state.copyWith(subject: sub);
  setMassage(String msg) => state = state.copyWith(message: msg);

  Future<void> pickFiles() async {
    final picker = ref.read(filePickerProvider);

    final res = await picker.pickFiles(allowedExtensions: ticketFileTypes);

    res.fold(
      (l) => Toaster.showError(l),
      (r) => state = state.copyWith(files: r),
    );
  }

  Future<void> removeFile(int index) async {
    state = state.copyWith(files: state.files..removeAt(index));
  }

  refreshList() {
    return ref.refresh(supportTicketListProvider);
  }

  Future<String?> createTicket() async {
    if (state.name.isEmpty) {
      Toaster.showError('Name is required');
      return null;
    }
    if (state.email.isEmpty) {
      Toaster.showError('Email is required');
      return null;
    }
    if (state.subject.isEmpty) {
      Toaster.showError('Subject is required');
      return null;
    }
    if (state.message.isEmpty) {
      Toaster.showError('Message is required');
      return null;
    }

    Toaster.showLoading('Creating ticket...');
    final res = await ref.read(supportTicketRepoProvider).createTicket(state);
    Toaster.remove();
    refreshList();
    return res.fold(
      (l) => null,
      (r) => r.data.ticket.ticketNumber,
    );
  }
}
