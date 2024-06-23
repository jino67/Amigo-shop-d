import 'dart:convert';

import 'package:e_com/models/models.dart';

class CategoriesBase {
  CategoriesBase({required this.categoriesData});

  factory CategoriesBase.fromJson(String source) =>
      CategoriesBase.fromMap(json.decode(source));

  factory CategoriesBase.fromMap(Map<String, dynamic> map) {
    return CategoriesBase(
      categoriesData: List<CategoriesData>.from(
          map['data']?.map((x) => CategoriesData.fromMap(x))),
    );
  }

  final List<CategoriesData> categoriesData;

  Map<String, dynamic> toMap() {
    return {
      'data': categoriesData.map((x) => x.toMap()),
    };
  }
}

class CategoriesData {
  CategoriesData({
    required this.uid,
    required this.name,
    required this.image,
  });

  factory CategoriesData.fromJson(String source) =>
      CategoriesData.fromMap(json.decode(source));

  factory CategoriesData.fromMap(Map<String, dynamic> map) {
    return CategoriesData(
      uid: map['uid'] ?? '',
      name: Map<String, String?>.from(map['name']),
      image: map['image'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'image': image,
    };
  }

  final String image;
  final Map<String, String?> name;
  final String uid;
}

class CategoryDetails {
  CategoryDetails({
    required this.category,
    required this.products,
    required this.homeTitle,
  });

  factory CategoryDetails.fromJson(String source) =>
      CategoryDetails.fromMap(json.decode(source));

  factory CategoryDetails.fromMap(Map<String, dynamic> map) {
    return CategoryDetails(
      category: CategoriesData.fromMap(map['category']),
      products: ItemListWithPageData<ProductsData>.fromMap(
        map['products'],
        (x) => ProductsData.fromMap(x),
      ),
      homeTitle: map['title'],
    );
  }

  final CategoriesData category;
  final ItemListWithPageData<ProductsData> products;
  final String? homeTitle;

  Map<String, dynamic> toMap() {
    return {
      'category': category.toMap(),
      'products': products.toMap((data) => data.toMap()),
      'title': homeTitle,
    };
  }
}
