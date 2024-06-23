import 'package:e_com/core/extensions/context_extension.dart';
import 'package:e_com/core/strings/app_const.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SplashView extends ConsumerWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(
              AppDefaults.appName,
              style: context.textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}
