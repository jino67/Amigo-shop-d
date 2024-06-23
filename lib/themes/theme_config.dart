import 'package:e_com/core/core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier(ref);
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier(this._ref) : super(ThemeMode.system) {
    _initTheme();
  }

  final key = PrefKeys.isLight;

  final Ref _ref;

  toggleTheme() async {
    final isDark = state == ThemeMode.dark;

    await _prefs.setBool(key, !isDark);

    await _initTheme();
  }

  SharedPreferences get _prefs => _ref.watch(sharedPrefProvider);

  _initTheme() async {
    final isDark = _prefs.getBool(key);

    final result = switch (isDark) {
      null => ThemeMode.light,
      true => ThemeMode.dark,
      false => ThemeMode.light,
    };

    state = result;
  }
}
