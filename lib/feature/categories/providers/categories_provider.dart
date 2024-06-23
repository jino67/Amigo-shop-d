import 'package:e_com/core/core.dart';
import 'package:e_com/models/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final categoryListProvider = Provider<List<CategoriesData>>((ref) {
  final pref = ref.watch(sharedPrefProvider);
  final data = pref.getStringList(CachedKeys.categories);

  if (data != null) {
    return data.map((e) => CategoriesData.fromJson(e)).toList();
  }
  return [];
});
