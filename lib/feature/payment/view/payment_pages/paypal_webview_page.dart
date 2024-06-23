import 'package:e_com/feature/check_out/providers/provider.dart';
import 'package:e_com/feature/payment/payment_gateway/paypal/paypal_payment_ctrl.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PaypalWebviewPage extends HookConsumerWidget {
  const PaypalWebviewPage({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentMethod = ref.watch(
        checkoutStateProvider.select((value) => value?.paymentLog.method));
    if (paymentMethod == null) {
      return ErrorView.withScaffold('Failed to load Paypal Information');
    }

    final paypalCtrl = useCallback(
        () => ref.read(paypalPaymentCtrlProvider(paymentMethod).notifier));

    final progress = useState<double?>(null);
    final webCtrl = useState<InAppWebViewController?>(null);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text("Paypal Payment"),
      ),
      body: Stack(
        children: [
          InAppWebView(
            shouldOverrideUrlLoading: (controller, action) async {
              final url = action.request.url;

              if (url.toString().contains(paypalCtrl().returnURL)) {
                paypalCtrl().executePayment(context, url);

                return NavigationActionPolicy.CANCEL;
              }

              return NavigationActionPolicy.ALLOW;
            },
            initialUrlRequest: URLRequest(url: Uri.parse(url)),
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                useShouldOverrideUrlLoading: true,
                javaScriptCanOpenWindowsAutomatically: true,
              ),
            ),
            onWebViewCreated: (controller) => webCtrl.value = controller,
            onCloseWindow: (controller) async {
              await controller.clearCache();
              await controller.clearFocus();
            },
            onProgressChanged: (controller, p) => progress.value = p / 100,
          ),
          LinearProgressIndicator(value: progress.value),
        ],
      ),
    );
  }
}
