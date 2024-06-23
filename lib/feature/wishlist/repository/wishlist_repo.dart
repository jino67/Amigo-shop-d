import 'package:e_com/core/core.dart';
import 'package:e_com/models/base/api_res_model.dart';
import 'package:e_com/models/misc/post_message.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final wishlistRepoProvider = Provider<WishlistRepo>((ref) {
  return WishlistRepo(ref);
});

class WishlistRepo {
  WishlistRepo(this._ref);

  final Ref _ref;

  DioClient get _dio => DioClient(_ref);

  FutureEither<ApiResponse<PostMessage>> addToWishlist(
    String productUid,
  ) async {
    try {
      final response = await _dio.post(
        Endpoints.wishlistAdd,
        data: {'product_uid': productUid},
      );
      final authRes = ApiResponse.fromMap(
        response.data,
        (map) => PostMessage.fromMap(map),
      );
      return right(authRes);
    } on DioException catch (e) {
      final failure = DioExp(e).toFailure();
      return left(failure);
    }
  }

  FutureEither<ApiResponse<PostMessage>> deleteWishlist(
    String uid,
  ) async {
    try {
      final response = await _dio.post(
        Endpoints.wishlistDelete,
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
}
