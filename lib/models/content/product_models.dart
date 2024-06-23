import 'dart:convert';

import 'package:e_com/core/core.dart';
import 'package:e_com/models/models.dart';

class ProductsData {
  ProductsData({
    required this.uid,
    required this.name,
    required this.order,
    required this.brand,
    required this.category,
    required this.price,
    required this.discountAmount,
    required this.inStock,
    required this.shortDescription,
    required this.description,
    required this.maximumPurchaseQty,
    required this.minimumPurchaseQty,
    required this.rating,
    required this.featuredImage,
    required this.galleryImage,
    required this.shippingInfo,
    required this.variantNames,
    required this.variantPrices,
    required this.url,
    required this.store,
  });

  factory ProductsData.fromJson(String source) =>
      ProductsData.fromMap(json.decode(source));

  factory ProductsData.fromMap(Map<String, dynamic> map) {
    return ProductsData(
      brand: Map<String, String?>.from(map['brand']),
      category: Map<String, String?>.from(map['category']),
      description: map['description'] ?? '',
      discountAmount: map['discount_amount'] ?? 0,
      featuredImage: map['featured_image'] ?? '',
      galleryImage: List<String>.from(map['gallery_image']),
      inStock: map['in_stock'] ?? false,
      maximumPurchaseQty: intFromAny(map['maximum_purchase_qty']),
      minimumPurchaseQty: intFromAny(map['minimum_purchaseqty']),
      name: map['name'] ?? '',
      order: intFromAny(map['order']),
      price: numFromAny(map['price']),
      rating: Rating.fromMap(map['rating']),
      shippingInfo: List<ShippingData>.from(
          map['shipping_info']['data']?.map((x) => ShippingData.fromMap(x))),
      shortDescription: map['short_description'] ?? '',
      uid: map['uid'] ?? '',
      variantNames: Map<String, List>.from(map['varient']),
      variantPrices: Map<String, dynamic>.from(map['varient_price']),
      url: map['url'] ?? '',
      store: map['seller'] == null ? null : StoreModel.fromMap(map['seller']),
    );
  }

  final Map<String, String?> brand;
  final Map<String, String?> category;
  final String description;
  final num discountAmount;
  final String featuredImage;
  final List<String> galleryImage;
  final bool inStock;
  final int maximumPurchaseQty;
  final int minimumPurchaseQty;
  final String name;
  final int order;
  final num price;
  final Rating rating;
  final List<ShippingData> shippingInfo;
  final String shortDescription;
  final String uid;
  final String url;
  final Map<String, List> variantNames;
  final Map<String, dynamic> variantPrices;
  final StoreModel? store;

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'order': order,
      'brand': brand,
      'category': category,
      'price': price,
      'discount_amount': discountAmount,
      'in_stock': inStock,
      'short_description': shortDescription,
      'description': description,
      'maximum_purchase_qty': maximumPurchaseQty,
      'minimum_purchaseqty': minimumPurchaseQty,
      'rating': rating.toMap(),
      'featured_image': featuredImage,
      'gallery_image': galleryImage,
      'shipping_info': {'data': shippingInfo.map((e) => e.toMap()).toList()},
      'varient': variantNames,
      'varient_price': variantPrices,
      'url': url,
      'seller': store?.toMap(),
    };
  }

  String toJson() => json.encode(toMap());

  bool get isDiscounted => price != discountAmount;

  List<String> get variantTypes => variantNames.keys.toList();

  List<String> variantsByType(String type) =>
      variantNames[type]!.map((e) => e.toString()).toList();

  int get stockCount {
    int quantity = 0;
    variantPrices.forEach((key, value) {
      quantity += (value['qty'] as String?)?.asInt ?? 0;
    });
    return quantity;
  }

  bool get availableAny => stockCount > 0;
}

class VariantPrice {
  VariantPrice({
    required this.quantity,
    required this.price,
    required this.discount,
  });

  factory VariantPrice.fromMap(Map<String, dynamic> map) {
    return VariantPrice(
      quantity: intFromAny(map['qty']),
      price: numFromAny(map['price']),
      discount: numFromAny(map['discount']),
    );
  }

  final num discount;
  final num price;
  final int quantity;

  bool get isDiscounted => price != discount;
}

class Rating {
  Rating({
    required this.totalReview,
    required this.avgRating,
    required this.review,
  });

  factory Rating.fromJson(String source) => Rating.fromMap(json.decode(source));

  factory Rating.fromMap(Map<String, dynamic> map) {
    return Rating(
      totalReview: intFromAny(map['total_review']),
      avgRating: map['avg_rating']?.toDouble() ?? 0.0,
      review: map['review'].isEmpty
          ? []
          : List<Review>.from(map['review']?.map((x) => Review.fromMap(x))),
    );
  }

  final double avgRating;
  final List<Review> review;
  final int totalReview;

  Map<String, dynamic> toMap() {
    return {
      'total_review': totalReview,
      'avg_rating': avgRating,
      'review': review.map((e) => e.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap());
}

class Review {
  Review({
    required this.user,
    required this.profile,
    required this.rating,
    required this.review,
  });

  factory Review.fromJson(String source) => Review.fromMap(json.decode(source));

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      profile: map['profile'] ?? '',
      rating: intFromAny(map['rating']),
      review: map['review'] ?? '',
      user: map['user'] ?? '',
    );
  }

  final String profile;
  final int rating;
  final String review;
  final String user;

  Map<String, dynamic> toMap() {
    return {
      'user': user,
      'profile': profile,
      'rating': rating,
      'review': review,
    };
  }

  String toJson() => json.encode(toMap());
}

class ReviewPostData {
  ReviewPostData({
    required this.uid,
    required this.review,
    required this.rate,
  });

  final int rate;
  final String review;
  final String uid;

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'rate': rate});
    result.addAll({'review': review});
    result.addAll({'product_uid': uid});

    return result;
  }

  ReviewPostData copyWith({
    int? rate,
    String? review,
    String? uid,
  }) {
    return ReviewPostData(
      rate: rate ?? this.rate,
      review: review ?? this.review,
      uid: uid ?? this.uid,
    );
  }
}
