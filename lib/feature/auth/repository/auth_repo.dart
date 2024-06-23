import 'package:dio/dio.dart';
import 'package:e_com/core/core.dart';
import 'package:e_com/feature/auth/provider/auth_provider.dart';
import 'package:e_com/models/models.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authRepoProvider = Provider<AuthRepo>((ref) {
  return AuthRepo(ref);
});

class AuthRepo {
  AuthRepo(this._ref);

  SharedPreferences get _pref => _ref.watch(sharedPrefProvider);
  final Ref _ref;

  /// SignIn
  FutureEither<ApiResponse<AuthAccessToken>> login({
    required String email,
    String pass = '',
    LoginType type = LoginType.manual,
    String oAuthId = '',
  }) async {
    if (oAuthId.isEmpty && type == LoginType.oAuth) {
      return left(const Failure('Error on OAuth id'));
    }
    try {
      final response = await _dio.post(
        Endpoints.login,
        data: {
          'email': email,
          'password': pass,
          'login_type': type.name,
          'o_auth_id': oAuthId,
        },
      );

      final authRes = ApiResponse.fromMap(
        response.data,
        (json) => AuthAccessToken.fromMap(json),
      );
      return right(authRes);
    } on DioException catch (e) {
      final failure = DioExp(e).toFailure();
      return left(failure);
    }
  }

  FutureEither<ApiResponse<PostMessage>> forgetPassword(String email) async {
    try {
      final response = await _dio.post(
        Endpoints.forgetPass,
        data: {'email': email},
      );

      final res = ApiResponse.fromMap(
        response.data,
        (json) => PostMessage.fromMap(json),
      );
      return right(res);
    } on DioException catch (e) {
      final failure = DioExp(e).toFailure();
      return left(failure);
    }
  }

  FutureEither<ApiResponse<PostMessage>> passwordResetVerification(
    String email,
    String otp,
  ) async {
    try {
      final response = await _dio.post(
        Endpoints.passwordResetVerify,
        data: {'email': email, 'otp': otp},
      );

      final res = ApiResponse.fromMap(
        response.data,
        (json) => PostMessage.fromMap(json),
      );
      return right(res);
    } on DioException catch (e) {
      final failure = DioExp(e).toFailure();
      return left(failure);
    }
  }

  FutureEither<ApiResponse<PostMessage>> resetPassword(
    String email,
    String otp,
    String password,
    String confirm,
  ) async {
    try {
      final response = await _dio.post(
        Endpoints.passwordReset,
        data: {
          'email': email,
          'otp': otp,
          'password': password,
          'password_confirmation': confirm
        },
      );

      final res = ApiResponse.fromMap(
        response.data,
        (json) => PostMessage.fromMap(json),
      );
      return right(res);
    } on DioException catch (e) {
      final failure = DioExp(e).toFailure();
      return left(failure);
    }
  }

  FutureEither<ApiResponse<AuthAccessToken>> verifyOTP(String otp) async {
    try {
      final response = await _dio.post(Endpoints.verifyOTP, data: {'otp': otp});

      final authRes = ApiResponse.fromMap(
        response.data,
        (json) => AuthAccessToken.fromMap(json),
      );

      return right(authRes);
    } on DioException catch (e) {
      final failure = DioExp(e).toFailure();
      return left(failure);
    }
  }

  /// SignUp
  FutureEither<ApiResponse<AuthAccessToken>> signUp(
    String name,
    String email,
    String phone,
    String pass,
    String confirmPass,
  ) async {
    try {
      final response = await _dio.post(
        Endpoints.signUp,
        data: {
          'name': name,
          'email': email,
          'phone': phone,
          'password': pass,
          'password_confirmation': confirmPass
        },
      );
      final authRes = ApiResponse.fromMap(
        response.data,
        (source) => AuthAccessToken.fromMap(source),
      );

      return right(authRes);
    } on DioException catch (e) {
      final failure = DioExp(e).toFailure();
      return left(failure);
    }
  }

  /// Log Out
  FutureEither<ApiResponse<AuthAccessToken>> logOut() async {
    try {
      final token = getAccessToken();
      if (token == null) {
        return left(const Failure('Access Token Invalid'));
      }
      final response = await _dio.post(
        Endpoints.logOut,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final authRes = ApiResponse.fromMap(
        response.data,
        (json) => AuthAccessToken.fromMap(json),
      );
      return right(authRes);
    } on DioException catch (e) {
      final failure = DioExp(e).toFailure();
      return left(failure);
    }
  }

  FutureEither<ApiResponse<PostMessage>> updatePassword(
      Map<String, dynamic> passwords) async {
    try {
      final token = getAccessToken();
      if (token == null) {
        return left(const Failure('Access Token Invalid'));
      }
      final response = await _dio.post(
        Endpoints.updatePass,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: passwords,
      );
      final authRes = ApiResponse.fromMap(
        response.data,
        (json) => PostMessage.fromMap(json),
      );
      return right(authRes);
    } on DioException catch (e) {
      final failure = DioExp(e).toFailure();
      return left(failure);
    }
  }

  /// set access token in shared preference
  Future<void> setAccessToken(String token) async {
    await _pref.setString(PrefKeys.accessToken, token);
    Logger('save token :: $token');
    _ref.invalidate(savedTokenProvider);
  }

  /// get access token from shared preference
  String? getAccessToken() {
    final token = _pref.getString(PrefKeys.accessToken);
    Logger('get token :: $token');
    return token;
  }

  bool? didAcceptedTNC() {
    final token = _pref.getBool(PrefKeys.acceptedTNC);
    return token;
  }

  Future<bool> setTNCAcceptance(bool value) async {
    final res = await _pref.setBool(PrefKeys.acceptedTNC, value);
    return res;
  }

  Future<void> resetTNCAcceptance() async {
    await _pref.remove(PrefKeys.acceptedTNC);
  }

  /// set access token in shared preference
  clearAccessToken() async {
    await _pref.remove(PrefKeys.accessToken);
  }

  clearPref() async {
    await _pref.clear();
  }

  DioClient get _dio => DioClient(_ref);
}
