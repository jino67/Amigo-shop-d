import 'package:e_com/core/core.dart';
import 'package:e_com/models/models.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final categoryRepoProvider = Provider<CategoryRepo>((ref) => CategoryRepo(ref));

class CategoryRepo {
  CategoryRepo(this._ref);

  final Ref _ref;

  FutureEither<ApiResponse<CategoryDetails>> getCategoryProducts(
      String uid) async {
    try {
      final response = await _dio.get(Endpoints.categoryProducts(uid));
      final productRes = ApiResponse.fromMap(
        response.data,
        (json) => CategoryDetails.fromMap(json),
      );

      return right(productRes);
    } on DioException catch (e) {
      final failure = DioExp(e).toFailure();
      return left(failure);
    }
  }

  DioClient get _dio => DioClient(_ref);

  FutureEither<ApiResponse<CategoryDetails>> getCategoryFromUrl(
      String url) async {
    try {
      final response = await _dio.get(url);

      final productRes = ApiResponse.fromMap(
        response.data,
        (json) => CategoryDetails.fromMap(json),
      );

      return right(productRes);
    } on DioException catch (e) {
      final failure = DioExp(e).toFailure();
      return left(failure);
    }
  }
}
