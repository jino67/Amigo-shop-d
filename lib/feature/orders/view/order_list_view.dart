import 'package:e_com/core/core.dart';
import 'package:e_com/feature/orders/view/local/order_tile.dart';
import 'package:e_com/feature/user_dash/controller/dash_ctrl.dart';
import 'package:e_com/models/models.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OrderListView extends HookConsumerWidget {
  const OrderListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusQuery = context.query('status');
    final tab = context.query('tab');

    final userDash = ref.watch(userDashCtrlProvider);
    final userDashCtrl =
        useCallback(() => ref.read(userDashCtrlProvider.notifier));

    return DefaultTabController(
      initialIndex: tab == null ? 0 : tab.asInt,
      length: 2,
      child: Scaffold(
        appBar: KAppBar(
          toolbarHeight: kToolbarHeight,
          leading: SquareButton.backButton(
            onPressed: () => context.pop(),
          ),
          title: statusQuery == null
              ? const Text("Mes commandes")
              : Text('${Translator.myOrder(context)} - $statusQuery'),
          bottom: TabBar(
            tabs: [
              Tab(child: Text(Translator.orders(context))),
              Tab(child: Text(Translator.digitalOrder(context))),
            ],
          ),
        ),
        body: userDash.when(
            loading: () => const LoadingList(),
            error: (error, s) =>
                ErrorView.reload(error, s, () => userDashCtrl().reload()),
            data: (dash) {
              var UserDashModel(:orders, :digitalOrders) = dash;

              final status = statusQuery == null
                  ? null
                  : OrderStatus.values.byName(statusQuery);

              if (status != null) {
                orders = orders.copyWith(
                  listData: orders.listData
                      .where((element) => element.status == status)
                      .toList(),
                );
                digitalOrders = digitalOrders.copyWith(
                  listData: digitalOrders.listData
                      .where((element) => element.status == status)
                      .toList(),
                );
              }
              return TabBarView(
                children: [
                  RefreshIndicator(
                    onRefresh: () => userDashCtrl().reload(),
                    child: ListViewWithFooter(
                      physics: defaultScrollPhysics,
                      onNext: () =>
                          userDashCtrl().orderPaginationHandler(true, false),
                      onPrevious: () =>
                          userDashCtrl().orderPaginationHandler(false, false),
                      pagination: orders.pagination,
                      itemCount: orders.listData.length,
                      emptyListWidget:
                          const Center(child: NoItemsAnimationWithFooter()),
                      itemBuilder: (context, index) {
                        orders.listData.sort(
                          (a, b) => b.orderDate.compareTo(a.orderDate),
                        );
                        final order = orders.listData[index];
                        return OrderTile(order: order);
                      },
                    ),
                  ),
                  RefreshIndicator(
                    onRefresh: () => userDashCtrl().reload(),
                    child: ListViewWithFooter(
                      physics: defaultScrollPhysics,
                      onNext: () =>
                          userDashCtrl().orderPaginationHandler(true, true),
                      onPrevious: () =>
                          userDashCtrl().orderPaginationHandler(false, true),
                      pagination: digitalOrders.pagination,
                      itemCount: digitalOrders.listData.length,
                      emptyListWidget:
                          const Center(child: NoItemsAnimationWithFooter()),
                      itemBuilder: (context, index) {
                        digitalOrders.listData.sort(
                          (a, b) => b.orderDate.compareTo(a.orderDate),
                        );
                        final order = digitalOrders.listData[index];
                        return OrderTile(order: order);
                      },
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
