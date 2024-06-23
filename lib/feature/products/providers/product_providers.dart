import 'package:e_com/core/core.dart';
import 'package:e_com/feature/products/repository/products_repo.dart';
import 'package:e_com/models/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final allProductsLisProvider = FutureProvider<List<ProductsData>>((ref) async {
  final repo = ref.watch(productsRepoProvider);
  final res = await repo.getAllProduct(query: '');

  return res.fold((l) => Future.error(l, l.stackTrace), (r) => r.data.listData);
});

final productListProvider =
    Provider.autoDispose<Map<String, ItemListWithPageData<ProductsData>>>(
        (ref) {
  final pref = ref.watch(sharedPrefProvider);

  final productMap = <String, ItemListWithPageData<ProductsData>>{};

  final newProduct = pref.getString(CachedKeys.newProducts);
  productMap[CachedKeys.newProducts] =
      ItemListWithPageData<ProductsData>.fromJson(
    newProduct,
    (source) => ProductsData.fromJson(source),
  );

  final dealProduct = pref.getString(CachedKeys.todaysProducts);
  productMap[CachedKeys.todaysProducts] =
      ItemListWithPageData<ProductsData>.fromJson(
    dealProduct,
    (source) => ProductsData.fromJson(source),
  );

  final bestProduct = pref.getString(CachedKeys.bestSaleProducts);
  productMap[CachedKeys.bestSaleProducts] =
      ItemListWithPageData<ProductsData>.fromJson(
    bestProduct,
    (source) => ProductsData.fromJson(source),
  );

  final suggestedProduct = pref.getString(CachedKeys.suggestedProducts);
  productMap[CachedKeys.suggestedProducts] =
      ItemListWithPageData<ProductsData>.fromJson(
    suggestedProduct,
    (source) => ProductsData.fromJson(source),
  );

  return productMap;
});

final digitalProductListProvider =
    Provider.autoDispose<ItemListWithPageData<DigitalProduct>>((ref) {
  final pref = ref.watch(sharedPrefProvider);
  final digitalProduct = pref.getString(CachedKeys.digitalProducts);
  return ItemListWithPageData<DigitalProduct>.fromJson(
    digitalProduct,
    (source) => DigitalProduct.fromJson(source),
  );
});
