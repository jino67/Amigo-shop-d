import 'package:e_com/core/core.dart';
import 'package:e_com/routes/routes.dart';
import 'package:flutter/material.dart';

class ErrorRoutePage extends StatelessWidget {
  const ErrorRoutePage({super.key, this.error});
  final Object? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '404',
              style: context.textTheme.headlineMedium,
            ),
            const SizedBox(height: 5),
            Text(
              Translator.somethingWentWrong(context),
              style: context.textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            Text(
              '$error',
              style: context.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextButton.icon(
              onPressed: () => RouteNames.home.goNamed(context),
              icon: const Icon(Icons.arrow_back),
              label: Text(Translator.backToHome(context)),
            ),
          ],
        ),
      ),
    );
  }
}
