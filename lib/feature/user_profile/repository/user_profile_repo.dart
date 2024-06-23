import 'package:dio/dio.dart';
import 'package:e_com/core/core.dart';
import 'package:e_com/feature/user_dash/controller/dash_ctrl.dart';
import 'package:e_com/models/models.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final userProfileRepoProvider =
    Provider<UserProfileRepo>((ref) => UserProfileRepo(ref));

class UserProfileRepo {
  UserProfileRepo(this._ref);

  final Ref _ref;

  FutureEither<ApiResponse<PostMessage>> updateProfile(UserModel user) async {
    try {
      Map<String, dynamic> userData = user.toPostMap();

      final imageFile = user.imageFile;

      if (imageFile != null) {
        final img = await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        );

        userData.addAll({'image': img});
      }

      final response =
          await _dio.post(Endpoints.userProfileUpdate, data: userData);

      final res = ApiResponse.fromMap(
        response.data,
        (json) => PostMessage.fromMap(json),
      );

      _ref.watch(userDashCtrlProvider.notifier).reload();

      return right(res);
    } on DioException catch (e) {
      return left(DioExp(e).toFailure());
    }
  }

  DioClient get _dio => DioClient(_ref);
}
