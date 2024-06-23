import 'package:e_com/core/core.dart';
import 'package:e_com/models/models.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final paginationProvidingRepoProvider =
    Provider<PaginationProvidingRepo>((ref) {
  return PaginationProvidingRepo(ref);
});

class PaginationProvidingRepo {
  PaginationProvidingRepo(this._ref);

  final Ref _ref;

  FutureEither<ApiResponse<ItemListWithPageData<ProductsData>>>
      paginatedProductFromUrl(String pageUrl) async {
    try {
      final response = await _dio.get(pageUrl);

      final result = ApiResponse.fromMap(
        response.data,
        (json) => ItemListWithPageData.fromMap(
          json['products'],
          (json) => ProductsData.fromMap(json),
        ),
      );

      return right(result);
    } on DioException catch (e) {
      final failure = DioExp(e).toFailure();
      return left(failure);
    }
  }

  FutureEither<ApiResponse<HomeResponseData>> pageFromHome(
    String url,
  ) async {
    try {
      final response = await _dio.get(url);

      final homeRes = ApiResponse.fromMap(
        response.data,
        (json) => HomeResponseData.fromMap(json),
      );

      return right(homeRes);
    } on DioException catch (e) {
      final failure = DioExp(e).toFailure();
      return left(failure);
    }
  }

  DioClient get _dio => DioClient(_ref);
}
