import 'package:e_com/core/core.dart';
import 'package:e_com/feature/user_dash/provider/user_dash_provider.dart';
import 'package:e_com/feature/user_profile/repository/user_profile_repo.dart';
import 'package:e_com/models/user_content/user_profile_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final userProfileProvider =
    AutoDisposeNotifierProvider<UserProfileCtrl, UserModel>(
        UserProfileCtrl.new);

class UserProfileCtrl extends AutoDisposeNotifier<UserModel> {
  @override
  UserModel build() {
    final user = ref.watch(userDashProvider.select((value) => value?.user)) ??
        UserModel.empty;

    return user;
  }

  UserProfileRepo get _repo => ref.read(userProfileRepoProvider);

  void setUser(UserModel user) => state = user.copyWith(
        image: state.image,
        imageFile: () => state.imageFile,
      );

  Future<void> updateProfile() async {
    final user = await _repo.updateProfile(state);
    await user.fold(
      (l) async => Toaster.showError(l),
      (r) async {
        Toaster.showSuccess(r.message);
        ref.invalidateSelf();
      },
    );
  }

  Future<void> pickAndSetImage(ImageSource source) async {
    final picked = await ref.watch(filePickerProvider).pickImage(source);

    picked.fold(
      (l) => Toaster.showError(l),
      (r) => state = state.copyWith(imageFile: () => r),
    );
  }
}
