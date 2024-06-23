import 'package:e_com/core/core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final onBoardRepoProvider = Provider<OnBoardRepo>((ref) {
  return OnBoardRepo(ref);
});

class OnBoardRepo {
  OnBoardRepo(this._ref);

  final Ref _ref;

  SharedPreferences get _pref => _ref.watch(sharedPrefProvider);

  final String _prefKey = PrefKeys.isFirst;

  bool isFirstTime() {
    final isFirst = _pref.getBool(_prefKey);

    final first = isFirst == null;

    return first;
  }

  disableOnBoard() async {
    await _pref.setBool(_prefKey, false);
  }

  reload() async {
    await _pref.reload();
  }
}
