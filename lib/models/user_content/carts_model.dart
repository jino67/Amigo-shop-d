import 'package:e_com/models/models.dart';

class CartData {
  CartData({
    required this.product,
    required this.uid,
    required this.price,
    required this.total,
    required this.variant,
    required this.quantity,
  });

  factory CartData.fromMap(Map<String, dynamic> map) {
    return CartData(
      uid: map['uid'] ?? '',
      price: map['pirce'] ?? 0,
      quantity: map['qty'] ?? 0,
      total: map['total'] ?? 0,
      variant: map['varitent'] ?? '',
      product: ProductsData.fromMap(map['product']),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'pirce': price,
      'qty': quantity,
      'total': total,
      'varitent': variant,
      'product': product.toMap(),
    };
  }

  final ProductsData product;
  final String uid;
  final num price;
  final num total;
  final String variant;
  final String quantity;

  CartData copyWith({
    num? price,
    num? total,
    String? variant,
    String? quantity,
  }) {
    return CartData(
      product: product,
      uid: uid,
      price: price ?? this.price,
      total: total ?? this.total,
      variant: variant ?? this.variant,
      quantity: quantity ?? this.quantity,
    );
  }
}
