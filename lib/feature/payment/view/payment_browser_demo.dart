import 'dart:async';

import 'package:e_com/core/core.dart';
import 'package:e_com/models/models.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen(this.url, {super.key, required this.paymentLog});

  final PaymentLog paymentLog;
  final String url;

  @override
  PaymentScreenState createState() => PaymentScreenState();
}

class PaymentScreenState extends State<PaymentScreen> {
  late MyInAppBrowser browser;
  PullToRefreshController? pullToRefreshController;
  late String selectedUrl;
  double value = 0.0;

  final bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    selectedUrl = widget.url;
    _initData();
  }

  void _initData() async {
    browser = MyInAppBrowser(orderID: widget.paymentLog.trx);

    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);

    final swAvailable = await AndroidWebViewFeature.isFeatureSupported(
      AndroidWebViewFeature.SERVICE_WORKER_BASIC_USAGE,
    );
    final swInterceptAvailable = await AndroidWebViewFeature.isFeatureSupported(
      AndroidWebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST,
    );

    if (swAvailable && swInterceptAvailable) {
      final serviceWorkerCtrl = AndroidServiceWorkerController.instance();
      await serviceWorkerCtrl.setServiceWorkerClient(
        AndroidServiceWorkerClient(
          shouldInterceptRequest: (request) async {
            return null;
          },
        ),
      );
    }

    Color color = Colors.black;

    if (context.mounted) {
      color = context.colorTheme.primary;
    }

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(color: color),
      onRefresh: () async => browser.webViewController.reload(),
    );
    browser.pullToRefreshController = pullToRefreshController;

    await browser.openUrlRequest(
      urlRequest: URLRequest(url: Uri.parse(selectedUrl)),
      options: InAppBrowserClassOptions(
        inAppWebViewGroupOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            useShouldOverrideUrlLoading: true,
            useOnLoadResource: true,
          ),
        ),
        crossPlatform: InAppBrowserOptions(hideUrlBar: true),
      ),
    );
  }

  Future<bool?> _exitApp() async {
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (v) => _exitApp(),
      canPop: false,
      child: Scaffold(
        backgroundColor: context.colorTheme.surface,
        appBar: KAppBar(title: Text(widget.paymentLog.method.name)),
        body: Center(
          child: Stack(
            children: [
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else
                const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}

class MyInAppBrowser extends InAppBrowser {
  MyInAppBrowser({
    required this.orderID,
    super.windowId,
    super.initialUserScripts,
  });

  final String orderID;

  bool _canRedirect = true;

  @override
  Future onBrowserCreated() async {
    if (kDebugMode) {
      print("\n\nBrowser Created!\n\n");
    }
  }

  @override
  void onConsoleMessage(consoleMessage) {
    if (kDebugMode) {
      print("""
    console output:
      message: ${consoleMessage.message}
      messageLevel: ${consoleMessage.messageLevel.toValue()}
   """);
    }
  }

  @override
  void onExit() {}

  @override
  void onLoadError(url, code, message) {
    pullToRefreshController?.endRefreshing();
  }

  @override
  void onLoadResource(resource) {}

  @override
  Future onLoadStart(url) async {
    _redirect(url.toString());
  }

  @override
  Future onLoadStop(url) async {
    pullToRefreshController?.endRefreshing();

    _redirect(url.toString());
  }

  @override
  void onProgressChanged(progress) {
    if (progress == 100) {
      pullToRefreshController?.endRefreshing();
    }
    if (kDebugMode) {
      print("Progress: $progress");
    }
  }

  @override
  Future<NavigationActionPolicy> shouldOverrideUrlLoading(
      navigationAction) async {
    if (kDebugMode) {
      print("\n\nOverride ${navigationAction.request.url}\n\n");
    }
    return NavigationActionPolicy.ALLOW;
  }

  void _redirect(String url) {
    if (_canRedirect) {
      bool isSuccess = url.contains('/payment-success');
      bool isFailed = url.contains('/payment-fail');
      bool isCancel = url.contains('/payment-cancel');
      if (isSuccess || isFailed || isCancel) {
        _canRedirect = false;
        close();
      }
    } else {}
  }
}
