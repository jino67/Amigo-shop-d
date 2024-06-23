import 'package:e_com/models/settings/region_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final localeCurrencyStateProvider = StateProvider<LocalCurrency>((ref) {
  return LocalCurrency.nulled;
});

final defaultLangStateProvider = StateProvider<LanguagesData?>((ref) {
  return null;
});

String? defLocale(WidgetRef ref) =>
    ref.watch(defaultLangStateProvider.select((v) => v?.code));
