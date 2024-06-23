import 'package:e_com/core/core.dart';
import 'package:e_com/feature/support_ticket/controller/support_ticket_ctrl.dart';
import 'package:e_com/models/models.dart';
import 'package:e_com/routes/routes.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../user_dash/provider/user_dash_provider.dart';

class SupportTicketListView extends ConsumerWidget {
  const SupportTicketListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tickets = ref.watch(supportTicketListProvider);
    final user = ref.watch(
      userDashProvider.select((value) => value?.user),
    );
    final borderColor = context.colorTheme.secondaryContainer
        .withOpacity(context.isDark ? 0.8 : 0.2);
    return Scaffold(
      appBar: KAppBar(
        leading: SquareButton.backButton(
          onPressed: () => context.pop(),
        ),
        title: Text(Translator.supportTicket(context)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          RouteNames.createTicket.goNamed(context);
        },
        child: Icon(
          Icons.add,
          color: context.colorTheme.onError,
        ),
      ),
      body: tickets.when(
        loading: () => const LoadingList(),
        error: (error, stack) => ErrorView(error: error),
        data: (data) {
          final SupportTicketList(:tickets, :pagination) = data;
          return Padding(
            padding: defaultPadding.copyWith(top: 10),
            child: RefreshIndicator(
              onRefresh: () => ref.refresh(supportTicketListProvider.future),
              child: ListViewWithFooter(
                pagination: pagination,
                onNext: () => ref
                    .read(supportTicketListProvider.notifier)
                    .paginationHandler(isNext: true),
                onPrevious: () => ref
                    .read(supportTicketListProvider.notifier)
                    .paginationHandler(isNext: false),
                physics: defaultScrollPhysics,
                itemCount: tickets.isEmpty ? 1 : tickets.length,
                itemBuilder: (context, index) {
                  if (tickets.isEmpty) {
                    return const Center(child: NoItemsAnimationWithFooter());
                  }
                  final ticket = tickets[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: Insets.sm),
                    child: InkWell(
                      borderRadius: defaultRadius,
                      onTap: () => RouteNames.ticketDetails.goNamed(context,
                          pathParams: {'id': ticket.ticketNumber}),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: defaultRadius,
                          border: Border.all(color: borderColor),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: HostedImage.provider(
                                          user?.image ?? ''),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                              ],
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ticket.subject,
                                    style: context.textTheme.bodyLarge!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 5),
                                  Text.rich(
                                    TextSpan(
                                      text: '#${ticket.ticketNumber}',
                                      style: context.textTheme.bodyLarge!
                                          .copyWith(
                                              color:
                                                  context.colorTheme.primary),
                                      children: [
                                        TextSpan(
                                          text: ' by ${user?.name ?? ''}',
                                          style: context.textTheme.titleMedium,
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: ticket.priority.color
                                              .withOpacity(.1),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 3,
                                          ),
                                          child: Text(
                                            ticket.priority.title,
                                            style: context
                                                .textTheme.titleMedium!
                                                .copyWith(
                                              color: ticket.priority.color,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: ticket.status.color
                                              .withOpacity(.1),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 3,
                                          ),
                                          child: Text(
                                            ticket.status.title,
                                            style: context
                                                .textTheme.titleMedium!
                                                .copyWith(
                                                    color: ticket.status.color),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
