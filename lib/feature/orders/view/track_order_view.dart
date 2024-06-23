import 'package:e_com/core/core.dart';
import 'package:e_com/feature/orders/controller/order_tracking_ctrl.dart';
import 'package:e_com/feature/orders/view/local/order_loader.dart';
import 'package:e_com/models/user_content/order_model.dart';
import 'package:e_com/routes/routes.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TrackOrderView extends HookConsumerWidget {
  const TrackOrderView({super.key, this.orderId});

  final String? orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderCtrl = useCallback(
        () => ref.read(orderTrackingCtrlProvider(orderId).notifier));
    final orderData = ref.watch(orderTrackingCtrlProvider(orderId));

    final trackCtrl = useTextEditingController();

    return Scaffold(
      appBar: KAppBar(
        title: Text(Translator.trackOrder(context)),
        leading: SquareButton.backButton(
          onPressed: () => context.pop(),
        ),
        bottom: AppBarTextField(
          showFieldSuffix: false,
          controller: trackCtrl,
          hint: Translator.trackingId(context),
          onSubmit: () => orderCtrl().trackOrder(trackCtrl.text),
          suffix: InkWell(
            onTap: () {
              if (trackCtrl.text.isEmpty) {
                Toaster.showError(
                  Translator.enterTrackingId(context),
                );
                return;
              }
              orderCtrl().trackOrder(trackCtrl.text);
            },
            child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                borderRadius: defaultRadius,
                color: context.colorTheme.secondaryContainer,
              ),
              padding: const EdgeInsets.all(12),
              child: Icon(
                Icons.search,
                color: context.colorTheme.onSecondaryContainer,
              ),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => orderCtrl().reload(trackCtrl.text),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          physics: defaultScrollPhysics,
          child: orderData.when(
            error: (error, s) => ErrorView.reload(
              error,
              s,
              () => orderCtrl().reload(trackCtrl.text),
            ),
            loading: () => const OrderLoader(),
            data: (order) {
              if (order == null) return const Center(child: NoItemsAnimation());

              final billing = order.billingInformation;
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: context.colorTheme.primary,
                      borderRadius: defaultRadius,
                    ),
                    padding: const EdgeInsets.all(20),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${order.status.title} !',
                          style: context.textTheme.titleLarge!.copyWith(
                            color: context.colorTheme.onPrimary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'La commande a été ${order.status.title} le',
                          style: context.textTheme.bodyMedium!.copyWith(
                            color: context.colorTheme.onPrimary,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          order.statusDateNow
                              .formatDate(context, 'dd MMM yyyy'),
                          style: context.textTheme.headlineSmall!.copyWith(
                            color: context.colorTheme.onPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  if (billing != null)
                    Container(
                      decoration: BoxDecoration(
                        color: context.colorTheme.secondaryContainer
                            .withOpacity(0.1),
                        borderRadius: defaultRadius,
                      ),
                      padding: defaultPaddingAll,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            billing.fullName,
                            style: context.textTheme.titleMedium,
                          ),
                          if (billing.phone.isNotEmpty)
                            Text(
                              '${Translator.phone(context)} : ${billing.phone}',
                              style: context.textTheme.titleMedium,
                            ),
                          if (billing.email.isNotEmpty)
                            Text(
                              '${Translator.email(context)} : ${billing.email}',
                              style: context.textTheme.titleMedium,
                            ),
                          if (!billing.isAddressEmpty)
                            Text(
                              '${Translator.address(context)} :\n${billing.fullAddress}',
                              style: context.textTheme.titleMedium,
                            ),
                            
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${Translator.orderId(context)}: ',
                                style: context.textTheme.titleLarge!,
                              ),
                              Expanded(
                                child: Text(
                                  order.orderId,
                                  style: context.textTheme.titleLarge!.copyWith(
                                    color: context.colorTheme.primary,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Clipboard.setData(
                                    ClipboardData(text: order.orderId),
                                  );
                                },
                                icon: const Icon(Icons.copy),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor:
                            context.colorTheme.primary.withOpacity(.05),
                      ),
                      onPressed: () => RouteNames.orderDetails.pushNamed(
                        context,
                        query: {'id': order.orderId, 'from': 'tracking'},
                      ),
                      child: Text(Translator.fullDetails(context)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TimeLineViewWidget(order: order),
                  const SizedBox(height: 20),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class TimeLineViewWidget extends ConsumerWidget {
  const TimeLineViewWidget({
    required this.order,
    super.key,
  });
  final OrderModel order;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCanceled = order.status == OrderStatus.cancel;
    return Column(
      children: [
        if (isCanceled)
          ...OrderStatus.cancelValues.map(
            (status) {
              final color = context.colorTheme.error;

              final statusLog = order.statusLogOf(status);
              final date = statusLog?.date.formatDate(context, 'dd MMM yyyy');
              return TimelineTile(
                axis: TimelineAxis.vertical,
                alignment: TimelineAlign.center,
                lineXY: 0.3,
                isFirst: status.isFirst,
                isLast: status == OrderStatus.cancel,
                indicatorStyle: _indicatorStyle(color, status, context),
                beforeLineStyle: _lineStyle(color),
                afterLineStyle: _lineStyle(color),
                startChild: _startChildBuilder(date, context, statusLog),
                endChild: _endChildBuilder(status, context),
              );
            },
          )
        else
          ...OrderStatus.trackValues.map(
            (status) {
              final isCurrentStatus = status == order.status;
              final index = OrderStatus.values.indexOf(order.status);
              final realIndex = OrderStatus.values.indexOf(status);

              final isActive = isCurrentStatus || realIndex <= index;
              final color = isActive
                  ? context.colorTheme.primary
                  : context.colorTheme.outline;

              final statusLog = order.statusLogOf(status);
              final date = statusLog?.date.formatDate(context, 'dd MMM yyyy');
              return TimelineTile(
                axis: TimelineAxis.vertical,
                alignment: TimelineAlign.center,
                lineXY: 0.3,
                isFirst: status.isFirst,
                isLast: status.isLast,
                indicatorStyle: _indicatorStyle(color, status, context),
                beforeLineStyle: _lineStyle(color),
                afterLineStyle: _lineStyle(color),
                startChild: _startChildBuilder(date, context, statusLog),
                endChild: _endChildBuilder(status, context),
              );
            },
          ),
      ],
    );
  }

  IndicatorStyle _indicatorStyle(
      Color color, OrderStatus status, BuildContext context) {
    return IndicatorStyle(
      width: 35,
      height: 35,
      color: color,
      iconStyle: IconStyle(
        iconData: status.icon,
        color: context.colorTheme.surface,
        fontSize: 22,
      ),
    );
  }

  LineStyle _lineStyle(Color color) => LineStyle(color: color, thickness: 4);

  Padding _endChildBuilder(OrderStatus status, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        constraints: const BoxConstraints(
          minWidth: 10,
        ),
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(status.title),
            // Text(
            //   status.name,
            //   style: context.textTheme.bodyMedium!.copyWith(
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Container _startChildBuilder(
    String? date,
    BuildContext context,
    StatusLog? statusLog,
  ) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(vertical: 40).copyWith(right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            date ?? 'DD/MMM/YYYY',
            style: context.textTheme.bodyMedium!.copyWith(
              color: date == null
                  ? context.colorTheme.onSurface.withOpacity(.7)
                  : null,
              fontWeight: date == null ? null : FontWeight.bold,
            ),
          ),
          Text(
            statusLog?.note ?? '- - - ' * 2,
            style: context.textTheme.bodyMedium,
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}
