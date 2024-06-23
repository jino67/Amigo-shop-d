import 'package:e_com/feature/check_out/providers/provider.dart';
import 'package:e_com/feature/payment/payment_gateway/nagad/nagad_payment_ctrl.dart';
import 'package:e_com/feature/payment/view/payment_exit_dialog.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NagadWebviewPage extends HookConsumerWidget {
  const NagadWebviewPage({super.key, required this.url});
  final String url;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentMethod = ref.watch(
        checkoutStateProvider.select((value) => value?.paymentLog.method));

    if (paymentMethod == null) {
      return ErrorView.withScaffold('Failed to load Nagad Information');
    }

    final nagadCtrl = useCallback(
        () => ref.read(nagadPaymentCtrlProvider(paymentMethod).notifier));

    final progress = useState<double?>(null);

    final webCtrl = useState<InAppWebViewController?>(null);

    return PopScope(
      canPop: false,
      onPopInvoked: (v) {
        if (v) return;
        ExitPaymentDialog.onPaymentExit(context, webCtrl: webCtrl.value);
      },
      child: Scaffold(
        appBar: KAppBar(
          title: const Text('Nagad Payment'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => ExitPaymentDialog.onPaymentExit(
              context,
              webCtrl: webCtrl.value,
            ),
          ),
        ),
        body: Stack(
          children: [
            InAppWebView(
              shouldOverrideUrlLoading: (controller, action) async {
                final url = action.request.url;

                if (url.toString().contains(nagadCtrl().callbackUrl)) {
                  await nagadCtrl().verifyPayment(context, url);
                  return NavigationActionPolicy.CANCEL;
                }

                if (url.toString().contains('mynagad.com')) {
                  return NavigationActionPolicy.ALLOW;
                }
                return NavigationActionPolicy.CANCEL;
              },
              initialUrlRequest: URLRequest(url: Uri.parse(url)),
              initialOptions: InAppWebViewGroupOptions(
                crossPlatform:
                    InAppWebViewOptions(useShouldOverrideUrlLoading: true),
              ),
              onWebViewCreated: (controller) => webCtrl.value = controller,
              onCloseWindow: (controller) async {
                webCtrl.value
                  ?..clearCache()
                  ..clearFocus();
              },
              onProgressChanged: (controller, p) => progress.value = p / 100,
            ),
            LinearProgressIndicator(value: progress.value),
          ],
        ),
      ),
    );
  }
}
