import 'package:e_com/core/core.dart';
import 'package:e_com/feature/auth/controller/auth_ctrl.dart';
import 'package:e_com/models/models.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TNCCheckWidget extends HookConsumerWidget {
  const TNCCheckWidget(this.tncPage, {super.key});
  final ExtraPagesModel? tncPage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authCtrl = useCallback(() => ref.read(authCtrlProvider.notifier));
    final didAccept = ref.watch(acceptedTNCProvider);
    final page = tncPage;

    if (page == null) return const SizedBox.shrink();

    return Row(
      children: [
        Checkbox(
          value: didAccept,
          onChanged: (c) {
            authCtrl().toggleTNCCheck(c ?? false);
          },
          visualDensity: const VisualDensity(
            horizontal: VisualDensity.minimumDensity,
            vertical: VisualDensity.maximumDensity,
          ),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        const SizedBox(width: Insets.xs),
        Text('${Translator.iAccept(context)} '),
        GestureDetector(
          onTap: () async {
            final res = await showDialog<bool>(
              context: context,
              barrierDismissible: false,
              builder: (x) => AcceptTNCView(page),
            );
            if (res == true) authCtrl().toggleTNCCheck(true);
          },
          child: Text(
            Translator.tnc(context),
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.colorTheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}

class AcceptTNCView extends ConsumerWidget {
  const AcceptTNCView(this.page, {super.key});

  final ExtraPagesModel page;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyle = context.textTheme;
    final didAccept = ref.watch(acceptedTNCProvider);

    return Dialog(
      insetPadding: const EdgeInsets.all(10),
      child: Padding(
        padding: defaultPaddingAll,
        child: Column(
          children: [
            Row(
              children: [
                IconButton.outlined(
                  onPressed: () => context.pop(false),
                  icon: const Icon(Icons.close_rounded),
                ),
                const SizedBox(width: Insets.med),
                Text(
                  page.name,
                  style: context.textTheme.headlineSmall,
                ),
              ],
            ),
            const Divider(),
            Flexible(
              child: SingleChildScrollView(
                physics: defaultScrollPhysics,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Html(
                      data: page.description.replaceAll('<br>', ''),
                      onLinkTap: (url, attributes, element) {
                        if (url != null) URLHelper.url(url);
                      },
                      style: {
                        '*': Style(
                          border: Border.all(color: Colors.transparent),
                        ),
                        'h1': Style.fromTextStyle(textStyle.headlineSmall!),
                        'h2': Style.fromTextStyle(textStyle.labelLarge!),
                        'h3': Style.fromTextStyle(textStyle.bodyLarge!),
                        'body': Style.fromTextStyle(textStyle.bodyMedium!),
                        'p': Style.fromTextStyle(textStyle.bodyMedium!),
                      },
                    ),
                  ],
                ),
              ),
            ),
            if (!didAccept)
              Padding(
                padding: defaultPaddingAll,
                child: SubmitButton(
                  onPressed: () => context.pop(true),
                  child: const Text('Accept  and continue'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
