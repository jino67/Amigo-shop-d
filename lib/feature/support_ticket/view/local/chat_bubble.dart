import 'package:e_com/core/core.dart';
import 'package:e_com/feature/support_ticket/controller/file_downloader_ctrl.dart';
import 'package:e_com/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChatBubble extends HookConsumerWidget {
  const ChatBubble({
    super.key,
    required this.msg,
  });

  final TicketMassage msg;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final downloadQueue = ref.watch(fileDownloaderProvider);
    final downloadQueueCtrl =
        useCallback(() => ref.read(fileDownloaderProvider.notifier));

    final align =
        msg.isAdminReply ? Alignment.centerLeft : Alignment.centerRight;
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Align(
        alignment: align,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: context.width * .7),
          child: DefaultTextStyle(
            style: context.textTheme.bodyMedium!.copyWith(
              color: context.colorTheme.onBackground,
            ),
            child: IconTheme(
              data: IconThemeData(
                color: context.colorTheme.secondaryContainer,
                size: 20,
              ),
              child: Column(
                crossAxisAlignment: msg.isAdminReply
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.end,
                children: [
                  if (msg.message != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: context.colorTheme.secondaryContainer
                            .withOpacity(.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(msg.message!),
                    ),
                  if (msg.files.isNotEmpty)
                    Column(
                      children: [
                        ...msg.files.map(
                          (file) {
                            final download = downloadQueue
                                .where((f) => f.id == file.id)
                                .firstOrNull;
                            return InkWell(
                              onTap: () => downloadQueueCtrl().addToQueue(file),
                              child: Container(
                                margin: const EdgeInsets.only(top: 3),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: context.colorTheme.secondaryContainer
                                      .withOpacity(.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox.square(
                                      dimension: 25,
                                      child: download == null
                                          ? const Icon(Icons.download_rounded)
                                          : (download.progress?.isNegative ??
                                                  false)
                                              ? const Icon(
                                                  Icons.file_open_rounded)
                                              : CircularProgressIndicator(
                                                  value: download.progress,
                                                ),
                                    ),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(file.fileName),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
