import 'package:e_com/core/core.dart';
import 'package:e_com/models/models.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final storeRepoProvider = Provider<StoreRepo>((ref) {
  return StoreRepo(ref);
});

class StoreRepo {
  StoreRepo(this._ref);

  final Ref _ref;

  FutureEither<ApiResponse<List<StoreModel>>> getAllStore() async {
    try {
      final response = await _dio.get(Endpoints.shop);

      final shores = ApiResponse.fromMap(
        response.data,
        (json) => List<StoreModel>.from(
          json['shops']?.map((x) => StoreModel.fromMap(x)),
        ),
      );

      return right(shores);
    } on DioException catch (e) {
      final failure = DioExp(e).toFailure();
      return left(failure);
    }
  }

  FutureEither<ApiResponse<StoreDetailsModel>> shopDetails(String id) async {
    try {
      final response = await _dio.get(Endpoints.shopDetails(id));
      final storeData = ApiResponse.fromMap(
        response.data,
        (json) => StoreDetailsModel.fromMap(json),
      );

      return right(storeData);
    } on DioException catch (e) {
      final failure = DioExp(e).toFailure();
      return left(failure);
    }
  }

  FutureEither<ApiResponse<StoreDetailsModel>> paginateFromUrl(
      String url) async {
    try {
      final response = await _dio.get(url);
      final storeData = ApiResponse.fromMap(
        response.data,
        (json) => StoreDetailsModel.fromMap(json),
      );

      return right(storeData);
    } on DioException catch (e) {
      final failure = DioExp(e).toFailure();
      return left(failure);
    }
  }

  FutureEither<ApiResponse<String>> followShop(String id) async {
    try {
      final response = await _dio.get(Endpoints.shopFollow(id));
      final data = ApiResponse.fromMap(
        response.data,
        (json) => json['message'].toString(),
      );

      return right(data);
    } on DioException catch (e) {
      final failure = DioExp(e).toFailure();
      return left(failure);
    }
  }

  DioClient get _dio => DioClient(_ref);
}
