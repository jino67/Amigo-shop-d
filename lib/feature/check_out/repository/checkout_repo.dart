import 'package:e_com/core/core.dart';
import 'package:e_com/models/models.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final checkoutRepoProvider = Provider<CheckoutRepo>((ref) {
  return CheckoutRepo(ref);
});

class CheckoutRepo {
  CheckoutRepo(this._ref);

  final Ref _ref;

  FutureEither<ApiResponse<OrderBaseModel>> submitOrder(
    CheckoutModel checkout,
    bool isGuest,
  ) async {
    try {
      final data = isGuest ? checkout.toGuestMap() : checkout.toMap();

      final response = await _dio.post(Endpoints.checkout, data: data);

      final res = ApiResponse.fromMap(
        response.data,
        (map) => OrderBaseModel.fromMap(map),
      );

      return right(res);
    } on DioException catch (e) {
      return left(DioExp(e).toFailure());
    }
  }

  FutureEither<ApiResponse<OrderBaseModel>> getPaymentLog(
    String orderUid,
    int paymentUid,
  ) async {
    try {
      final response = await _dio.get(Endpoints.payNow(orderUid, paymentUid));

      final res = ApiResponse.fromMap(
        response.data,
        (map) => OrderBaseModel.fromMap(map),
      );

      return right(res);
    } on DioException catch (e) {
      return left(DioExp(e).toFailure());
    }
  }

  FutureEither<ApiResponse<OrderBaseModel>> submitDigitalOrder({
    required Map<String, dynamic> data,
  }) async {
    try {
      Logger.json(data);
      final response = await _dio.post(Endpoints.digitalCheckout, data: data);

      final res = ApiResponse.fromMap(
        response.data,
        (map) => OrderBaseModel.fromMap(map),
      );

      return right(res);
    } on DioException catch (e) {
      return left(DioExp(e).toFailure());
    }
  }

  FutureEither<ApiResponse<PostMessage>> confirmCheckout(
    String callBack,
    String trxId,
    dynamic data, [
    String? type,
  ]) async {
    try {
      String url = '$callBack/$trxId${type != null ? '/$type' : ''}';

      final response = await _dio.post(url, data: data);

      final res = ApiResponse.fromMap(
        response.data,
        (map) => PostMessage.fromMap(map),
      );
      return right(res);
    } on DioException catch (e) {
      final failure = DioExp(e).toFailure();
      return left(failure);
    }
  }

  DioClient get _dio => DioClient(_ref);
}
