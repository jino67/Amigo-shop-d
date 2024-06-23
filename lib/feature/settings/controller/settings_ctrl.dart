import 'dart:async';

import 'package:e_com/core/core.dart';
import 'package:e_com/feature/region_settings/provider/region_provider.dart';
import 'package:e_com/feature/settings/repository/settings_repo.dart';
import 'package:e_com/locator.dart';
import 'package:e_com/models/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/settings_provider.dart';

final settingsCtrlProvider =
    AsyncNotifierProvider<SettingsCtrlNotifier, ConfigModel>(
        SettingsCtrlNotifier.new);

class SettingsCtrlNotifier extends AsyncNotifier<ConfigModel> {
  SettingsRepo get _repo => ref.watch(settingsRepoProvider);

  @override
  FutureOr<ConfigModel> build() => _init();

  FutureOr<ConfigModel> _init() async {
    final res = await _repo.getConfig();

    return res.fold(
      (l) => Future.error(l.message, l.stackTrace),
      (r) async {
        await _setConfigState(r.data);
        ref
            .read(defaultLangStateProvider.notifier)
            .update((state) => r.data.defaultLanguage);

        locate<SharedPreferences>()
            .setBool(PrefKeys.currencyOnLeft, r.data.settings.currencyOnLeft);
        return r.data;
      },
    );
  }

  reload() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async => await _init());
  }

  Future<void> reloadSilently() async {
    state = await AsyncValue.guard(() async => await _init());
  }

  Future<void> _setConfigState(ConfigModel config) async {
    final pref = ref.watch(sharedPrefProvider);
    await pref.setString(CachedKeys.config, config.toJson());

    ref.invalidate(settingsProvider);
  }
}
