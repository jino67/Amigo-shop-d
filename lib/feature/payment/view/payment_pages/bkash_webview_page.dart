import 'package:e_com/feature/check_out/providers/provider.dart';
import 'package:e_com/feature/payment/payment_gateway/payment_gateway.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BkashWebviewPage extends HookConsumerWidget {
  const BkashWebviewPage({super.key, required this.url});
  final String url;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentMethod = ref.watch(
      checkoutStateProvider.select((value) => value?.paymentLog.method),
    );

    if (paymentMethod == null) {
      return ErrorView.withScaffold('Failed to load Bkash Information');
    }

    final bkashCtrl = useCallback(
        () => ref.read(bkashPaymentCtrlProvider(paymentMethod).notifier));

    final progress = useState<double?>(null);

    final webCtrl = useState<InAppWebViewController?>(null);

    useEffect(() => webCtrl.value?.clearCache);

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.pink,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            webCtrl.value?.clearCache();
            webCtrl.value?.clearFocus();

            context.pop();
          },
        ),
      ),
      body: Stack(
        children: [
          InAppWebView(
            shouldOverrideUrlLoading: (controller, action) async {
              final url = action.request.url;

              if (url?.toString().contains(bkashCtrl().callback) ?? false) {
                await bkashCtrl().paymentConfirmation(url!, context);
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
    );
  }
}
