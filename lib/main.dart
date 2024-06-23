import 'dart:io';

import 'package:e_com/core/core.dart';
import 'package:e_com/feature/region_settings/provider/region_provider.dart';
import 'package:e_com/locator.dart';
import 'package:e_com/themes/theme_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'routes/routes.dart';
import 'themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Animate.restartOnHotReload = true;
  TalkerConfig.logOnConsole = kDebugMode;

  await locatorSetUp();

  if (kDebugMode) HttpOverrides.global = MyHttpOverrides();

  FlutterError.onError = (e) => talk.ex(e.exception, e.stack, e.summary);

  PlatformDispatcher.instance.onError = (e, s) {
    talk.ex(e, s, 'Async error');
    return true;
  };

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routes = ref.watch(goRoutesProvider);
    final theme = ref.watch(appThemeProvider);

    final langCode =
        ref.watch(localeCurrencyStateProvider.select((v) => v.langCode));
    final mode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: AppDefaults.appName,
      themeMode: mode,
      theme: theme.theme(true),
      darkTheme: theme.theme(false),
      routerConfig: routes,
      locale: langCode != null ? Locale(langCode) : null,
      supportedLocales: SupportedLanguage.locales,
      localizationsDelegates: const [
        AppLocalization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FormBuilderLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}
