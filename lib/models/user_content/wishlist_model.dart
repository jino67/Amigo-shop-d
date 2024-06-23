import 'package:e_com/models/models.dart';

class WishlistData {
  WishlistData({
    required this.uid,
    required this.product,
  });

  factory WishlistData.fromMap(Map<String, dynamic> map) {
    return WishlistData(
      uid: map['uid'] ?? '',
      product: ProductsData.fromMap(map['product']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'product': product.toMap(),
    };
  }

  final ProductsData product;
  final String uid;
}
