import 'package:e_com/feature/region_settings/repository/region_repo.dart';
import 'package:e_com/models/settings/region_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final regionCtrlProvider =
    AsyncNotifierProvider<RegionCtrlNotifier, RegionModel>(
        RegionCtrlNotifier.new);

class RegionCtrlNotifier extends AsyncNotifier<RegionModel> {
  RegionRepo get _repo => ref.watch(regionRepoProvider);

  @override
  Future<RegionModel> build() async => init();

  RegionModel init() {
    final currencyCode = _repo.getCurrencyCode();
    final languageCode = _repo.getLanguage();

    final region = RegionModel(
      langCode: languageCode ?? 'en',
      currencyUid: currencyCode,
    );

    return region;
  }

  reload() {
    state = const AsyncValue.loading();
    final currencyCode = _repo.getCurrencyCode();
    final languageCode = _repo.getLanguage();

    final region = RegionModel(
      langCode: languageCode ?? 'en',
      currencyUid: currencyCode,
    );
    state = AsyncValue.data(region);
  }

  setLangCode(String code) async {
    await _repo.setLanguage(code);
    await reload();
  }

  setCurrencyCode(String code) async {
    await _repo.setCurrency(code);
    await reload();
  }
}
