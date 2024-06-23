import 'package:e_com/feature/campaign/repository/campaign_repo.dart';
import 'package:e_com/models/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final campaignCtrlProvider =
    AsyncNotifierProviderFamily<CampaignCtrlNotifier, CampaignDetails, String>(
        CampaignCtrlNotifier.new);

class CampaignCtrlNotifier
    extends FamilyAsyncNotifier<CampaignDetails, String> {
  CampaignRepo get _repo => ref.watch(campaignRepoProvider);

  @override
  Future<CampaignDetails> build(String arg) async {
    return await _init();
  }

  Future<CampaignDetails> _init() async {
    final res = await _repo.getCampaignDetails(arg);

    return res.fold((l) => Future.error(l, l.stackTrace), (r) => r.data);
  }

  Future<void> reload() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async => await _init());
  }

  Future<void> next() async {
    final stateData = await future;
    final url = stateData.products.pagination?.nextPageUrl;
    if (url == null) return;

    state = const AsyncValue.loading();
    final res = await _repo.getPaginatedFromUrl(url);

    res.fold(
      (l) => state = AsyncValue.error(l, StackTrace.current),
      (r) => state = AsyncValue.data(r.data),
    );
  }

  Future<void> previous() async {
    final stateData = await future;
    final url = stateData.products.pagination?.prevPageUrl;
    if (url == null) return;

    state = const AsyncValue.loading();
    final res = await _repo.getPaginatedFromUrl(url);

    return res.fold(
      (l) => state = AsyncValue.error(l, StackTrace.current),
      (r) => state = AsyncValue.data(r.data),
    );
  }
}
