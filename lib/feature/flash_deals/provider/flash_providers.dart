import 'package:e_com/core/core.dart';
import 'package:e_com/models/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final flashDealProvider = Provider.autoDispose<FlashDeal?>((ref) {
  final pref = ref.watch(sharedPrefProvider);
  final flash = pref.getString(CachedKeys.flash);
  if (flash == null) return null;
  return FlashDeal.fromJson(flash);
});
