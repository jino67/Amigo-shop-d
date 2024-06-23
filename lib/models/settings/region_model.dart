import 'dart:convert';

import 'package:e_com/core/extensions/helper_extension.dart';

class RegionModel {
  RegionModel({
    required this.langCode,
    required this.currencyUid,
  });

  static RegionModel nulled = RegionModel(langCode: 'en', currencyUid: null);

  final String? currencyUid;
  final String langCode;

  RegionModel copyWith({
    String? currencyUid,
    String? langCode,
  }) {
    return RegionModel(
      currencyUid: currencyUid ?? this.currencyUid,
      langCode: langCode ?? this.langCode,
    );
  }
}

class LocalCurrency {
  LocalCurrency({
    required this.langCode,
    required this.currency,
  });

  factory LocalCurrency.fromMap(Map<String, dynamic> map) {
    return LocalCurrency(
      currency: CurrencyData.fromMap(map['currency']),
      langCode: map['locale'],
    );
  }

  static LocalCurrency nulled = LocalCurrency(langCode: 'en', currency: null);

  final CurrencyData? currency;
  final String? langCode;
}

class Languages {
  Languages({required this.languagesData});

  factory Languages.fromJson(String source) =>
      Languages.fromMap(json.decode(source));

  factory Languages.fromMap(Map<String, dynamic> map) {
    return Languages(
      languagesData: List<LanguagesData>.from(
          map['data']?.map((x) => LanguagesData.fromMap(x)).toList()),
    );
  }

  final List<LanguagesData> languagesData;

  Map<String, dynamic> toMap() =>
      {'data': languagesData.map((x) => x.toMap()).toList()};

  String toJson() => json.encode(toMap());
}

class LanguagesData {
  LanguagesData({
    required this.name,
    required this.code,
    required this.image,
  });

  factory LanguagesData.fromJson(String source) =>
      LanguagesData.fromMap(json.decode(source));

  factory LanguagesData.fromMap(Map<String, dynamic> map) {
    return LanguagesData(
      name: map['name'] ?? '',
      code: map['code'] ?? '',
      image: map['image'] ?? '',
    );
  }

  final String code;
  final String image;
  final String name;

  Map<String, dynamic> toMap() => {
        'name': name,
        'code': code,
        'image': image,
      };

  String toJson() => json.encode(toMap());
}

class Currencies {
  Currencies({required this.currencyData});

  factory Currencies.fromJson(String source) =>
      Currencies.fromMap(json.decode(source));

  factory Currencies.fromMap(Map<String, dynamic> map) {
    return Currencies(
      currencyData: List<CurrencyData>.from(
          map['data']?.map((x) => CurrencyData.fromMap(x)).toList()),
    );
  }

  final List<CurrencyData> currencyData;
  Map<String, dynamic> toMap() => {
        'data': currencyData.map((x) => x.toMap()).toList(),
      };

  String toJson() => json.encode(toMap());
}

class CurrencyData {
  CurrencyData({
    required this.uid,
    required this.name,
    required this.symbol,
    required this.rate,
  });

  factory CurrencyData.fromJson(String source) =>
      CurrencyData.fromMap(json.decode(source));

  factory CurrencyData.fromMap(Map<String, dynamic> map) {
    return CurrencyData(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      symbol: map['symbol'] ?? '',
      rate: map['rate'] is String
          ? (map['rate'] as String).asDouble
          : map['rate'].toDouble(),
    );
  }

  final String name;
  final double rate;
  final String symbol;
  final String uid;

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'name': name,
        'symbol': symbol,
        'rate': rate,
      };

  String toJson() => json.encode(toMap());
}
