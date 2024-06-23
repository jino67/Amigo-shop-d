import 'package:e_com/core/core.dart';
import 'package:e_com/feature/auth/controller/auth_ctrl.dart';
import 'package:e_com/feature/check_out/providers/provider.dart';
import 'package:e_com/feature/payment/controller/payment_ctrl.dart';
import 'package:e_com/feature/region_settings/provider/region_provider.dart';
import 'package:e_com/routes/routes.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderPlacedPage extends ConsumerWidget {
  const OrderPlacedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(checkoutStateProvider);
    final local = ref.watch(localeCurrencyStateProvider);

    final from = context.query('from');

    final isFromPayNow = from == 'payNow';

    return Scaffold(
      appBar: KAppBar(title: Text(Translator.completePayment(context))),
      body: SingleChildScrollView(
        physics: defaultScrollPhysics,
        padding: defaultPadding,
        child: Column(
          children: [
            Assets.lottie.readyForPayment.lottie(
              delegates: LottieDelegates(
                values: [
                  ValueDelegate.color(
                    ['**', 'Group 2', '**'],
                    value: context.colorTheme.errorContainer,
                  ),
                  ValueDelegate.color(
                    ['**', 'plane Outlines', '**'],
                    value: context.colorTheme.errorContainer,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            if (order == null)
              Text(
                Translator.somethingWentWrong(context),
                style: context.textTheme.titleLarge,
              )
            else ...[
              Text(
                isFromPayNow
                    ? Translator.readyForPayment(context)
                    : Translator.orderSuccessful(context),
                style: context.textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              Text(
                isFromPayNow
                    ? Translator.yourOrderReadyPayment(context)
                    : Translator.yourOderPWSuccessful(context),
                textAlign: TextAlign.center,
                style: context.textTheme.titleMedium,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${Translator.orderId(context)}: ',
                    style: context.textTheme.titleMedium,
                  ),
                  Text(
                    order.order.orderId,
                    style: context.textTheme.titleMedium?.copyWith(
                      color: context.colorTheme.primary,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Clipboard.setData(
                        ClipboardData(text: order.order.orderId)),
                    icon: const Icon(Icons.copy, size: 16),
                  ),
                ],
              ),
              if (!ref.watch(authCtrlProvider))
                Container(
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.center,
                  width: context.width,
                  decoration: BoxDecoration(
                    borderRadius: defaultRadius,
                    border: Border.all(color: context.colorTheme.error),
                    color: context.colorTheme.error.withOpacity(.1),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: context.colorTheme.error,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          Translator.notLoggedInOrderWarn(context),
                          style: context.textTheme.titleMedium?.copyWith(
                            color: context.colorTheme.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 20),
              if (!order.paymentLog.method.isCOD) ...[
                SpacedText(
                  leftText: Translator.total(context),
                  rightText: order.paymentLog.amount.fromLocal(local),
                  style: context.textTheme.titleMedium,
                ),
                SpacedText(
                  leftText: Translator.charge(context),
                  rightText: order.paymentLog.charge.fromLocal(local),
                  style: context.textTheme.titleMedium,
                ),
                SpacedText(
                  leftText: Translator.payable(context),
                  rightText: order.paymentLog.payable.fromLocal(local),
                  style: context.textTheme.titleMedium,
                ),
                const Divider(),
                SpacedText(
                  leftText: 'In ${order.paymentLog.method.currency.name}',
                  rightText: order.paymentLog.finalAmount
                      .currency(order.paymentLog.method.currency),
                  style: context.textTheme.titleLarge,
                ),
              ],
              if (!order.paymentLog.method.isCOD) ...[
                const SizedBox(height: 50),
                FilledButton(
                  style: FilledButton.styleFrom(
                    fixedSize: Size(context.width, 50),
                  ),
                  onPressed: () {
                    final ctrl = ref.read(paymentCtrlProvider.notifier);
                    final method = order.paymentLog.method;
                   
                        ctrl.initializePaymentWithMethod(context, method: method);
                    
                  },
                  child: Text(
                    '${Translator.payNow(context)} - ${order.paymentLog.method.name}',
                  ),
                ),
                const SizedBox(height: 10,),
                if (order.paymentLog.method.name.startsWith("Par"))
                 FilledButton(
                  style: FilledButton.styleFrom(
                    fixedSize: Size(context.width, 50),
                  ),
                  onPressed: () async {
                    String url = "https://amigo-shop.goaicorporation.org/login";
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(Uri.parse(url));
                      }
                    
                  },
                  child: const Text(
                    'Retirer le montant déjà payé',
                  ),
                ),
              ],
            ],
            const SizedBox(height: 20),
            FilledButton(
              style: OutlinedButton.styleFrom(
                fixedSize: Size(context.width, 50),
                backgroundColor: context.colorTheme.secondary.withOpacity(.05),
                foregroundColor: context.colorTheme.secondary,
                side: BorderSide(
                    color: context.colorTheme.secondary.withOpacity(.4)),
              ),
              onPressed: () {
                RouteNames.trackOrder.goNamed(
                  context,
                  query: {'id': order?.order.orderId ?? ''},
                );
              },
              child: Text(Translator.trackNow(context)),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                fixedSize: Size(context.width, 50),
                backgroundColor: context.colorTheme.secondary.withOpacity(.05),
                foregroundColor: context.colorTheme.secondary,
                side: BorderSide(
                    color: context.colorTheme.secondary.withOpacity(.4)),
              ),
              onPressed: () => RouteNames.home.goNamed(context),
              child: Text(Translator.backToHome(context)),
            ),
            const SizedBox(height: 150)
          ],
        ),
      ),
    );
  }
}
