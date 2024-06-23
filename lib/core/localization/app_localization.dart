import 'dart:convert';

import 'package:e_com/core/localization/localization_const.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalization {
  AppLocalization(this.locale);

  final Locale locale;

  late Map<String, String> _localizedValues;

  static AppLocalization? of(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization);
  }

  Future<void> load() async {
    String jsonString =
        await rootBundle.loadString('assets/lang/${locale.languageCode}.json');

    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedValues =
        jsonMap.map((key, value) => MapEntry(key, value.toString()));
  }

  String translate(String key) {
    if (kDebugMode) {
      return _localizedValues[key] ?? '[$key]';
    }
    return _localizedValues[key] ?? key.replaceAll('_', ' ');
  }

  static const LocalizationsDelegate<AppLocalization> delegate =
      _LocalizationDelegate();
}

class _LocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  const _LocalizationDelegate();

  @override
  bool isSupported(Locale locale) {
    return SupportedLanguage.languages.contains(locale.languageCode);
  }

  @override
  Future<AppLocalization> load(Locale locale) async {
    AppLocalization localization = AppLocalization(locale);
    await localization.load();
    return localization;
  }

  @override
  bool shouldReload(covariant _LocalizationDelegate old) => false;
}
