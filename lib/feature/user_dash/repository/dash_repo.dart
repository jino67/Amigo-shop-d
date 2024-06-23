import 'package:e_com/core/core.dart';
import 'package:e_com/models/base/api_res_model.dart';
import 'package:e_com/models/user_content/user_dash_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final userDashRepoProvider = Provider<UserDashRepo>((ref) {
  return UserDashRepo(ref);
});

class UserDashRepo {
  UserDashRepo(this._ref);

  final Ref _ref;

  DioClient get _dio => DioClient(_ref);

  FutureEither<ApiResponse<UserDashModel>> getUserDash() async {
    try {
      final response = await _dio.get(Endpoints.userDash);

      final res = ApiResponse.fromMap(
        response.data,
        (map) => UserDashModel.fromMap(map),
      );

      return right(res);
    } on DioException catch (e, s) {
      final failure = DioExp(e).toFailure(s);
      return left(failure);
    } catch (e, s) {
      return left(Failure(e.toString(), stackTrace: s));
    }
  }

  FutureEither<ApiResponse<UserDashModel>> dashFromUrl(String url) async {
    try {
      final response = await _dio.get(url);

      final res = ApiResponse.fromMap(
        response.data,
        (map) => UserDashModel.fromMap(map),
      );

      return right(res);
    } on DioException catch (e) {
      final failure = DioExp(e).toFailure();
      return left(failure);
    }
  }
}
