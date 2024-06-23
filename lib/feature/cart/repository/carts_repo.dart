import 'package:e_com/core/core.dart';
import 'package:e_com/models/models.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final cartsRepoProvider = Provider<CartsRepo>((ref) {
  return CartsRepo(ref);
});

class CartsRepo {
  CartsRepo(this._ref);

  final Ref _ref;

  DioClient get _dio => DioClient(_ref);

  FutureEither<ApiResponse<PostMessage>> addToCart({
    required String productUid,
    String? campaignUid,
    String? attribute,
    required int quantity,
  }) async {
    try {
      final response = await _dio.post(
        Endpoints.cartAdd,
        data: {
          'product_uid': productUid,
          if (campaignUid != null) 'campaign_uid': campaignUid,
          if (attribute != null) 'attribute_combination': attribute,
          'quantity': quantity,
        },
      );
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

  FutureEither<ApiResponse<PostMessage>> deleteCart(
    String uid,
  ) async {
    try {
      final response = await _dio.post(
        Endpoints.cartDelete,
        data: {'uid': uid},
      );
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

  FutureEither<ApiResponse<PostMessage>> updateQuantity({
    required String uid,
    required int quantity,
  }) async {
    try {
      final response = await _dio.post(
        Endpoints.cartUpdate,
        data: {
          'uid': uid,
          'quantity': quantity,
        },
      );
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

  FutureEither<String> transferFromGuest(List<CartData> carts) async {
    try {
      for (var cart in carts) {
        final res = await addToCart(
          productUid: cart.product.uid,
          attribute: cart.variant,
          quantity: cart.quantity.asInt,
        );
        res.fold(
          (l) => talk.error(l.message, l, l.stackTrace),
          (r) {},
        );
      }

      return right('Carts transferred successfully');
    } on DioException catch (e) {
      final failure = DioExp(e).toFailure();
      return left(failure);
    }
  }
}
