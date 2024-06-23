import 'dart:async';

import 'package:e_com/core/core.dart';
import 'package:e_com/feature/auth/controller/auth_ctrl.dart';
import 'package:e_com/feature/campaign/providers/campaign_provider.dart';
import 'package:e_com/feature/home/repository/home_page_repo.dart';
import 'package:e_com/feature/products/providers/product_providers.dart';
import 'package:e_com/feature/settings/controller/settings_ctrl.dart';
import 'package:e_com/feature/store/providers/store_providers.dart';
import 'package:e_com/feature/user_dash/controller/dash_ctrl.dart';
import 'package:e_com/models/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final homeCtrlProvider =
    AsyncNotifierProvider<HomeCtrlNotifier, HomeResponseData>(() {
  return HomeCtrlNotifier();
});

class HomeCtrlNotifier extends AsyncNotifier<HomeResponseData> {
  HomeCtrlNotifier();

  HomeRepo get _repo => ref.watch(homeRepoProvider);

  @override
  Future<HomeResponseData> build() async => _init();

  Future<HomeResponseData> _init() async {
    state = const AsyncValue.loading();

    final res = await _repo.getStartUpData();

    return res.fold(
      (l) => Future.error(l.message, l.stackTrace),
      (r) {
        _setHomeState(r.data);
        _egerInits();
        return r.data;
      },
    );
  }

  _egerInits() async {
    if (ref.watch(authCtrlProvider)) {
      ref.read(userDashCtrlProvider.notifier);
    }
    ref.read(settingsCtrlProvider.notifier);
  }

  reload([bool reloadAll = true]) async {
    state = await AsyncValue.guard(() async => await _init());

    if (reloadAll) {
      if (ref.watch(authCtrlProvider)) {
        await ref.read(userDashCtrlProvider.notifier).reload();
      }
      await ref.read(settingsCtrlProvider.notifier).reload();
    }
  }

  void _setHomeState(HomeResponseData data) async {
    final pref = ref.watch(sharedPrefProvider);

    await pref.setStringList(
      CachedKeys.categories,
      data.categories.categoriesData.map((e) => e.toJson()).toList(),
    );

    await pref.setStringList(
      CachedKeys.brands,
      data.brands.brandsData.map((e) => e.toJson()).toList(),
    );
    if (data.flash != null) {
      await pref.setString(CachedKeys.flash, data.flash!.toJson());
    }

    await pref.setString(
      CachedKeys.newProducts,
      data.newArrival.toJson((data) => data.toJson()),
    );

    await pref.setString(
      CachedKeys.todaysProducts,
      data.todayDeals.toJson((data) => data.toJson()),
    );

    await pref.setString(
      CachedKeys.bestSaleProducts,
      data.bestSelling.toJson((data) => data.toJson()),
    );

    await pref.setString(
      CachedKeys.digitalProducts,
      data.digitalProducts.toJson((data) => data.toJson()),
    );

    await pref.setString(
      CachedKeys.suggestedProducts,
      data.suggestedProducts.toJson((data) => data.toJson()),
    );
    ref.invalidate(productListProvider);

    await pref.setString(
      CachedKeys.shops,
      data.stores.toJson((data) => data.toJson()),
    );
    ref.invalidate(storeListProvider);

    await pref.setString(
      CachedKeys.campaigns,
      data.campaigns.toJson((data) => data.toJson()),
    );
    ref.invalidate(campaignListProvider);
  }
}
