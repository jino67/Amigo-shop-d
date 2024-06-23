import 'dart:async';

import 'package:e_com/core/core.dart';
import 'package:e_com/feature/products/providers/product_providers.dart';
import 'package:e_com/feature/products/repository/pagination_providing_repo.dart';
import 'package:e_com/feature/products/repository/products_repo.dart';
import 'package:e_com/feature/search/repository/product_search_repo.dart';
import 'package:e_com/models/models.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

typedef FilterArgs = ({String? type, String? query});

final filteringCtrlProvider = AutoDisposeAsyncNotifierProviderFamily<
    FilteringCtrlZNotifier,
    ProductFilteringState,
    FilterArgs>(FilteringCtrlZNotifier.new);

class FilteringCtrlZNotifier
    extends AutoDisposeFamilyAsyncNotifier<ProductFilteringState, FilterArgs> {
  /// Search products based on the query
  Future<void> search(String query) async {
    if (query.isEmpty) {
      reset();
    }
    query = _parser(query);
    _setState(await _setStateProducts(query));

    final stateData = await future;
    _setState(
      stateData.copyWith(
        products: stateData.products.fold(
          (l) => left(l.where((e) => _parser(e.name).contains(query)).toList()),
          (r) =>
              right(r.where((e) => _parser(e.name).contains(query)).toList()),
        ),
      ),
    );
  }

  String _parser(String value) => value.replaceAll(' ', '').toLowerCase();

  /// Filter products based on the state data
  Future<void> filter(String query) async {
    _setState(await _setStateProducts(query));
    final stateData = await future;
    _setState(
      stateData.copyWith(
        products: await stateData.products.fold(
          (l) async => left(await _productFilter(l, query)),
          (r) async => right(await _digitalProductFilter(r, query)),
        ),
      ),
    );
  }

  void reset() => ref.invalidateSelf();

  Future<void> setBrand(BrandData? brand) async {
    final stateData = await future;
    _setState(stateData.copyWith(brand: brand));
  }

  Future<void> setCategory(CategoriesData? category) async {
    final stateData = await future;
    final newState = stateData.copyWith(category: category);

    _setState(newState);
  }

  Future<void> setSortType(SortType sortType) async {
    final stateData = await future;
    final newState = stateData.copyWith(sortType: sortType);
    _setState(newState);
  }

  Future<void> setMax(String max) async {
    final stateData = await future;
    _setState(stateData.copyWith(max: max));
  }

  Future<void> setMin(String min) async {
    final stateData = await future;
    _setState(stateData.copyWith(min: min));
  }

  _setState(ProductFilteringState newState) =>
      state = AsyncValue.data(newState);

  Future<ItemListWithPageData<ProductsData>> _searchGlobal(String text) async {
    state = const AsyncValue.loading();
    final res = await ref.watch(searchRepoProvider).searchProduct(text);
    return res.fold(
      (l) => const ItemListWithPageData.empty(),
      (r) => r.data,
    );
  }

  Future<ItemListWithPageData<ProductsData>> _getAllProducts(
    String? query,
  ) async {
    final stateData = await future;
    state = const AsyncValue.loading();
    final repo = ref.read(productsRepoProvider);

    final res = await repo.getAllProduct(
      query: query ?? '',
      brandUid: stateData.brand?.uid,
      categoryUid: stateData.category?.uid,
      min: stateData.min,
      max: stateData.max,
      sort: stateData.sortType,
    );

    return res.fold(
      (l) => const ItemListWithPageData.empty(),
      (r) => r.data,
    );
  }

  /// set appropriate product to the state
  /// basically reloading only the products state
  Future<ProductFilteringState> _setStateProducts(String? query) async {
    final stateData = await future;

    if (arg.type == CachedKeys.digitalProducts) {
      final digital = ref.read(digitalProductListProvider);
      return stateData.setDigital(digital.listData, digital.pagination);
    }
    if (arg.type == 'search') {
      if (query == null) return stateData;
      final products = await _searchGlobal(query);
      return stateData.setRegular(products.listData, products.pagination);
    }

    if (arg.type == 'all') {
      final products = await _getAllProducts(query);
      return stateData.setRegular(products.listData, products.pagination);
    }

    final productsMap = ref.read(productListProvider)[arg.type];

    return stateData.setRegular(
      productsMap?.listData ?? [],
      productsMap?.pagination,
    );
  }

  Future<ItemListWithPageData?> _getItemFromPageUrl(String url) async {
    final repo = ref.watch(paginationProvidingRepoProvider);
    if (arg.type == 'search' || arg.type == 'all') {
      final res = await repo.paginatedProductFromUrl(url);
      return res.fold((l) => null, (r) => r.data);
    }

    final res = await repo.pageFromHome(url);
    return res.fold((l) => null, (r) => r.data.mappedForPaging(arg.type));
  }

  Future<void> nextPage() async => _onPageAction(true);
  Future<void> previousPage() async => _onPageAction(false);

  Future<void> _onPageAction(bool isNextPage) async {
    final stateData = await future;
    state = const AsyncValue.loading();
    final url = isNextPage
        ? stateData.pagination?.nextPageUrl
        : stateData.pagination?.prevPageUrl;

    if (url == null) return;

    final result = await _getItemFromPageUrl(url);

    final ItemListWithPageData(listData: data, :pagination) =
        result ?? const ItemListWithPageData.empty();

    if (data is List<DigitalProduct>) {
      _setState(stateData.setDigital(data, pagination));
      return;
    }
    if (data is List<ProductsData>) {
      _setState(stateData.setRegular(data, pagination));
      return;
    }
    state = AsyncValue.error('Unexecuted error', StackTrace.current);
  }

  num _getProductPrice(ProductsData product) =>
      product.isDiscounted ? product.discountAmount : product.price;

  Future<List<ProductsData>> _productFilter(
    List<ProductsData> products,
    String query,
  ) async {
    final stateData = await future;

    // modifiable product list
    List<ProductsData> filtered = products.toList();

    if (query.isNotEmpty) {
      filtered.retainWhere((e) => e.name.contains(query));
    }

    // comparing product 'b.price' with 'a.price'
    // sort in descending order
    filtered.sort((a, b) => _getProductPrice(b).compareTo(_getProductPrice(a)));

    // if sort type is high to low then reverse the list
    if (stateData.sortType != SortType.highToLow) {
      filtered = filtered.reversed.toList();
    }

    // because category.name is a [Map<String,String>]
    // loop through the values of the selected category
    // and retain only the products that contains same nam
    if (stateData.category != null) {
      for (var c in stateData.category!.name.values) {
        filtered.retainWhere((e) => e.category.values.contains(c));
      }
    }

    // same as category
    if (stateData.brand != null) {
      for (var b in stateData.brand!.name.values) {
        filtered.retainWhere((e) => e.brand.values.contains(b));
      }
    }

    final maxPrice = stateData.max.asInt;
    final minPrice = stateData.min.asInt;

    if (maxPrice != 0) {
      filtered.retainWhere((e) => _getProductPrice(e) <= maxPrice);
    }
    if (minPrice != 0) {
      filtered.retainWhere((e) => _getProductPrice(e) >= minPrice);
    }

    return filtered;
  }

  Future<List<DigitalProduct>> _digitalProductFilter(
    List<DigitalProduct> products,
    String query,
  ) async {
    final stateData = await future;
    List<DigitalProduct> filtered = products.toList();

    if (query.isNotEmpty) {
      filtered.retainWhere((e) => e.name.contains(query));
    }

    filtered.sort((a, b) => b.price.compareTo(a.price));

    if (stateData.sortType != SortType.highToLow) {
      filtered = filtered.reversed.toList();
    }
    final maxPrice = stateData.max.asInt;
    final minPrice = stateData.min.asInt;

    if (maxPrice != 0) {
      filtered.retainWhere((e) => e.price <= maxPrice);
    }
    if (minPrice != 0) {
      filtered.retainWhere((e) => e.price >= minPrice);
    }
    return filtered;
  }

  @override
  FutureOr<ProductFilteringState> build(FilterArgs arg) async {
    state = AsyncValue.data(ProductFilteringState.empty);

    return _setStateProducts(arg.query);
  }
}
