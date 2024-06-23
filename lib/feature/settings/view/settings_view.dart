import 'package:e_com/core/core.dart';
import 'package:e_com/feature/settings/controller/settings_ctrl.dart';
import 'package:e_com/routes/routes.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsCtrlProvider);
    final settingsCtrl = ref.read(settingsCtrlProvider.notifier);
    return Scaffold(
      appBar: KAppBar(
        title: Text(Translator.settings(context)),
        leading: SquareButton.backButton(
          onPressed: () => context.pop(),
        ),
      ),
      body: settings.when(
          error: (e, s) => ErrorView.reload(e, s, () => settingsCtrl.reload()),
          loading: () => const LoadingList(),
          data: (config) {
            return settings.isLoading
                ? const Loader()
                : RefreshIndicator(
                    onRefresh: () =>
                        ref.read(settingsCtrlProvider.notifier).reload(),
                    child: ListView(
                      physics: defaultScrollPhysics,
                      children: [
                        ListTile(
                          onTap: () {
                            RouteNames.region.goNamed(context);
                          },
                          leading: Icon(MdiIcons.translate),
                          title: Text(Translator.languageCurrency(context)),
                        ),
                        ...config.extraPages.map(
                          (page) => ListTile(
                            onTap: () {
                              RouteNames.extraPage.goNamed(
                                context,
                                pathParams: {'pageId': page.uid},
                              );
                            },
                            leading: const Icon(Icons.description_outlined),
                            title: Text(page.name),
                          ),
                        )
                      ],
                    ),
                  );
          }),
    );
  }
}
