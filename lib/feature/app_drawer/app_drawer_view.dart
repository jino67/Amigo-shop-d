import 'package:e_com/core/core.dart';
import 'package:e_com/feature/auth/controller/auth_ctrl.dart';
import 'package:e_com/feature/user_dash/provider/user_dash_provider.dart';
import 'package:e_com/routes/routes.dart';
import 'package:e_com/themes/theme_config.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class KDrawerMenu extends HookConsumerWidget {
  const KDrawerMenu({super.key, required this.onItemTap});

  /// used to close the drawer when an item is tapped
  final Function(RouteName? route) onItemTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authCtrlProvider);
    final authCtrl = useCallback(() => ref.read(authCtrlProvider.notifier));
    final user = ref.watch(userDashProvider.select((value) => value?.user));
    final isLoggedIn = ref.watch(authCtrlProvider);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 8,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (authState)
                    Padding(
                      padding: defaultPadding,
                      child: Center(
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 150),
                          height: 130 + context.mq.viewPadding.top,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(70),
                            ),
                            color:
                                context.colorTheme.secondary.withOpacity(.06),
                          ),
                          padding: const EdgeInsets.all(20),
                          alignment: Alignment.bottomCenter,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              if (user != null)
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(180),
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                  child: HostedImage.square(
                                    user.image,
                                    dimension: 90,
                                  ),
                                )
                              else
                                CircleAvatar(
                                  backgroundColor: context
                                      .colorTheme.secondaryContainer
                                      .withOpacity(.5),
                                  radius: 45,
                                  child: const Icon(
                                    Icons.person_rounded,
                                    size: 45,
                                  ),
                                ),
                              Positioned(
                                bottom: -3,
                                right: 0,
                                child: CircularButton.filled(
                                  onPressed: () =>
                                      onItemTap(RouteNames.userEditing),
                                  fillColor: context.colorTheme.primary,
                                  iconColor: context.colorTheme.onPrimary,
                                  icon: const Icon(Icons.edit_rounded),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    SizedBox(height: 130 + context.mq.viewPadding.top),
                  const SizedBox(height: 30),
                  HiddenButton(
                    child: Padding(
                      padding: defaultPadding,
                      child: Text(
                        '${Translator.hello(context)},',
                        style: context.textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: defaultPadding,
                    child: Text(
                      isLoggedIn
                          ? (user?.name ?? '')
                          : Translator.guest(context),
                      style: context.textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (!authState)
                    ListTile(
                      tileColor: context.colorTheme.primary,
                      textColor: context.colorTheme.onPrimary,
                      titleTextStyle: context.textTheme.titleLarge,
                      iconColor: context.colorTheme.onPrimary,
                      onTap: () {
                        onItemTap(RouteNames.login);
                      },
                      leading: const Icon(Icons.login_rounded),
                      title: Text(Translator.loginNow(context)),
                    ),
                  if (authState)
                    ListTile(
                      onTap: () {
                        RouteNames.orders.pushNamed(context);
                      },
                      leading: Icon(
                        Icons.home_rounded,
                        color: context.colorTheme.primary,
                      ),
                      title: Text(
                        Translator.myOrder(context),
                        style: context.textTheme.titleLarge,
                      ),
                    ),
                  ListTile(
                    onTap: () {
                      RouteNames.trackOrder.pushNamed(context);
                    },
                    leading: Icon(
                      Icons.local_shipping,
                      color: context.colorTheme.primary,
                    ),
                    title: Text(Translator.trackOrder(context),
                        style: context.textTheme.titleLarge),
                  ),
                  if (authState)
                    ListTile(
                      onTap: () {
                        RouteNames.address.pushNamed(context);
                      },
                      leading: Icon(
                        Icons.location_on,
                        color: context.colorTheme.primary,
                      ),
                      title: Text(
                        Translator.userAddress(context),
                        style: context.textTheme.titleLarge,
                      ),
                    ),
                  if (authState)
                    ListTile(
                      onTap: () {
                        onItemTap(RouteNames.wishlist);
                      },
                      leading: Icon(
                        Icons.favorite_rounded,
                        color: context.colorTheme.primary,
                      ),
                      title: Text(Translator.wishlist(context),
                          style: context.textTheme.titleLarge),
                    ),
                  ListTile(
                    onTap: () {
                      onItemTap(RouteNames.settings);
                    },
                    leading: Icon(
                      Icons.settings_rounded,
                      color: context.colorTheme.primary,
                    ),
                    title: Text(
                      Translator.settings(context),
                      style: context.textTheme.titleLarge,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      RouteNames.contactUs.pushNamed(context);
                    },
                    leading: Icon(
                      Icons.person,
                      color: context.colorTheme.primary,
                    ),
                    title: Text(
                      Translator.contact(context),
                      style: context.textTheme.titleLarge,
                    ),
                  ),
                    ListTile(
                    onTap: () async {
                      String url = "https://amigo-shop.goaicorporation.org/seller/register";
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(Uri.parse(url));
                      }
                    },
                    leading: Icon(
                      Icons.sell,
                      color: context.colorTheme.primary,
                    ),
                    title: Text(
                      "Devenir Vendeur",
                      style: context.textTheme.titleLarge,
                    ),
                  ),
                  ListTile(
                    onTap: () async {
                      String url = "https://amigo-shop.goaicorporation.org/seller";
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(Uri.parse(url));
                      }
                    },
                    leading: Icon(
                      Icons.sell,
                      color: context.colorTheme.primary,
                    ),
                    title: Text(
                      "Connexion Vendeur",
                      style: context.textTheme.titleLarge,
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(endIndent: context.width / 3, thickness: 2),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      if (authState)
                        InkWell(
                          borderRadius: BorderRadius.circular(100),
                          onTap: () async {
                            await authCtrl().logOut();
                            onItemTap(null);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: context.colorTheme.primary,
                              ),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: SizedBox.square(
                                dimension: 40,
                                child: ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                    context.colorTheme.primary,
                                    BlendMode.srcIn,
                                  ),
                                  child: Assets.lottie.logout1.lottie(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(width: 20),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: context.colorTheme.primary,
                          ),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            context.colorTheme.primary,
                            BlendMode.srcIn,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: RepaintBoundary(
                              child: ThemeToggle(
                                onTap: () {
                                  ref
                                      .read(themeModeProvider.notifier)
                                      .toggleTheme();
                                },
                                size: 40,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      InkWell(
                        borderRadius: BorderRadius.circular(100),
                        onTap: () {
                          onItemTap(null);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: context.colorTheme.primary,
                            ),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: SizedBox.square(
                              dimension: 40,
                              child: ColorFiltered(
                                colorFilter: ColorFilter.mode(
                                  context.colorTheme.primary,
                                  BlendMode.srcIn,
                                ),
                                child: Assets.lottie.backArrow.lottie(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
