import 'dart:convert';

import 'package:e_com/core/core.dart';

class Banners {
  Banners({required this.bannersData});

  factory Banners.fromMap(Map<String, dynamic> map) {
    return Banners(
      bannersData: List<BannersData>.from(
          map['data']?.map((x) => BannersData.fromMap(x))),
    );
  }

  final List<BannersData> bannersData;

  Map<String, dynamic> toMap() {
    return {
      'data': bannersData.map((x) => x.toMap()).toList(),
    };
  }
}

class BannersData {
  BannersData({
    required this.uid,
    required this.serialId,
    required this.subHeading,
    required this.subHeading_2,
    required this.btnName,
    required this.btnUrl,
    required this.bgImage,
  });

  factory BannersData.fromJson(String source) =>
      BannersData.fromMap(json.decode(source));

  factory BannersData.fromMap(Map<String, dynamic> map) {
    return BannersData(
      uid: map['uid'] ?? '',
      serialId: intFromAny(map['serial_id']),
      subHeading: map['sub_heading'] ?? '',
      subHeading_2: map['sub_heading_2'] ?? '',
      btnName: map['btn_name'] ?? '',
      btnUrl: map['btn_url'] ?? '',
      bgImage: map['bg_image'] ?? '',
    );
  }

  final String bgImage;
  final String btnName;
  final String btnUrl;
  final int serialId;
  final String subHeading;
  final String subHeading_2;
  final String uid;

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'serial_id': serialId,
      'sub_heading': subHeading,
      'sub_heading_2': subHeading_2,
      'btn_name': btnName,
      'btn_url': btnUrl,
      'bg_image': bgImage,
    };
  }
}
