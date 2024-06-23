import 'dart:convert';

import 'package:e_com/core/core.dart';
import 'package:e_com/models/models.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

class SettingsModel {
  SettingsModel({
    required this.siteName,
    required this.siteLogo,
    required this.cashOnDelivery,
    required this.address,
    required this.copyrightText,
    required this.primaryColor,
    required this.secondaryColor,
    required this.fontColor,
    required this.email,
    required this.phone,
    required this.orderIdPrefix,
    required this.filterMinRange,
    required this.filterMaxRange,
    required this.googleOAuth,
    required this.facebookOAuth,
    required this.onBoarding,
    required this.guestCheckout,
    required this.phoneOTP,
    required this.emailOTP,
    required this.isPasswordEnabled,
    required this.digitalPayment,
    required this.offlinePayment,
    required this.currencyOnLeft,
    required this.minOrderAmount,
    required this.minOrderCheck,
    required this.whatsappConfig,
  });

  factory SettingsModel.fromJson(String source) =>
      SettingsModel.fromMap(json.decode(source));

  factory SettingsModel.fromMap(Map<String, dynamic> map) {
    return SettingsModel(
      siteName: map['site_name'] ?? '',
      siteLogo: map['site_logo'] ?? '',
      cashOnDelivery: map['cash_on_delevary'],
      guestCheckout: map['guest_checkout'] ?? false,
      address: map['address'] ?? '',
      copyrightText: map['copyright_text'] ?? '',
      primaryColor: ((map['primary_color'] ?? '') as String).toColorK(),
      fontColor: ((map['font_color'] ?? '') as String).toColorK(),
      secondaryColor: ((map['secondary_color'] ?? '') as String).toColorK(),
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      orderIdPrefix: map['order_id_prefix'] ?? '',
      filterMinRange: intFromAny(map['filter_min_range']),
      filterMaxRange: intFromAny(map['filter_max_range']),
      googleOAuth: GoogleOAuth.fromMap(map['google_oauth']),
      facebookOAuth: FacebookOAuth.fromMap(map['facebook_oauth']),
      onBoarding: List<OneBoardingData>.from(
          map['onboarding_pages'].map((x) => OneBoardingData.fromMap(x))),
      emailOTP: map['email_otp'] ?? false,
      phoneOTP: map['phone_otp'] ?? false,
      isPasswordEnabled: map['login_with_password'] ?? false,
      digitalPayment: map['digital_payment'] ?? false,
      offlinePayment: map['offline_payment'] ?? false,
      currencyOnLeft: map['currency_position_is_left'] ?? false,
      minOrderAmount: map.parseInt('minimum_order_amount'),
      minOrderCheck: map['minimum_order_amount_check'] ?? false,
      whatsappConfig: WhatsappConfig.fromMap(map),
    );
  }

  final String address;
  final bool cashOnDelivery;
  final String copyrightText;
  final String email;
  final bool emailOTP;
  final FacebookOAuth? facebookOAuth;
  final int filterMaxRange;
  final int filterMinRange;
  final Color? fontColor;
  final GoogleOAuth? googleOAuth;
  final bool guestCheckout;
  final bool isPasswordEnabled;
  final List<OneBoardingData> onBoarding;
  final String orderIdPrefix;
  final String phone;
  final bool phoneOTP;
  final Color? primaryColor;
  final Color? secondaryColor;
  final String siteLogo;
  final String siteName;
  final bool digitalPayment;
  final bool offlinePayment;
  final bool currencyOnLeft;
  final int minOrderAmount;
  final bool minOrderCheck;
  final WhatsappConfig whatsappConfig;

  RangeValues get filterRange =>
      RangeValues(filterMinRange.toDouble(), filterMaxRange.toDouble());

  Map<String, dynamic> toMap() => {
        'site_name': siteName,
        'site_logo': siteLogo,
        'guest_checkout': guestCheckout,
        'cash_on_delevary': cashOnDelivery,
        'address': address,
        'copyright_text': copyrightText,
        'primary_color': primaryColor?.hex,
        'secondary_color': secondaryColor?.hex,
        'font_color': fontColor?.hex,
        'email': email,
        'phone': phone,
        'order_id_prefix': orderIdPrefix,
        'filter_min_range': filterMinRange,
        'filter_max_range': filterMaxRange,
        'google_oauth': googleOAuth?.toMap(),
        'facebook_oauth': facebookOAuth?.toMap(),
        'onboarding_pages': onBoarding.map((x) => x.toMap()).toList(),
        'email_otp': emailOTP,
        'phone_otp': phoneOTP,
        'login_with_password': isPasswordEnabled,
        'digital_payment': digitalPayment,
        'offline_payment': offlinePayment,
        'currency_position_is_left': currencyOnLeft,
        'minimum_order_amount_check': minOrderCheck,
        'minimum_order_amount': minOrderAmount,
        ...whatsappConfig.toMap(),
      };

  String toJson() => json.encode(toMap());
}

class WhatsappConfig {
  final String phone;
  final bool enabled;
  final String messageRegular;
  final String messageDigital;

  WhatsappConfig({
    required this.phone,
    required this.enabled,
    required this.messageRegular,
    required this.messageDigital,
  });

  factory WhatsappConfig.fromMap(Map<String, dynamic> map) {
    return WhatsappConfig(
      phone: map['whatsapp_phone'] ?? '',
      enabled: map['whatsapp_order'] ?? false,
      messageRegular: map['wp_physical_order_message'] ?? '',
      messageDigital: map['wp_digital_order_message'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        'whatsapp_phone': phone,
        'whatsapp_order': enabled,
        'wp_physical_order_message': messageRegular,
        'wp_digital_order_message': messageDigital,
      };

  String messageBuilder(
    Either<ProductsData, DigitalProduct> product,
    String attribute,
    LocalCurrency local,
  ) {
    final msg = product.fold(
      (l) {
        final priceKey = l.variantPrices[attribute];
        final vPrice = VariantPrice.fromMap(priceKey);
        final price = vPrice.isDiscounted ? vPrice.discount : vPrice.price;

        return messageRegular
            .replaceAll('[product_name]', l.name)
            .replaceAll('[variant_name]', attribute)
            .replaceAll('[price]', price.fromLocal(local))
            .replaceAll('[link]', l.url);
      },
      (r) {
        return messageDigital
            .replaceAll('[product_name]', r.name)
            .replaceAll('[price]', r.price.fromLocal(local))
            .replaceAll('[link]', r.url);
      },
    );

    return msg;
  }
}
