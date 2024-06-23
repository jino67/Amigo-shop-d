import 'package:e_com/core/core.dart';
import 'package:e_com/models/models.dart';
import 'package:flutter/material.dart';

enum OrderStatus {
  placed,
  confirmed,
  processing,
  shipped,
  delivered,
  cancel;

  const OrderStatus();

  factory OrderStatus.fromMap(String name) => values.byName(name.toLowerCase());
  factory OrderStatus.fromInt(int value) => switch (value) {
        1 => placed,
        2 => confirmed,
        3 => processing,
        4 => shipped,
        5 => delivered,
        6 => cancel,
        _ => cancel,
      };

  IconData get icon => switch (this) {
        placed => Icons.hourglass_bottom_rounded,
        confirmed => Icons.check_circle_rounded,
        processing => Icons.inventory_2_rounded,
        shipped => Icons.local_shipping_outlined,
        delivered => Icons.markunread_mailbox_outlined,
        cancel => Icons.cancel_rounded,
      };

  String get title => switch (this) {
        placed => 'Commande passée',
        confirmed => 'Commande confirmée',
        processing => 'En cours de finalisation',
        shipped => 'En cours de livraison',
        delivered => 'Livrée',
        cancel => 'Commande annulée',
      };
  int get ordered => switch (this) {
        placed => 1,
        confirmed => 2,
        processing => 3,
        shipped => 4,
        delivered => 5,
        cancel => 6,
      };

  static List<OrderStatus> get trackValues =>
      [placed, confirmed, processing, shipped, delivered];
  static List<OrderStatus> get cancelValues => [placed, cancel];

  bool get isFirst => placed == this;
  bool get isLast => delivered == this;
}

class OrderModel {
  OrderModel({
    required this.amount,
    required this.billingInformation,
    required this.discount,
    required this.orderDate,
    required this.orderDetails,
    required this.orderId,
    required this.paymentStatus,
    required this.paymentType,
    required this.quantity,
    required this.shippingCharge,
    required this.shippingMethod,
    required this.status,
    required this.uid,
    required this.statusLog,
    required this.paymentDetails,
    required this.totalPaid
  });

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      uid: map['uid'] ?? '',
      orderId: map['order_id'] ?? '',
      shippingCharge: map['shipping_charge']?.toDouble() ?? 0,
      discount: map['discount']?.toDouble() ?? 0,
      amount: map['amount']?.toDouble() ?? 0,
      paymentType: map['payment_type'],
      paymentStatus: map['payment_status'] ?? '',
      orderDetails: List<OrderDetails?>.from(
        map['order_details']['data']?.map(
          (x) {
            if (x['product'] == null) return null;
            return OrderDetails.fromMap(x);
          },
        ),
      ).removeNull(),
      billingInformation: map['billing_information'] != null &&
              map['billing_information'] is Map<String, dynamic>
          ? BillingInfo.fromMap(map['billing_information'])
          : null,
      paymentDetails: map['payment_details'] ?? {},
      quantity: map['quantity'] ?? 1,
      status: OrderStatus.fromMap(map['status']),
      orderDate: DateTime.parse(map['order_date']),
      shippingMethod: map['shipping_method'],
      totalPaid: map['total_paid'] ?? 0,
      statusLog: List<StatusLog>.from(
        map['status_log']?.map((x) => StatusLog.fromMap(x)),
      ),
    );
  }

  final double amount;
  final BillingInfo? billingInformation;
  final double discount;
  final DateTime orderDate;
  final List<OrderDetails> orderDetails;
  final String orderId;
  final String paymentStatus;
  final String? paymentType;
  final int? quantity;
  final double shippingCharge;
  final String? shippingMethod;
  final OrderStatus status;
  final List<StatusLog> statusLog;
  final String uid;
  final Map<String, dynamic> paymentDetails;
  final dynamic totalPaid;

  StatusLog? statusLogOf(OrderStatus status) {
    if (status == OrderStatus.placed) {
      return StatusLog(
        note: 'La commande a été passée avec succès',
        statusInt: 1,
        date: orderDate,
      );
    }
    if (statusLog.isEmpty) return null;

    if (!statusLog.map((e) => e.orderStatus).contains(status)) {
      if (status.ordered > this.status.ordered) return null;
      return null;
    }
    return statusLog.lastWhere((element) => element.orderStatus == status);
  }

  DateTime get statusDateNow {
    if (statusLog.isEmpty) return orderDate;
    final logs = statusLogOf(status);
    if (logs == null) return orderDate;
    return logs.date;
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'billing_information': billingInformation?.toMap(),
      'discount': discount,
      'order_date': orderDate.toIso8601String(),
      'order_details': {'data': orderDetails.map((x) => x.toMap()).toList()},
      'order_id': orderId,
      'payment_status': paymentStatus,
      'payment_type': paymentType,
      'quantity': quantity,
      'shipping_charge': shippingCharge,
      'shipping_method': shippingMethod,
      'status': status.name,
      'uid': uid,
      'status_log': statusLog.map((x) => x.toMap()).toList(),
      'payment_details': paymentDetails,
      'total_paid' : 0
    };
  }

  bool get isCOD => paymentType == 'Paiement à la livraison';
  bool get isPaid => paymentStatus == 'Payé';
}

