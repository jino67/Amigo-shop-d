import 'package:animated_onboard/animated_onboard.dart';
import 'package:e_com/core/core.dart';
import 'package:e_com/feature/on_board/controller/onboard_ctrl.dart';
import 'package:e_com/feature/settings/controller/settings_ctrl.dart';
import 'package:e_com/routes/routes.dart';
import 'package:e_com/widgets/app_image.dart';
import 'package:e_com/widgets/error_loading.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OnBoardPage extends HookConsumerWidget {
  const OnBoardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsCtrl = ref.watch(settingsCtrlProvider);

    return settingsCtrl.when(
      error: (e, s) => Scaffold(
        body: ErrorView.reload(e, s, () => ref.refresh(settingsCtrlProvider)),
      ),
      loading: () => const SplashView(),
      data: (config) {
        final onBoardPages = config.settings.onBoarding;

        return Scaffold(
          body: IntroScreenOnboarding(
            introductionList: [
              ...onBoardPages.map(
                (e) => Introduction(
                  imageBuilder: (url) => ClipRRect(
                    borderRadius: defaultRadius,
                    child: HostedImage(
                      e.image,
                      fit: BoxFit.fitHeight,
                      height: context.onMobile ? 250 : 400,
                      width: context.onMobile ? 250 : 400,
                    ),
                  ),
                  imageUrl: e.image,
                  title: e.heading,
                  subTitle: e.description,
                  titleTextStyle: context.textTheme.headlineSmall!,
                  subTitleTextStyle: context.textTheme.titleMedium!,
                ),
              ),
            ],
            skipTextStyle: context.textTheme.labelLarge?.copyWith(
              color: context.colorTheme.primary,
            ),
            onTapSkipButton: () async {
              await ref.read(onboardCtrlProvider.notifier).disableOnBoard();
              if (context.mounted) RouteNames.home.goNamed(context);
            },
          ),
        );
      },
    );
  }
}
