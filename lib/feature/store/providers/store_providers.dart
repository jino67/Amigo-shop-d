import 'package:e_com/core/core.dart';
import 'package:e_com/models/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final storeListProvider = Provider<ItemListWithPageData<StoreModel>?>((ref) {
  final pref = ref.watch(sharedPrefProvider);
  final stores = pref.getString(CachedKeys.shops);
  if (stores == null) return null;

  return ItemListWithPageData<StoreModel>.fromJson(
    stores,
    (source) => StoreModel.fromJson(source),
  );
});
