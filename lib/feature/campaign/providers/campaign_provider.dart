import 'dart:async';

import 'package:e_com/core/core.dart';
import 'package:e_com/feature/home/controller/home_page_ctrl.dart';
import 'package:e_com/feature/products/repository/pagination_providing_repo.dart';
import 'package:e_com/models/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final campaignListProvider = AutoDisposeAsyncNotifierProvider<
    CampaignListNotifier,
    ItemListWithPageData<CampaignModel>>(CampaignListNotifier.new);

class CampaignListNotifier
    extends AutoDisposeAsyncNotifier<ItemListWithPageData<CampaignModel>> {
  @override
  FutureOr<ItemListWithPageData<CampaignModel>> build() {
    final pref = ref.watch(sharedPrefProvider);
    final campaigns = pref.getString(CachedKeys.campaigns);

    return ItemListWithPageData<CampaignModel>.fromJson(
      campaigns,
      (source) => CampaignModel.fromJson(source),
    );
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    await ref.read(homeCtrlProvider.notifier).reload(false);
    ref.invalidateSelf();
  }

  Future<void> next() async {
    final stateData = await future;
    final repo = ref.watch(paginationProvidingRepoProvider);
    final url = stateData.pagination?.nextPageUrl;
    if (url == null) return;

    state = const AsyncLoading();

    final res = await repo.pageFromHome(url);
    final data = res.fold((l) => null, (r) => r.data);
    if (data == null) return;

    state = AsyncData(data.campaigns);
  }

  Future<void> previous() async {
    final stateData = await future;
    final repo = ref.watch(paginationProvidingRepoProvider);
    final url = stateData.pagination?.prevPageUrl;
    if (url == null) return;

    state = const AsyncLoading();

    final res = await repo.pageFromHome(url);
    final data = res.fold((l) => null, (r) => r.data);
    if (data == null) return;

    state = AsyncData(data.campaigns);
  }
}
