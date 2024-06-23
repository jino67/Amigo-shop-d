import 'package:collection/collection.dart';
import 'package:e_com/core/core.dart';
import 'package:e_com/feature/orders/controller/order_tracking_ctrl.dart';
import 'package:e_com/feature/orders/view/local/order_loader.dart';
import 'package:e_com/feature/orders/view/pay_now_bottom_sheet_view.dart';
import 'package:e_com/feature/region_settings/provider/region_provider.dart';
import 'package:e_com/routes/go_route_name.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OrderDetailsView extends ConsumerWidget {
  const OrderDetailsView({super.key, this.orderId});

  final String? orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderData = ref.watch(orderDetailsProvider(orderId));
    final local = ref.watch(localeCurrencyStateProvider);
    final borderColor =
        context.colorTheme.secondary.withOpacity(context.isDark ? 0.8 : 0.2);
    const padding = EdgeInsets.symmetric(horizontal: 20, vertical: 10);
    final showTracking = context.query('from') == 'tracking';

    return Scaffold(
      appBar: KAppBar(
        title: Text(Translator.orderDetails(context)),
        leading: SquareButton.backButton(
          onPressed: () => context.pop(),
        ),
      ),
      body: orderData.when(
        error: (e, s) => ErrorView.reload(
          e,
          s,
          () => ref.refresh(orderDetailsProvider(orderId)),
        ),
        loading: () => const OrderLoader(),
        data: (order) {
          final billing = order.billingInformation;
          return Padding(
            padding: defaultPadding.copyWith(top: 20),
            child: RefreshIndicator(
              onRefresh: () async {
                return ref.refresh(orderDetailsProvider(orderId));
              },
              child: SingleChildScrollView(
                physics: defaultScrollPhysics,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //!Ship & Bill Section---------------------------------------------
                    if (billing != null)
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: defaultRadius,
                          border: Border.all(color: borderColor),
                        ),
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: padding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Translator.shipNBill(context),
                              style: context.textTheme.bodyLarge!.copyWith(
                                color: context.colorTheme.onBackground
                                    .withOpacity(0.8),
                              ),
                            ),
                            if (!billing.isNamesEmpty)
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
                                billing.country,
                                style: context.textTheme.titleMedium,
                              ),
                          ],
                        ),
                      ),

                    if (order.paymentDetails.isNotEmpty)
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: defaultRadius,
                          border: Border.all(color: borderColor),
                        ),
                        width: double.infinity,
                        padding: padding,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Détails du paiement',
                              style: context.textTheme.bodyLarge!.copyWith(
                                color: context.colorTheme.onBackground
                                    .withOpacity(0.8),
                              ),
                            ),
                            for (var MapEntry(:key, :value)
                                in order.paymentDetails.entries)
                              Text(
                                '$key : $value',
                                style: context.textTheme.titleMedium,
                              ),
                          ],
                        ),
                      ),

                    //! Product Package Section ---------------------------------------------
                    ...List.generate(
                      order.orderDetails.length,
                      (i) => Container(
                        decoration: BoxDecoration(
                          borderRadius: defaultRadius,
                          border: Border.all(color: borderColor),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: padding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.local_shipping_outlined),
                                const SizedBox(width: 10),
                                Text(
                                  '${Translator.package(context)} [${i + 1}]',
                                ),
                                const Spacer(),
                                Text(
                                  order.status.title,
                                  style: context.textTheme.titleLarge!.copyWith(
                                    color: context.colorTheme.errorContainer,
                                  ),
                                ),
                              ],
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: HostedImage(
                                  order.orderDetails[i].isRegular
                                      ? order.orderDetails[i].product!
                                          .featuredImage
                                      : order.orderDetails[i].digitalProduct!
                                          .featuredImage,
                                  height: 60,
                                  width: 60,
                                ),
                              ),
                              isThreeLine: true,
                              title: Text(
                                order.orderDetails[i].isRegular
                                    ? order.orderDetails[i].product!.name
                                    : order
                                        .orderDetails[i].digitalProduct!.name,
                                style: context.textTheme.titleMedium,
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (!order.orderDetails[i].isRegular)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      margin: const EdgeInsets.only(
                                        bottom: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: defaultRadius,
                                        color: context.colorTheme.secondary
                                            .withOpacity(0.07),
                                      ),
                                      child: Text(
                                        order.orderDetails[i].digitalProduct!
                                                .attribute.keys.firstOrNull ??
                                            'N/A',
                                      ),
                                    ),
                                  Text.rich(
                                    TextSpan(
                                      text: order.orderDetails[i].totalPrice
                                          .fromLocal(local),
                                      children: [
                                        TextSpan(
                                          text:
                                              '  x ${order.orderDetails[i].quantity}',
                                          style: context.textTheme.bodyMedium,
                                        ),
                                      ],
                                    ),
                                    style: context.textTheme.titleLarge,
                                  ),
                                ],
                              ),
                            ),
                            if (order.status.name == 'delivered')
                              if (order.orderDetails[i].isRegular) ...[
                                const SizedBox(height: 20),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: FilledButton(
                                    onPressed: () {
                                      RouteNames.productDetails.pushNamed(
                                        context,
                                        pathParams: {
                                          'id': order
                                              .orderDetails[i].product!.uid,
                                        },
                                        query: {
                                          'isRegular':
                                              order.orderDetails[i].isRegular
                                                  ? 'true'
                                                  : 'false',
                                          'toReview': 'true',
                                        },
                                      );
                                    },
                                    child:
                                        Text(Translator.writeReview(context)),
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                          ],
                        ),
                      ),
                    ),
                    if (!showTracking)
                      Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor:
                                context.colorTheme.primary.withOpacity(.05),
                          ),
                          onPressed: () {
                            RouteNames.trackOrder.pushNamed(
                              context,
                              query: {'id': order.orderId},
                            );
                          },
                          child: Text(Translator.trackOrder(context)),
                        ),
                      )
                    else
                      const SizedBox(height: 10),

                    //! Order id----------------------------------------------
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: defaultRadius,
                        border: Border.all(
                          color: borderColor,
                        ),
                      ),
                      padding: padding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${Translator.orderId(context)}: ${order.orderId}',
                                style: context.textTheme.titleLarge!.copyWith(
                                    color: context.colorTheme.primary),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${Translator.orderPlacement(context)}: ',
                                style: context.textTheme.titleMedium!.copyWith(
                                  color: context.colorTheme.onSurface
                                      .withOpacity(0.8),
                                ),
                              ),
                              Text(
                                order.orderDate
                                    .formatDate(context, 'dd MMM yyyy'),
                                style: context.textTheme.titleMedium!.copyWith(
                                  color: context.colorTheme.onSurface
                                      .withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: defaultRadius,
                        border: Border.all(
                          color: borderColor,
                        ),
                      ),
                      padding: padding,
                      child: Column(
                        children: [
                          SpacedText(
                            style: context.textTheme.titleMedium,
                            leftText: '${Translator.paymentMethod(context)}:',
                            rightText: order.paymentType == null ? 'A la livraison' : order.paymentType!.startsWith("Cash") ? "A la livraison" : order.paymentType!,
                            //rightText: "A la livraison",
                          ),
                          const SizedBox(height: 10),
                          SpacedText.diffStyle(
                            styleLeft: context.textTheme.titleMedium,
                            styleRight: context.textTheme.titleMedium?.copyWith(
                              color: order.paymentStatus == 'Paid'
                                  ? context.colorTheme.errorContainer
                                  : null,
                            ),
                            leftText: '${Translator.paymentStatus(context)}:',
                            //rightText: order.paymentStatus,
                            rightText: "En cours",
                          ),
                          const Divider(height: 10),
                          SpacedText(
                            style: context.textTheme.titleMedium,
                            leftText: '${Translator.subTotal(context)}:',
                            rightText: order.orderDetails
                                .map((e) => e.totalPrice)
                                .sum
                                .fromLocal(local),
                          ),
                          const SizedBox(height: 10),
                          SpacedText(
                            style: context.textTheme.titleMedium,
                            leftText: '${Translator.shippingCharge(context)}:',
                            rightText: order.shippingCharge.fromLocal(local),
                          ),
                          const SizedBox(height: 10),
                          SpacedText(
                            style: context.textTheme.titleMedium,
                            leftText: '${Translator.discount(context)}:',
                            rightText: order.discount.fromLocal(local),
                          ),
                          const SizedBox(height: 10),
                          SpacedText(
                            style: context.textTheme.titleMedium,
                            leftText: '${Translator.total(context)}:',
                            rightText: order.amount.fromLocal(local),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (!order.isPaid)
                      if (!order.isCOD)
                        Center(
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                                shape: const StadiumBorder()),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                scrollControlDisabledMaxHeightRatio: 0.9,
                                builder: (ctx) => ProviderScope(
                                  parent: ProviderScope.containerOf(context),
                                  child: PayNowBottomSheetView(order),
                                ),
                              );
                            },
                            child: Text(Translator.payNow(context)),
                          ),
                        ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
