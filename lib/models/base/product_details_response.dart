import 'dart:convert';

import 'package:e_com/models/models.dart';

class ProductDetailsResponse {
  ProductDetailsResponse({
    this.product,
    required this.relatedProduct,
    this.digitalProduct,
  });

  factory ProductDetailsResponse.fromJson(String source) =>
      ProductDetailsResponse.fromMap(json.decode(source));

  factory ProductDetailsResponse.fromMap(Map<String, dynamic> map) {
    return ProductDetailsResponse(
      product: map.containsKey('product')
          ? ProductsData.fromMap(map['product'])
          : null,
      digitalProduct: map.containsKey('digital_product')
          ? DigitalProduct.fromMap(map['digital_product'])
          : null,
      relatedProduct: List<dynamic>.from(
        map['related_product']['data']?.map((x) => map.containsKey('product')
            ? ProductsData.fromMap(x)
            : DigitalProduct.fromMap(x)),
      ),
    );
  }

  final ProductsData? product;
  final DigitalProduct? digitalProduct;
  final List<dynamic> relatedProduct;
}
