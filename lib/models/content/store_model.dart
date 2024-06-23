import 'dart:convert';

import 'package:e_com/core/core.dart';
import 'package:e_com/models/models.dart';

class StoreDetailsModel {
  StoreDetailsModel({
    required this.store,
    required this.relatedShops,
    required this.products,
    required this.digitalProducts,
  });

  factory StoreDetailsModel.fromJson(String source) =>
      StoreDetailsModel.fromMap(json.decode(source));

  factory StoreDetailsModel.fromMap(Map<String, dynamic> map) {
    return StoreDetailsModel(
      store: StoreModel.fromMap(map['shop']),
      relatedShops: List<StoreModel>.from(
        map['related_shops']?['data'].map((x) => StoreModel.fromMap(x)),
      ),
      products: ItemListWithPageData.fromMap(
          map['products'], (x) => ProductsData.fromMap(x)),
      digitalProducts: ItemListWithPageData.fromMap(
          map['digital_products'], (x) => DigitalProduct.fromMap(x)),
    );
  }

  final ItemListWithPageData<DigitalProduct> digitalProducts;
  final ItemListWithPageData<ProductsData> products;
  final List<StoreModel> relatedShops;
  final StoreModel store;

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'store': store.toMap()});
    result.addAll(
      {
        'related_shops': {'data': relatedShops.map((x) => x.toMap()).toList()}
      },
    );
    result.addAll({'products': products.toMap((x) => x.toMap())});
    result.addAll(
      {'digital_products': digitalProducts.toMap((x) => x.toMap())},
    );

    return result;
  }

  String toJson() => json.encode(toMap());
}

class StoreModel {
  StoreModel({
    required this.name,
    required this.storeBanner,
    required this.storeLogo,
    required this.storeId,
    required this.rating,
    required this.totalProducts,
    required this.email,
    required this.phone,
    required this.createdAt,
    required this.shortDetails,
    required this.followers,
    required this.totalFollowers,
    required this.link,
    required this.whatsappNumber,
    required this.whatsappActive,
  });

  factory StoreModel.fromJson(String source) =>
      StoreModel.fromMap(json.decode(source));

  factory StoreModel.fromMap(Map<String, dynamic> map) {
    return StoreModel(
      name: map['name'] ?? '',
      storeBanner: map['banner'] ?? '',
      storeId: intFromAny(map['id']),
      storeLogo: map['logo'] ?? '',
      rating: intFromAny(map['rating']),
      totalProducts: intFromAny(map['total_products']),
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      createdAt: map['created_at'] ?? '',
      shortDetails: map['short_details'] ?? '',
      followers: List.from(map['followers']).map((e) => intFromAny(e)).toList(),
      totalFollowers: intFromAny(map['total_followers']),
      link: map['link'] ?? '',
      whatsappNumber: map['whatsapp_number'],
      whatsappActive: map.parseBool('is_whatsapp_order_active') ?? false,
    );
  }

  final int rating;
  final String storeBanner;
  final int storeId;
  final String storeLogo;
  final String name;
  final String email;
  final String phone;
  final String createdAt;
  final String shortDetails;
  final int totalProducts;
  final int totalFollowers;
  final List<int> followers;
  final String link;
  final String? whatsappNumber;
  final bool whatsappActive;

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'name': name});
    result.addAll({'banner': storeBanner});
    result.addAll({'id': storeId});
    result.addAll({'logo': storeLogo});
    result.addAll({'rating': rating});
    result.addAll({'total_products': totalProducts});
    result.addAll({'email': email});
    result.addAll({'phone': phone});
    result.addAll({'created_at': createdAt});
    result.addAll({'short_details': shortDetails});
    result.addAll({'followers': List<dynamic>.from(followers)});
    result.addAll({'total_followers': totalFollowers});
    result.addAll({'link': link});
    result.addAll({'is_whatsapp_order_active': whatsappActive});
    result.addAll({'whatsapp_number': whatsappNumber});

    return result;
  }

  String toJson() => json.encode(toMap());
}
