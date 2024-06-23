import 'package:e_com/core/core.dart';
import 'package:e_com/feature/orders/view/pay_now_bottom_sheet_view.dart';
import 'package:e_com/feature/region_settings/provider/region_provider.dart';
import 'package:e_com/models/user_content/order_model.dart';
import 'package:e_com/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OrderTile extends ConsumerWidget {
  const OrderTile({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final local = ref.watch(localeCurrencyStateProvider);
    final borderColor =
        context.colorTheme.secondary.withOpacity(context.isDark ? 0.8 : 0.2);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: InkWell(
        onTap: () {
          RouteNames.orderDetails
              .pushNamed(context, query: {'id': order.orderId});
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: defaultRadius,
            border: Border.all(color: borderColor),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Commande ${order.orderId}',
                    style: context.textTheme.titleLarge!
                        .copyWith(color: context.colorTheme.primary),
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
                    ('Passée le: '),
                    style: context.textTheme.titleMedium!.copyWith(
                      color: context.colorTheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                  
                  Text(
                    order.orderDate.formatDate(context, 'dd MMM yyyy'),
                    style: context.textTheme.titleMedium!.copyWith(
                      color: context.colorTheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    order.status.title,
                    style: context.textTheme.titleMedium!.copyWith(
                      color: context.colorTheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                  Text(
                    order.paymentStatus == 'Paid' ? "Payée" : "Non totalement payée",
                    style: context.textTheme.titleMedium!.copyWith(
                      color: order.isPaid
                          ? context.colorTheme.errorContainer
                          : context.colorTheme.error,
                    ),
                  ),
                ],
              ),
              Row(children: [
                if (order.totalPaid != '1')
                 Text(
                    ('Somme payée:${double.parse(order.totalPaid.toString())} FCFA'),
                    style: context.textTheme.titleMedium!.copyWith(
                      color: context.colorTheme.onSurface.withOpacity(0.5),
                    ),
                  ),
              ],),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    ('${Translator.total(context)}: '),
                    style: context.textTheme.titleLarge,
                  ),
                  Text(
                    order.amount.fromLocal(local),
                    style: context.textTheme.titleLarge,
                  ),
                  const Spacer(),
                  if (order.paymentStatus != 'Paid')
                    if (!order.isCOD)
                      Align(
                        alignment: Alignment.bottomRight,
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
                          child: const Text("Payer"),
                        ),
                      )
                    else
                      Text(
                        order.paymentType ?? 'N/A',
                        style: context.textTheme.titleMedium,
                      ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
