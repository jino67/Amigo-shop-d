import 'package:e_com/core/core.dart';
import 'package:e_com/models/models.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final productsRepoProvider = Provider<ProductsRepo>((ref) => ProductsRepo(ref));

class ProductsRepo {
  ProductsRepo(this._ref);

  DioClient get _dio => DioClient(_ref);
  final Ref _ref;

  FutureEither<ApiResponse<ProductDetailsResponse>> getProductDetails({
    required String uid,
    required String? campaignId,
    required bool isRegular,
  }) async {
    try {
      final endPoint = isRegular
          ? Endpoints.productDetails(uid, campaignId)
          : Endpoints.digitalProductDetails(uid);

      final response = await _dio.get(endPoint);

      final productRes = ApiResponse.fromMap(
        response.data,
        (json) => ProductDetailsResponse.fromMap(json),
      );

      return right(productRes);
    } on DioException catch (e) {
      final failure = DioExp(e).toFailure();
      return left(failure);
    }
  }

  FutureEither<ApiResponse<ItemListWithPageData<ProductsData>>> getAllProduct({
    required String query,
    String? brandUid,
    String? categoryUid,
    String? min,
    String? max,
    SortType? sort,
  }) async {
    try {
      final queryParameters = {
        if (query.isNotEmpty) 'name': query,
        'brand_uid': brandUid,
        'category_uid': categoryUid,
        'search_min': min,
        'serach_max': max,
        'sort_by': sort?.queryParam ?? 'default',
      };
      final endPoint =
          Uri(path: '/products', queryParameters: queryParameters).toString();

      final response = await _dio.get(endPoint);

      final productRes = ApiResponse.fromMap(
        response.data,
        (json) => ItemListWithPageData.fromMap(
          json['products'],
          (json) => ProductsData.fromMap(json),
        ),
      );

      return right(productRes);
    } on DioException catch (e) {
      final failure = DioExp(e).toFailure();
      return left(failure);
    }
  }
}
