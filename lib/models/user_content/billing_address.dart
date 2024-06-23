import 'package:e_com/models/models.dart';

class BillingAddress {
  BillingAddress({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.city,
    required this.state,
    required this.address,
    required this.zipCode,
    required this.country,
    required this.key,
    this.oldKey,
  });

  factory BillingAddress.fromMap(Map<String, dynamic> map) {
    return BillingAddress(
      address: map['address'] ?? '',
      city: map['city'] ?? '',
      email: map['email'] ?? '',
      firstName: map['first_name'] ?? '',
      lastName: map['last_name'] ?? '',
      phone: map['phone'] ?? '',
      state: map['state'] ?? '',
      zipCode: map['zip'] ?? '',
      key: map['address_name'] ?? '',
      country: map['country'] ?? '',
    );
  }

  factory BillingAddress.fromOrder(OrderModel order) {
    return BillingAddress(
      city: order.billingInformation!.city,
      email: order.billingInformation!.email,
      phone: order.billingInformation!.phone,
      state: order.billingInformation!.state,
      zipCode: order.billingInformation!.zip,
      firstName: order.billingInformation!.firstName,
      lastName: order.billingInformation!.lastName,
      address: order.billingInformation!.address,
      country: '', // TODO: add country,
      key: '',
    );
  }

  static BillingAddress empty = BillingAddress(
    firstName: '',
    address: '',
    city: '',
    lastName: '',
    email: '',
    phone: '',
    state: '',
    country: '',
    zipCode: '',
    key: '',
  );

  final String address;
  final String city;
  final String email;
  final String firstName;

  /// The unique key of the billing address.
  final String key;

  /// The key of the billing address thats to be updated.
  final String? oldKey;

  final String lastName;
  final String phone;
  final String state;
  final String zipCode;
  final String country;

  String get fullName => '$firstName $lastName';

  String get fullAddress => '$address, $state, $city ($zipCode), $country';

  BillingAddress copyWith({
    String? address,
    String? city,
    String? email,
    String? firstName,
    String? lastName,
    String? phone,
    String? state,
    String? zipCode,
    String? key,
    String? country,
  }) {
    return BillingAddress(
      address: address ?? this.address,
      city: city ?? this.city,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      key: key ?? this.key,
      country: country ?? this.country,
    );
  }

  BillingAddress setOldKey(String oldKey) {
    return BillingAddress(
      address: address,
      city: city,
      email: email,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      state: state,
      zipCode: zipCode,
      key: key,
      country: country,
      oldKey: oldKey,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'city': city,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'state': state,
      'zip': zipCode,
      'address_name': key,
      'country': country,
      if (oldKey != null) 'address_key': oldKey
    };
  }
}
