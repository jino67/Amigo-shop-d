import 'dart:convert';

import 'package:e_com/core/core.dart';
import 'package:e_com/models/models.dart';

class DigitalProduct {
  DigitalProduct({
    required this.uid,
    required this.name,
    required this.attribute,
    required this.price,
    required this.shortDescription,
    required this.description,
    required this.featuredImage,
    required this.url,
    required this.store,
  });

  factory DigitalProduct.fromJson(String source) =>
      DigitalProduct.fromMap(json.decode(source));

  factory DigitalProduct.fromMap(Map<String, dynamic> map) {
    return DigitalProduct(
      attribute: _parseAttribute(map),
      description: map['description'] ?? '',
      featuredImage: map['featured_image'] ?? '',
      name: map['name'] ?? '',
      price: intFromAny(map['price']),
      shortDescription: map['short_description'],
      uid: map['uid'] ?? '',
      url: map['url'] ?? '',
      store: map['seller'] == null ? null : StoreModel.fromMap(map['seller']),
    );
  }

  final Map<String, Attribute> attribute;
  final String description;
  final String featuredImage;
  final String name;
  final int price;
  final String? shortDescription;
  final String uid;
  final String url;
  final StoreModel? store;

  static Map<String, Attribute> _parseAttribute(Map<String, dynamic> map) {
    Map<String, Attribute> attributeMap = {};
    Map<String, Map<String, dynamic>>.from(map['attribute'])
        .forEach((key, value) => attributeMap[key] = Attribute.fromMap(value));

    return attributeMap;
  }

  Map<String, dynamic> toMap() => {
        'attribute':
            attribute.map((key, value) => MapEntry(key, value.toMap())),
        'description': description,
        'featured_image': featuredImage,
        'name': name,
        'price': price,
        'short_description': shortDescription,
        'uid': uid,
        'url': url,
        'seller': store?.toMap(),
      };

  String toJson() => json.encode(toMap());
}

class Attribute {
  Attribute({
    required this.price,
    required this.productId,
    required this.shortDetails,
    required this.uid,
  });

  factory Attribute.fromMap(Map<String, dynamic> map) {
    return Attribute(
      productId: intFromAny(map['product_id']),
      price: intFromAny(map['price']),
      shortDetails: map['short_details'],
      uid: map['uid'] ?? '',
    );
  }
  factory Attribute.fromJson(String source) =>
      Attribute.fromMap(json.decode(source));

  Map<String, dynamic> toMap() => {
        'product_id': productId,
        'price': price,
        'short_details': shortDetails,
        'uid': uid,
      };

  String toJson() => json.encode(toMap());

  final int price;
  final int productId;
  final String? shortDetails;
  final String uid;
}