class OrderDetails {
  OrderDetails({
    required this.uid,
    required this.product,
    required this.digitalProduct,
    required this.orderId,
    required this.quantity,
    required this.totalPrice,
    required this.attribute,
  });

  factory OrderDetails.fromMap(Map<String, dynamic> map) {
    final isRegular = !Map.from(map['product']).containsKey('attribute');

    return OrderDetails(
      uid: map['uid'] ?? '',
      product: isRegular ? ProductsData.fromMap(map['product']) : null,
      digitalProduct: isRegular ? null : DigitalProduct.fromMap(map['product']),
      orderId: intFromAny(map['order_id']),
      quantity: intFromAny(map['quantity']),
      totalPrice: intFromAny(map['total_price']),
      attribute: map['attribute'] ?? '',
    );
  }

  final String? attribute;
  final DigitalProduct? digitalProduct;
  final int orderId;
  final ProductsData? product;
  final int quantity;
  final int totalPrice;
  final String uid;

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'product': isRegular ? product?.toMap() : digitalProduct?.toMap(),
      'order_id': orderId,
      'quantity': quantity,
      'total_price': totalPrice,
      'attribute': attribute,
    };
  }

  bool get isRegular => product != null;
}

class BillingInfo {
  BillingInfo({
    required this.address,
    required this.city,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.state,
    required this.zip,
    required this.country,
  });

  factory BillingInfo.fromMap(Map<String, dynamic> map) {
    return BillingInfo(
      address: map['address'] ?? '',
      city: map['city'] ?? '',
      email: map['email'] ?? '',
      firstName: map['first_name'] ?? '',
      lastName: map['last_name'] ?? '',
      phone: map['phone'] ?? '',
      state: map['state'] ?? '',
      zip: map['zip'] ?? '',
      country: map['country'] ?? '',
    );
  }

  final String address;
  final String city;
  final String email;
  final String firstName;
  final String lastName;
  final String phone;
  final String state;
  final String zip;
  final String country;

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'city': city,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'state': state,
      'zip': zip,
      'country': country,
    };
  }

  String get fullName => '$firstName $lastName';
  String get fullAddress {
    List<String> full = [];
    if (address.isNotEmpty) full.add(address);
    if (city.isNotEmpty) full.add(city);
    if (state.isNotEmpty) full.add(state);
    if (zip.isNotEmpty) full.add(zip);
    if (country.isNotEmpty) full.add(country);
    return full.join(', ');
  }

  bool get isAddressEmpty =>
      address.isEmpty && city.isEmpty && state.isEmpty && zip.isEmpty;

  bool get isNamesEmpty => firstName.isEmpty && lastName.isEmpty;
}

class PaymentLog {
  PaymentLog({
    required this.method,
    required this.charge,
    required this.uid,
    required this.trx,
    required this.amount,
    required this.finalAmount,
    required this.exchangeRate,
    required this.payable,
  });

  factory PaymentLog.fromMap(Map<String, dynamic>? map) {
    if (map == null) return PaymentLog.codLog;
    return PaymentLog(
      method: PaymentData.fromMap(map['payment_method']),
      uid: map['uid'] ?? '',
      trx: map['trx_number'] ?? '',
      amount: intFromAny(map['amount']),
      finalAmount: doubleFromAny(map['final_amount']),
      charge: doubleFromAny(map['charge']),
      payable: doubleFromAny(map['payable']),
      exchangeRate: doubleFromAny(map['exchange_rate']),
    );
  }

  static final PaymentLog codLog = PaymentLog(
    method: PaymentData.codPayment,
    charge: 0,
    uid: 'cod',
    trx: 'cod',
    amount: 0,
    finalAmount: 0,
    exchangeRate: 0,
    payable: 0,
  );

  final int amount;
  final double charge;
  final double payable;
  final double finalAmount;
  final double exchangeRate;
  final PaymentData method;
  final String trx;
  final String uid;

  Map<String, dynamic> toMap() {
    return {
      'payment_method': method.toMap(),
      'uid': uid,
      'trx_number': trx,
      'amount': amount,
      'final_amount': finalAmount,
      'charge': charge,
      'payable': payable,
      'exchange_rate': exchangeRate
    };
  }
}

class StatusLog {
  StatusLog({
    required this.note,
    required this.statusInt,
    required this.date,
  });

  factory StatusLog.fromMap(Map<String, dynamic> map) {
    return StatusLog(
      note: map['delivery_note'] ?? '',
      statusInt: map['delivery_status'] ?? '',
      date: DateTime.parse(map['created_at']),
    );
  }

  final DateTime date;
  final String note;
  final int statusInt;

  OrderStatus get orderStatus => OrderStatus.fromInt(statusInt);

  Map<String, dynamic> toMap() {
    return {
      'delivery_note': note,
      'delivery_status': statusInt,
      'created_at': date.toIso8601String(),
    };
  }
}
