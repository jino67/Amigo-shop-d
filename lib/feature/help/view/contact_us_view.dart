import 'package:e_com/core/core.dart';
import 'package:e_com/feature/auth/controller/auth_ctrl.dart';
import 'package:e_com/feature/settings/controller/settings_ctrl.dart';
import 'package:e_com/feature/settings/provider/settings_provider.dart';
import 'package:e_com/routes/routes.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ContactUsView extends HookConsumerWidget {
  const ContactUsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(settingsProvider);

    final reloadConfig =
        useCallback(() => ref.read(settingsCtrlProvider.notifier).reload());
    final isLoggedIn = ref.watch(authCtrlProvider);

    return Scaffold(
      appBar: KAppBar(
        leading: SquareButton.backButton(onPressed: () => context.pop()),
        title: Text(
          '${Translator.support(context)} & ${Translator.contact(context)}',
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: defaultPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (config == null)
                ErrorView.reload('Config Load Failed', null, reloadConfig)
              else ...[
                const SizedBox(height: 20),
                if (isLoggedIn)
                  HelplineCard(
                    title: Translator.helpline(context),
                    icon: Icons.support_agent_rounded,
                    onTap: () => RouteNames.supportTicket.pushNamed(context),
                    subTitle: Translator.helplineSubtitle(context),
                  ),
                const SizedBox(height: 10),
                HiddenButton(
                  child: HelplineCard(
                    title: Translator.location(context),
                    icon: Icons.location_on,
                    onTap: () => ClipBoardHelper.copy(config.settings.address),
                    subTitle: config.settings.address,
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    Translator.getInTouch(context),
                    style: context.textTheme.titleLarge,
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Container(
                    height: 2,
                    width: 200,
                    color: context.colorTheme.primary,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ContactInfoCard(
                        onTap: () => URLHelper.call(config.settings.phone),
                        title: Translator.phone(context),
                        subTitle: config.settings.phone,
                        icon: Icons.phone,
                      ),
                    ),
                    Expanded(
                      child: ContactInfoCard(
                        onTap: () => URLHelper.mail(config.settings.email),
                        title: Translator.email(context),
                        subTitle: config.settings.email,
                        icon: Icons.email,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: config.socialContacts.length,
                  itemBuilder: (BuildContext context, int index) {
                    final icon = config.socialContacts[index];

                    final iconData =
                        MdiIcons.fromString(icon.name) ?? MdiIcons.web;

                    return InkWell(
                      onTap: () => URLHelper.url(icon.url),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            child: Icon(
                              iconData,
                              size: 25,
                              color: context.colorTheme.onSecondaryContainer,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            icon.name.titleCaseSingle,
                            style: context.textTheme.bodyLarge,
                          )
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 30),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class HelplineCard extends StatelessWidget {
  const HelplineCard({
    super.key,
    required this.title,
    required this.subTitle,
    required this.icon,
    required this.onTap,
  });
  final String title;
  final String subTitle;
  final IconData icon;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = context.colorTheme.secondaryContainer
        .withOpacity(context.isDark ? 0.8 : 0.2);
    return InkWell(
      borderRadius: defaultRadius,
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: defaultRadius,
          border: Border.all(width: 1.5, color: borderColor),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            const SizedBox(width: 20),
            CircleAvatar(
              radius: 30,
              child: Icon(
                icon,
                size: 35,
                color: context.colorTheme.onSecondaryContainer,
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: context.textTheme.titleLarge,
                  ),
                  Text(
                    subTitle,
                    style: context.textTheme.bodyLarge,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ContactInfoCard extends StatelessWidget {
  const ContactInfoCard({
    super.key,
    required this.title,
    required this.subTitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subTitle;
  final IconData icon;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = context.colorTheme.secondaryContainer
        .withOpacity(context.isDark ? 0.8 : 0.2);
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: InkWell(
        borderRadius: defaultRadius,
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: defaultRadius,
                border: Border.all(
                  width: 2,
                  color: borderColor,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(5, 40, 5, 20),
                child: Column(
                  children: [
                    Text(
                      title,
                      style: context.textTheme.titleLarge,
                    ),
                    Text(
                      subTitle,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: -30,
              right: 1,
              left: 1,
              child: CircleAvatar(
                radius: 30,
                child: Icon(
                  icon,
                  size: 35,
                  color: context.colorTheme.onSecondaryContainer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
