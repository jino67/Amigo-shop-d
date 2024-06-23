import 'package:e_com/core/core.dart';
import 'package:e_com/models/models.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final settingsRepoProvider = Provider<SettingsRepo>((ref) => SettingsRepo(ref));

class SettingsRepo {
  SettingsRepo(this._ref);

  final Ref _ref;

  FutureEither<ApiResponse<ConfigModel>> getConfig() async {
    try {
      final response = await _dio.get(Endpoints.config);

      final configRes = ApiResponse.fromMap(
        response.data,
        (json) => ConfigModel.fromMap(json),
      );
      return right(configRes);
    } on DioException catch (e) {
      final failure = DioExp(e).toFailure();
      return left(failure);
    }
  }

  DioClient get _dio => DioClient(_ref);
}
