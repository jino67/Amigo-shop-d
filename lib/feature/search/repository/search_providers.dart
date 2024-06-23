import 'dart:async';

import 'package:e_com/core/core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final searchTermsCtrlProvider =
    AsyncNotifierProvider<SearchTermsCtrlNotifier, List<String>>(
        SearchTermsCtrlNotifier.new);

class SearchTermsCtrlNotifier extends AsyncNotifier<List<String>> {
  final _key = PrefKeys.searchTerms;
  final _limit = 10;

  Future<void> setNewTerm(String query) async {
    if (query.isEmpty) return;
    final pref = ref.read(sharedPrefProvider);

    List<String> stateValue = await future.then((value) => value.toList());

    if (stateValue.length == _limit) {
      stateValue.contains(query)
          ? stateValue.remove(query)
          : stateValue.removeLast();
    }
    if (stateValue.contains(query)) stateValue.remove(query);

    stateValue.insert(0, query);

    state = AsyncValue.data([...stateValue]);

    await pref.setStringList(PrefKeys.searchTerms, stateValue);
  }

  Future<void> removeTerm(String term) async {
    final stateValue = await future;

    stateValue.remove(term);

    state = AsyncValue.data([...stateValue]);
    final pref = ref.read(sharedPrefProvider);
    await pref.setStringList(PrefKeys.searchTerms, stateValue);
  }

  @override
  FutureOr<List<String>> build() {
    final pref = ref.watch(sharedPrefProvider);
    return pref.getStringList(_key) ?? List.empty();
  }
}
