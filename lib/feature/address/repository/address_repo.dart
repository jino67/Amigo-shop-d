import 'package:e_com/core/core.dart';
import 'package:e_com/models/models.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final addressRepoProvider = Provider<AddressRepo>((ref) {
  return AddressRepo(ref);
});

class AddressRepo {
  AddressRepo(this._ref);

  final Ref _ref;

  FutureEither<ApiResponse<UserModel>> createAddress(
    BillingAddress address,
  ) async {
    try {
      final response =
          await _dio.post(Endpoints.addressAdd, data: address.toMap());

      final res = ApiResponse.fromMap(
        response.data,
        (map) => UserModel.fromMap(map['user']),
      );

      return right(res);
    } on DioException catch (e) {
      return left(DioExp(e).toFailure());
    }
  }

  FutureEither<ApiResponse<UserModel>> deleteAddress(String key) async {
    try {
      final response = await _dio.get(Endpoints.addressDelete(key));
      final res = ApiResponse.fromMap(
        response.data,
        (map) => UserModel.fromMap(map['user']),
      );

      return right(res);
    } on DioException catch (e) {
      return left(DioExp(e).toFailure());
    }
  }

  FutureEither<ApiResponse<UserModel>> updateAddress(
    BillingAddress address,
  ) async {
    try {
      final response = await _dio.post(
        Endpoints.addressUpdate,
        data: address.toMap(),
      );

      final res = ApiResponse.fromMap(
        response.data,
        (map) => UserModel.fromMap(map['user']),
      );

      return right(res);
    } on DioException catch (e) {
      return left(DioExp(e).toFailure());
    }
  }

  DioClient get _dio => DioClient(_ref);
}
