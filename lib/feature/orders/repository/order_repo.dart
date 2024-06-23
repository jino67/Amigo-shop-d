import 'package:e_com/core/core.dart';
import 'package:e_com/models/base/api_res_model.dart';
import 'package:e_com/models/user_content/order_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final orderRepoProvider = Provider<OrderRepo>((ref) {
  return OrderRepo(ref);
});

class OrderRepo {
  OrderRepo(this._ref);

  final Ref _ref;

  DioClient get _dio => DioClient(_ref);

  FutureEither<ApiResponse<OrderModel>> getOrderDetails({
    required String orderId,
  }) async {
    try {
      final response = await _dio.post(
        Endpoints.orderTrack,
        data: {'order_id': orderId},
      );

      final res = ApiResponse.fromMap(
        response.data,
        (map) => OrderModel.fromMap(map['order']),
      );
      return right(res);
    } on DioException catch (e) {
      final failure = DioExp(e).toFailure();
      return left(failure);
    }
  }
}
