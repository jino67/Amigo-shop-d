import 'package:e_com/core/strings/shared_pref_const.dart';
import 'package:e_com/locator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final regionRepoProvider = Provider<RegionRepo>((ref) {
  return RegionRepo();
});

class RegionRepo {
  final pref = locate<SharedPreferences>();

  Future<void> setLanguage(String langCode) async {
    await pref.setString(PrefKeys.language, langCode);
  }

  Future<void> setCurrency(String currencyCode) async {
    await pref.setString(PrefKeys.currency, currencyCode);
  }

  String? getCurrencyCode() {
    final currencyCode = pref.getString(PrefKeys.currency);
    return currencyCode;
  }

  String? getLanguage() {
    final langCode = pref.getString(PrefKeys.language);
    return langCode;
  }
}
