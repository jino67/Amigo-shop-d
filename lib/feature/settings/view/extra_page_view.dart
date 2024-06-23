import 'package:e_com/core/core.dart';
import 'package:e_com/feature/settings/provider/settings_provider.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ExtraPageView extends ConsumerWidget {
  const ExtraPageView({required this.id, super.key});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(settingsProvider);
    final page = config?.extraPages.where((element) => element.uid == id).first;
    final textStyle = context.textTheme;

    return Scaffold(
      appBar: KAppBar(
        title: Text(page?.name ?? ''),
        leading: SquareButton.backButton(
          onPressed: () => context.pop(),
        ),
      ),
      body: config == null
          ? const EmptyWidget()
          : Padding(
              padding: defaultPaddingAll,
              child: SingleChildScrollView(
                child: Html(
                  data: page?.description.replaceAll('<br>', ''),
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
              ),
            ),
    );
  }
}
