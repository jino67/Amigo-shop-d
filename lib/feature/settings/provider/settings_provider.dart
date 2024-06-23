import 'package:e_com/core/core.dart';
import 'package:e_com/models/settings/config_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final settingsProvider = Provider<ConfigModel?>((ref) {
  final pref = ref.watch(sharedPrefProvider);

  final data = pref.getString(CachedKeys.config);

  if (data == null) return null;

  return ConfigModel.fromJson(data);
});
