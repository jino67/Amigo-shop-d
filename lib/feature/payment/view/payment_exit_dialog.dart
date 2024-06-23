import 'package:e_com/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:go_router/go_router.dart';

class ExitPaymentDialog extends StatelessWidget {
  const ExitPaymentDialog({super.key});

  static onPaymentExit(
    BuildContext context, {
    InAppWebViewController? webCtrl,
    bool withDialog = true,
  }) async {
    final popped = await showDialog<bool>(
      context: context,
      builder: (_) => const ExitPaymentDialog(),
    );
    if (popped == null || !popped) return;

    webCtrl?.clearCache();
    webCtrl?.clearFocus();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(Translator.exitPayment(context)),
      content: Text(Translator.areYouSure(context)),
      actions: [
        TextButton(
          onPressed: () {
            context.pop();
            context.pop();
          },
          child: Text(Translator.yes(context)),
        ),
        TextButton(
          onPressed: () => context.pop<bool>(false),
          child: Text(Translator.no(context)),
        ),
      ],
    );
  }
}
