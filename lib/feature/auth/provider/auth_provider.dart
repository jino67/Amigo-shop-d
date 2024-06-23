import 'package:e_com/core/core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final savedTokenProvider = Provider<String?>((ref) {
  final pref = ref.watch(sharedPrefProvider);
  return pref.getString(PrefKeys.accessToken);
});
