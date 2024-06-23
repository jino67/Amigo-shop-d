import 'package:e_com/feature/on_board/repository/on_board_repo.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final onboardCtrlProvider = NotifierProvider<OnboardCtrlNotifier, bool>(() {
  return OnboardCtrlNotifier();
});

class OnboardCtrlNotifier extends Notifier<bool> {
  OnBoardRepo get _repo => ref.read(onBoardRepoProvider);

  @override
  bool build() => ref.watch(onBoardRepoProvider).isFirstTime();

  Future<void> disableOnBoard() async {
    await _repo.disableOnBoard();
    ref.invalidateSelf();
  }

  Future<void> reload() async => await _repo.reload();
}
