import 'package:e_com/core/core.dart';
import 'package:e_com/models/models.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final brandRepositoryProvider =
    Provider<BrandRepository>((ref) => BrandRepository(ref));

class BrandRepository {
  BrandRepository(this._ref);

  final Ref _ref;

  FutureEither<ApiResponse<BrandProducts>> getBrandProducts(String uid) async {
    try {
      final response = await _dio.get(Endpoints.brandProducts(uid));

      final productRes = ApiResponse.fromMap(
        response.data,
        (json) => BrandProducts.fromMap(json),
      );

      return right(productRes);
    } on DioException catch (e) {
      final failure = DioExp(e).toFailure();
      return left(failure);
    }
  }

  DioClient get _dio => DioClient(_ref);
}
