import 'dart:convert';

import 'package:e_com/models/models.dart';

class Brands {
  Brands({required this.brandsData});

  factory Brands.fromJson(String source) => Brands.fromMap(json.decode(source));

  factory Brands.fromMap(Map<String, dynamic> map) {
    return Brands(
      brandsData:
          List<BrandData>.from(map['data']?.map((x) => BrandData.fromMap(x))),
    );
  }

  final List<BrandData> brandsData;

  Map<String, dynamic> toMap() {
    return {
      'data': brandsData.map((x) => x.toMap()),
    };
  }
}

class BrandData {
  BrandData({
    required this.uid,
    required this.name,
    required this.logo,
  });

  factory BrandData.fromJson(String source) =>
      BrandData.fromMap(json.decode(source));

  factory BrandData.fromMap(Map<String, dynamic> map) {
    return BrandData(
      uid: map['uid'] ?? '',
      name: Map<String, String?>.from(map['name']),
      logo: map['logo'] ?? '',
    );
  }

  final String logo;
  final Map<String, String?> name;
  final String uid;

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'logo': logo,
    };
  }

  String toJson() => json.encode(toMap());
}

class BrandProducts {
  BrandProducts({
    required this.brand,
    required this.products,
  });

  factory BrandProducts.fromJson(String source) =>
      BrandProducts.fromMap(json.decode(source));

  factory BrandProducts.fromMap(Map<String, dynamic> map) {
    return BrandProducts(
      brand: BrandData.fromMap(map['brand']),
      products: List<ProductsData>.from(
          map['products']['data']?.map((x) => ProductsData.fromMap(x))),
    );
  }

  final BrandData brand;
  final List<ProductsData> products;
}
