import 'dart:async';

import 'package:e_com/feature/products/repository/products_repo.dart';
import 'package:e_com/models/base/product_details_response.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

typedef ProductCtrlParam = ({String uid, String? campaignId, bool isRegular});

final productCtrlProvider = AsyncNotifierProviderFamily<ProductsCtrlNotifier,
    ProductDetailsResponse, ProductCtrlParam>(ProductsCtrlNotifier.new);

class ProductsCtrlNotifier
    extends FamilyAsyncNotifier<ProductDetailsResponse, ProductCtrlParam> {
  FutureOr<ProductDetailsResponse> _init() async {
    final res = await _repo.getProductDetails(
      uid: arg.uid,
      campaignId: arg.campaignId,
      isRegular: arg.isRegular,
    );

    return res.fold((l) => Future.error(l, l.stackTrace), (r) => r.data);
  }

  ProductsRepo get _repo => ref.watch(productsRepoProvider);

  silentReload() async {
    state = AsyncValue.data(await _init());
  }

  @override
  Future<ProductDetailsResponse> build(ProductCtrlParam arg) async {
    return await _init();
  }
}
