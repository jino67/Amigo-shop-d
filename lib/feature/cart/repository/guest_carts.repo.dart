import 'package:e_com/core/core.dart';
import 'package:e_com/models/models.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final guestCartRepoProvider = Provider<GuestCartRepo>((ref) {
  return GuestCartRepo(ref);
});

class GuestCartRepo {
  GuestCartRepo(this._ref);
  final Ref _ref;

  final int _limit = 5;

  final _key = CachedKeys.guestCart;
  SharedPreferences get _pref => _ref.watch(sharedPrefProvider);

  ItemListWithPageData<CartData> getCart() {
    final data = _pref.getString(_key);

    final res = ItemListWithPageData<CartData>.fromJson(
      data,
      (x) => CartData.fromMap(x),
    );
    return res;
  }

  Future<void> clearAll() async => await _pref.remove(_key);

  Future<String> deleteCart(String id) async {
    final old = getCart();
    final data = ItemListWithPageData(
      listData: old.listData.where((element) => element.uid != id).toList(),
      pagination: null,
    );

    await _pref.setString(_key, data.toJson((x) => x.toMap()));

    return 'Product deleted from cart';
  }

  FutureEither<String> addToCart(
    ProductsData product, {
    String? variant,
  }) async {
    final old = getCart();
    if (old.length >= _limit) {
      return left(const Failure('Limite panier atteint'));
    }
    if (old.listData.any((element) => element.uid == product.uid)) {
      return left(const Failure('Produit déjà dans le panier'));
    }
    final att = product.variantPrices[variant] == null
        ? VariantPrice.fromMap(product.variantPrices.values.first)
        : VariantPrice.fromMap(product.variantPrices[variant]);

    if (att.quantity <= 0) {
      return left(const Failure('En rupture de stock'));
    }

    final cart = CartData(
      product: product,
      uid: product.uid,
      price: att.price,
      total: att.price,
      variant: variant ?? product.variantPrices.keys.first,
      quantity: 1.toString(),
    );
    final data = ItemListWithPageData(
      listData: [...old.listData, cart],
      pagination: null,
    );
    await _pref.setString(_key, data.toJson((x) => x.toMap()));
    return right('Ajouté au panier');
  }

  Future<void> updateQuantity(String cartUid, int quantity) async {
    if (quantity <= 0) return;

    final old = getCart();
    final cart = [
      for (final cart in old.listData)
        if (cart.uid == cartUid)
          cart.copyWith(
            quantity: quantity.toString(),
            total: cart.price * quantity,
          )
        else
          cart,
    ];

    final data = old.copyWith(listData: cart);

    await _pref.setString(_key, data.toJson((x) => x.toMap()));

    return;
  }
}
