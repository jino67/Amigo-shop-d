import 'package:e_com/core/core.dart';
import 'package:e_com/models/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final brandListProvider = Provider<List<BrandData>>((ref) {
  final pref = ref.watch(sharedPrefProvider);
  final data = pref.getStringList(CachedKeys.brands);

  if (data != null) {
    return data.map((e) => BrandData.fromJson(e)).toList();
  }
  return [];
});
