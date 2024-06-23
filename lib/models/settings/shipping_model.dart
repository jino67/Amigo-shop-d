import 'dart:convert';

import 'package:equatable/equatable.dart';

class ShippingMethods {
  ShippingMethods({
    required this.data,
  });

  factory ShippingMethods.fromMap(Map<String, dynamic> map) {
    return ShippingMethods(
      data: List<ShippingData>.from(
          map['data']?.map((x) => ShippingData.fromMap(x))),
    );
  }

  final List<ShippingData> data;

  Map<String, dynamic> toMap() {
    return {
      'data': data.map((x) => x.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap());
}

class ShippingData extends Equatable {
  const ShippingData({
    required this.description,
    required this.duration,
    required this.image,
    required this.methodName,
    required this.price,
    required this.uid,
  });

  factory ShippingData.fromJson(String source) =>
      ShippingData.fromMap(json.decode(source));

  factory ShippingData.fromMap(Map<String, dynamic> map) {
    return ShippingData(
      uid: map['uid'] ?? '',
      methodName: map['method_name'] ?? '',
      duration: map['duration'] ?? '',
      price: map['price'].toDouble(),
      description: map['description'] ?? '',
      image: map['image'],
    );
  }

  final String description;
  final String duration;
  final String image;
  final String methodName;
  final double price;
  final String uid;

  @override
  List<Object?> get props => [
        description,
        duration,
        image,
        methodName,
        price,
        uid,
      ];

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'method_name': methodName,
      'duration': duration,
      'price': price,
      'description': description,
      'image': image,
    };
  }

  String toJson() => json.encode(toMap());
}
