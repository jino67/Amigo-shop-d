import 'package:e_com/core/core.dart';
import 'package:e_com/feature/auth/controller/auth_ctrl.dart';
import 'package:e_com/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SocialLoginButtons extends HookConsumerWidget {
  const SocialLoginButtons(this.config, {super.key});
  final ConfigModel config;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authCtrl = useCallback(() => ref.read(authCtrlProvider.notifier));
    final loadingGoogle = useState(false);
    final loadingFB = useState(false);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (config.settings.googleOAuth != null)
            Expanded(
              child: SizedBox(
                height: 50,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    textStyle: context.textTheme.bodyLarge,
                    foregroundColor: context.colorTheme.onSurface,
                    padding: const EdgeInsets.all(10),
                  ),
                  onPressed: () async {
                    loadingGoogle.value = true;
                    await authCtrl().googleLogin(context);
                    loadingGoogle.value = false;
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (loadingGoogle.value)
                        const SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator(),
                        )
                      else
                        Assets.logo.google.image(height: 25, width: 25),
                      const SizedBox(width: 8),
                      const Text('Google'),
                    ],
                  ),
                ),
              ),
            ),
          if (config.settings.facebookOAuth != null ||
              config.settings.googleOAuth != null)
            const SizedBox(width: 10),
          if (config.settings.facebookOAuth != null)
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  textStyle: context.textTheme.bodyLarge,
                  foregroundColor: context.colorTheme.onSurface,
                  padding: const EdgeInsets.all(10),
                ),
                onPressed: () async {
                  loadingFB.value = true;
                  await authCtrl().facebookLogin();
                  loadingFB.value = false;
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (loadingFB.value)
                      const SizedBox(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(),
                      )
                    else
                      Assets.logo.fb.image(height: 25, width: 25),
                    const SizedBox(width: 8),
                    const Text('Facebook'),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
