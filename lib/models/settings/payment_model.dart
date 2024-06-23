import 'dart:convert';

import 'package:e_com/core/core.dart';
import 'package:flutter/material.dart';

import 'region_model.dart';

enum PaymentMethod {
  stripe,
  paypal,
  payStack,
  flutterWave,
  razorPay,
  instaMojo,
  bkash,
  nagad;

  const PaymentMethod();

  static PaymentMethod? fromName(String? name) => switch (name) {
        'Stripe' => stripe,
        'Paypal' => paypal,
        'Paystack' => payStack,
        'Flutterwave' => flutterWave,
        'Razorpay' => razorPay,
        'Nagad' => nagad,
        'Paiement mobile' => flutterWave,
        'Par tranche' => flutterWave,
        _ => null,
      };
}

class PaymentData {
  PaymentData({
    required this.percentCharge,
    required this.currency,
    required this.rate,
    required this.name,
    required this.uniqueCode,
    required this.paymentParameter,
    required this.image,
    required this.callbackUrl,
    required this.id,
    required this.isManual,
    required this.manualInputs,
  });

  factory PaymentData.fromMap(Map<String, dynamic> map) {
    return PaymentData(
      id: map.parseInt('id'),
      percentCharge: (map['percent_charge'] as String).asDouble,
      currency: CurrencyData.fromMap(map['currency']),
      rate: map['rate'] ?? '',
      name: map['name'] ?? '',
      uniqueCode: map['unique_code'],
      image: map['image'] ?? '',
      callbackUrl: map['callback_url'] ?? '',
      isManual: map['is_manual'] ?? false,
      paymentParameter: map['payment_parameter'] is Map<String, dynamic>
          ? Map<String, dynamic>.from(map['payment_parameter'])
          : {},
      manualInputs: map['payment_parameter'] is List
          ? List<CustomInput>.from(
              map['payment_parameter']?.map((x) => CustomInput.fromMap(x)) ??
                  [],
            )
          : [],
    );
  }

  static PaymentData codPayment = PaymentData(
    percentCharge: 0,
    currency: CurrencyData(uid: '', name: '', symbol: '', rate: 0),
    rate: '',
    name: 'Cash on Delivery',
    uniqueCode: '-1',
    paymentParameter: {},
    image: Assets.logo.cod.path,
    callbackUrl: '',
    id: 0,
    isManual: false,
    manualInputs: [],
  );

  final String callbackUrl;
  final CurrencyData currency;
  final int id;
  final String image;
  final bool isManual;
  final List<CustomInput> manualInputs;
  final String name;
  final Map<String, dynamic> paymentParameter;
  final double percentCharge;
  final String rate;
  final String? uniqueCode;

  List<String> get inputKeys => manualInputs.map((e) => e.name).toList();

  Map<String, dynamic> toMap() => {
        'percent_charge': percentCharge.toString(),
        'currency': currency.toMap(),
        'rate': rate,
        'name': name,
        'unique_code': uniqueCode,
        'payment_parameter': paymentParameter.isNotEmpty
            ? paymentParameter
            : manualInputs.map((e) => e.toMap()).toList(),
        'image': image,
        'callback_url': callbackUrl,
        'id': id,
        'is_manual': isManual,
      };

  String toJson() => json.encode(toMap());

  bool get isCOD => uniqueCode == '-1';
}

class CustomInput {
  CustomInput({
    required this.name,
    required this.isRequired,
    required this.type,
    this.value,
  });

  factory CustomInput.fromMap(Map<String, dynamic> map) {
    return CustomInput(
      isRequired: map['is_required'] ?? false,
      type: map['type'] ?? '',
      name: map['name'] ?? '',
    );
  }

  CustomInput setValue(String value) => CustomInput(
        isRequired: isRequired,
        type: type,
        name: name,
        value: value,
      );

  final bool isRequired;
  final String name;
  final String type;
  final String? value;

  bool get isTextArea => type == 'textarea';
  TextInputType get keyboardType =>
      isTextArea ? TextInputType.multiline : TextInputType.text;
  TextInputAction get textInputAction =>
      isTextArea ? TextInputAction.newline : TextInputAction.next;

  Map<String, dynamic> toMap() {
    return {
      'is_required': isRequired,
      'type': type,
      'name': name,
    };
  }
}
