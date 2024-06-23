import 'dart:io' as io;

import 'package:e_com/core/core.dart';
import 'package:e_com/feature/support_ticket/controller/support_ticket_ctrl.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:open_filex/open_filex.dart';

class SelectedFilesSheet extends HookConsumerWidget {
  const SelectedFilesSheet({
    super.key,
    required this.files,
    required this.ticketCtrl,
  });

  final ValueNotifier<List<io.File>> files;
  final TicketChatCtrlNotifier Function() ticketCtrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: context.height * 0.7,
      child: BottomSheet(
        onClosing: () {},
        builder: (context) {
          return ValueListenableBuilder<List<io.File>>(
              valueListenable: files,
              builder: (context, value, child) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: value.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                Translator.files(context),
                                style: context.textTheme.titleLarge,
                              ),
                              IconButton.filledTonal(
                                onPressed: () async {
                                  final newFiles =
                                      await ticketCtrl().pickFiles();
                                  files.value = [...value, ...newFiles];
                                },
                                icon: const Icon(Icons.add_rounded),
                              ),
                            ],
                          ),
                        );
                      }
                      final file = value[index - 1];
                      return Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Corners.med),
                          side: BorderSide(
                            color: context.colorTheme.secondaryContainer,
                            width: 1,
                          ),
                        ),
                        child: ListTile(
                          iconColor: context.colorTheme.secondaryContainer,
                          leading: const Icon(Icons.file_present_rounded),
                          title: Text(file.path.split('/').last),
                          trailing: IconButton(
                            onPressed: () {
                              files.value = [
                                ...value.sublist(0, index - 1),
                                ...value.sublist(index),
                              ];
                            },
                            icon: Icon(
                              Icons.cancel,
                              color: context.colorTheme.error,
                            ),
                          ),
                          onTap: () {
                            OpenFilex.open(file.path);
                          },
                        ),
                      );
                    },
                  ),
                );
              });
        },
      ),
    );
  }
}
