import 'dart:convert';

import 'package:e_com/models/models.dart';

class FlashDeal {
  FlashDeal({
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.bannerImage,
    required this.products,
  });

  factory FlashDeal.fromJson(String str) => FlashDeal.fromMap(json.decode(str));

  factory FlashDeal.fromMap(Map<String, dynamic> map) => FlashDeal(
        name: map["name"],
        startDate: DateTime.parse(map["start_date"]),
        endDate: DateTime.parse(map["end_date"]),
        bannerImage: map["banner_image"],
        products: List<ProductsData>.from(
            map["products"]['data'].map((x) => ProductsData.fromMap(x))),
      );

  final String bannerImage;
  final DateTime endDate;
  final String name;
  final List<ProductsData> products;
  final DateTime startDate;

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        "name": name,
        "start_date": startDate.toIso8601String(),
        "end_date": endDate.toIso8601String(),
        "banner_image": bannerImage,
        "products": {
          'data': List<dynamic>.from(products.map((x) => x.toMap()))
        },
      };
}
