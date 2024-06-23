import 'dart:io';

import 'package:e_com/core/core.dart';
import 'package:e_com/models/models.dart';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  const UserModel({
    required this.address,
    required this.email,
    required this.image,
    required this.name,
    required this.phone,
    required this.uid,
    required this.username,
    this.imageFile,
    required this.id,
    required this.billingAddress,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      address: AddressModel.fromMap(map['address']),
      email: map['email'] ?? '',
      image: map['image'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      uid: map['uid'] ?? '',
      username: map['username'] ?? '',
      id: intFromAny(map['id']),
      billingAddress: List<BillingAddress>.from(
        (map['billing_address'] as Map<String, dynamic>?)?.entries.map(
                  (e) => BillingAddress.fromMap(
                    {'address_name': e.key, ...e.value},
                  ),
                ) ??
            [],
      ),
    );
  }
  factory UserModel.fromFlatMap(Map<String, dynamic> map) {
    return UserModel(
      address: AddressModel(
        address: map['address'] ?? '',
        city: map['city'] ?? '',
        state: map['state'] ?? '',
        zip: map['zip'] ?? '',
      ),
      email: map['email'] ?? '',
      image: '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      uid: '',
      username: '',
      id: 0,
      billingAddress: const [],
    );
  }

  static UserModel empty = UserModel(
    address: AddressModel.empty,
    email: '',
    image: '',
    name: '',
    phone: '',
    uid: '',
    username: '',
    id: 0,
    billingAddress: const [],
  );

  final AddressModel address;
  final List<BillingAddress> billingAddress;
  final String email;
  final int id;
  final String image;
  final File? imageFile;
  final String name;
  final String phone;
  final String uid;
  final String username;

  @override
  List<Object> get props {
    return [address, email, image, name, phone, uid, username, id];
  }

  @override
  bool get stringify => true;

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'address': address.toMap()});
    result.addAll({'email': email});
    result.addAll({'image': image});
    result.addAll({'name': name});
    result.addAll({'phone': phone});
    result.addAll({'uid': uid});
    result.addAll({'username': username});
    result.addAll({'id': id});
    result.addAll({
      'billing_address': {
        for (final address in billingAddress) address.key: address.toMap(),
      }
    });

    return result;
  }

  UserModel setAddress({
    String? address,
    String? city,
    String? state,
    String? zip,
  }) {
    return copyWith(
      address: this
          .address
          .copyWith(address: address, city: city, state: state, zip: zip),
    );
  }

  //* modified to match the body of the post request
  //! The [File] image field is missing. It is added in the post method directly
  Map<String, dynamic> toPostMap() {
    final result = <String, dynamic>{};

    result.addAll({'name': name});
    result.addAll({'username': name});
    result.addAll({'phone': phone});
    result.addAll({'address': address.address});
    result.addAll({'zip': address.zip});
    result.addAll({'state': address.state});
    result.addAll({'city': address.city});

    return result;
  }

  UserModel copyWith({
    AddressModel? address,
    String? email,
    String? image,
    String? name,
    String? phone,
    String? uid,
    String? username,
    File? Function()? imageFile,
    int? id,
    List<BillingAddress>? billingAddress,
  }) {
    return UserModel(
      address: address ?? this.address,
      email: email ?? this.email,
      image: image ?? this.image,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      uid: uid ?? this.uid,
      username: username ?? this.username,
      imageFile: imageFile != null ? imageFile() : this.imageFile,
      id: id ?? this.id,
      billingAddress: billingAddress ?? this.billingAddress,
    );
  }
}

class AddressModel extends Equatable {
  const AddressModel({
    required this.address,
    required this.city,
    required this.state,
    required this.zip,
  });

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      address: map['address'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      zip: map['zip'] ?? '',
    );
  }

  static AddressModel empty =
      const AddressModel(address: '', city: '', state: '', zip: '');

  final String address;
  final String city;
  final String state;
  final String zip;

  @override
  List<Object> get props => [address, city, state, zip];

  @override
  bool get stringify => true;

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'address': address});
    result.addAll({'city': city});
    result.addAll({'state': state});
    result.addAll({'zip': zip});

    return result;
  }

  AddressModel copyWith({
    String? address,
    String? city,
    String? state,
    String? zip,
  }) {
    return AddressModel(
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      zip: zip ?? this.zip,
    );
  }
}
