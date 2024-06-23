import 'package:e_com/core/core.dart';
import 'package:e_com/models/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final checkoutStateProvider = Provider.autoDispose<OrderBaseModel?>((ref) {
  final pref = ref.watch(sharedPrefProvider);
  final data = pref.getString(CachedKeys.orderBase);

  if (data != null) return OrderBaseModel.fromJson(data);

  return null;
});
