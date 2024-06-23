import 'dart:io' as io;

import 'package:e_com/core/core.dart';
import 'package:e_com/feature/support_ticket/controller/support_ticket_ctrl.dart';
import 'package:e_com/feature/support_ticket/view/local/chat_bubble.dart';
import 'package:e_com/feature/support_ticket/view/local/selected_files_sheet.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TicketDetailsView extends HookConsumerWidget {
  const TicketDetailsView(this.id, {super.key});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ticketData = ref.watch(ticketChatCtrlProvider(id));
    final ticketCtrl =
        useCallback(() => ref.read(ticketChatCtrlProvider(id).notifier));
    final msgCtrl = useTextEditingController();
    final files = useState<List<io.File>>([]);
    final listKey = useMemoized(GlobalKey<AnimatedListState>.new);

    return ticketData.when(
      error: ErrorView.withScaffold,
      loading: () => const Scaffold(body: LoadingList()),
      data: (ticket) {
        final massages = ticket.massages.toList();
        return Scaffold(
          appBar: KAppBar(
            title: Text(ticket.ticket.subject),
            leading: SquareButton.backButton(
              onPressed: () => context.pop(),
            ),
            actions: [
              if (!ticket.ticket.isClosed)
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text(Translator.closeTicket(context)),
                        content: Text(
                          Translator.areYouSure(context),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => context.pop(),
                            child: Text(Translator.no(context)),
                          ),
                          FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor:
                                  context.colorTheme.error.withOpacity(.2),
                              foregroundColor: context.colorTheme.error,
                            ),
                            onPressed: () {
                              context.pop();
                              ticketCtrl().closeTicket();
                            },
                            child: Text(Translator.yes(context)),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Text(
                    Translator.closeTicket(context),
                  ),
                ),
              const SizedBox(width: 10),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                flex: 8,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: AnimatedList(
                    key: listKey,
                    physics: defaultScrollPhysics,
                    reverse: true,
                    initialItemCount: massages.length,
                    itemBuilder: (context, index, animation) {
                      final msg = massages[index];
                      return SlideTransition(
                        position: Tween(
                          begin: const Offset(1, 0),
                          end: Offset.zero,
                        ).animate(animation.withCurve(Curves.easeInCubic)),
                        child: ChatBubble(msg: msg),
                      );
                    },
                  ),
                ),
              ),
              if (ticket.ticket.isClosed)
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.all(8),
                  color: context.colorTheme.error,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    Translator.ticketIsClosed(context),
                    style: context.textTheme.bodyMedium!.copyWith(
                      color: context.colorTheme.onError,
                    ),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: msgCtrl,
                    decoration: InputDecoration(
                      hintText: Translator.typeAMessage(context),
                      filled: true,
                      fillColor: context.colorTheme.surface,
                      suffixIconConstraints:
                          const BoxConstraints(minWidth: 30, minHeight: 30),
                      suffixIcon: IconButton.filled(
                        style: IconButton.styleFrom(
                          backgroundColor:
                              context.colorTheme.primary.withOpacity(0.05),
                          foregroundColor: context.colorTheme.primary,
                        ),
                        onPressed: () async {
                          if (msgCtrl.text.isEmpty) return;
                          await ticketCtrl()
                              .sendReply(msgCtrl.text, files.value);
                          listKey.currentState?.insertItem(0);
                          msgCtrl.clear();
                          files.value = [];
                        },
                        icon: const RotationTransition(
                          turns: AlwaysStoppedAnimation(-35 / 360),
                          child: Icon(Icons.send_rounded),
                        ),
                      ),
                      prefixIcon: IconButton(
                        onPressed: () async {
                          if (files.value.isEmpty) {
                            files.value = await ticketCtrl().pickFiles();
                          } else {
                            showModalBottomSheet(
                              context: context,
                              showDragHandle: true,
                              isScrollControlled: true,
                              builder: (_) => ProviderScope(
                                parent: ProviderScope.containerOf(context),
                                child: SelectedFilesSheet(
                                  files: files,
                                  ticketCtrl: ticketCtrl,
                                ),
                              ),
                            );
                          }
                        },
                        icon: files.value.isEmpty
                            ? const RotationTransition(
                                turns: AlwaysStoppedAnimation(30 / 360),
                                child: Icon(Icons.attach_file),
                              )
                            : CircleAvatar(
                                foregroundColor:
                                    context.colorTheme.onSecondaryContainer,
                                radius: 15,
                                child: Text(
                                  files.value.length.toString(),
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
