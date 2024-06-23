import 'package:e_com/core/core.dart';
import 'package:e_com/models/models.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final searchRepoProvider = Provider<SearchRepo>((ref) => SearchRepo(ref));

class SearchRepo {
  SearchRepo(this._ref);

  final Ref _ref;

  FutureEither<ApiResponse<ItemListWithPageData<ProductsData>>> searchProduct(
    String name,
  ) async {
    try {
      final response = await _dio.get(Endpoints.searchProduct(name));

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

  DioClient get _dio => DioClient(_ref);
}
