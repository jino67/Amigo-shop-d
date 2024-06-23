import 'package:e_com/core/core.dart';
import 'package:e_com/feature/search/repository/product_search_repo.dart';
import 'package:e_com/models/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final searchCtrlProvider =
    AsyncNotifierProvider<SearchCtrlNotifier, List<ProductsData>>(
        SearchCtrlNotifier.new);

class SearchCtrlNotifier extends AsyncNotifier<List<ProductsData>> {
  SearchRepo get _repo => ref.watch(searchRepoProvider);

  @override
  Future<List<ProductsData>> build() async {
    return [];
  }

  Future<void> search(String text) async {
    if (text.isEmpty) {
      Toaster.showInfo('Nothing to search');
      return;
    }

    state = const AsyncValue.loading();

    final res = await _repo.searchProduct(text);

    res.fold((l) => null, (r) => state = AsyncValue.data(r.data.listData));
  }

  clear() {
    state = const AsyncValue.data([]);
  }
}
