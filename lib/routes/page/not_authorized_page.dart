import 'package:e_com/core/core.dart';
import 'package:e_com/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NotAuthorizedPage extends ConsumerWidget {
  const NotAuthorizedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                context.colorTheme.primary,
                BlendMode.srcATop,
              ),
              child: Assets.lottie.notAuthenticated.lottie(height: 200),
            ),
            Text(
              Translator.notAuthorized(context),
              style: context.textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            Text(Translator.loginToContinue(context)),
            const SizedBox(height: 20),
            FilledButton(
                onPressed: () => RouteNames.login.pushNamed(context),
                child: Text(Translator.loginNow(context))),
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: () => RouteNames.home.goNamed(context),
              icon: const Icon(Icons.arrow_back_rounded),
              label: Text(Translator.backToHome(context)),
            ),
          ],
        ),
      ),
    );
  }
}
