import 'package:e_com/core/core.dart';
import 'package:e_com/models/models.dart';

class CheckoutModel {
  CheckoutModel({
    required this.couponCode,
    required this.payment,
    required this.shipping,
    required this.billingAddress,
    this.carts = const [],
    this.createAccount = false,
    this.inputs = const {},
  });

  static CheckoutModel empty = CheckoutModel(
    couponCode: '',
    payment: null,
    shipping: null,
    billingAddress: null,
  );

  final BillingAddress? billingAddress;
  final String couponCode;
  final bool createAccount;
  final PaymentData? payment;
  final ShippingData? shipping;
  final List<CartData> carts;
  final Map<String, dynamic> inputs;

  CheckoutModel copyWith({
    String? couponCode,
    PaymentData? payment,
    ShippingData? shippingUid,
    BillingAddress? billingAddress,
    List<CartData>? carts,
    bool? createAccount,
    Map<String, dynamic>? inputs,
  }) {
    return CheckoutModel(
      billingAddress: billingAddress ?? this.billingAddress,
      carts: carts ?? this.carts,
      couponCode: couponCode ?? this.couponCode,
      payment: payment ?? this.payment,
      shipping: shippingUid ?? shipping,
      createAccount: createAccount ?? this.createAccount,
      inputs: inputs ?? this.inputs,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    //* check if payment method is COD and pass the appropriate code
    final paymentCode = payment?.isCOD == true ? 0 : payment?.id;

    result.addAll({'address_key': billingAddress?.key});
    result.addAll({'payment_id': paymentCode});
    result.addAll({'shipping_method': shipping?.uid});
    result.addAll({'coupon_code': couponCode});
    result.addAll({
      'custom_input': {
        for (var key in inputs.keys) key: inputs[key],
      }.nonNull(),
    });

    return result;
  }

  Map<String, dynamic> toGuestMap() {
    final result = <String, dynamic>{};

    //* check if payment method is COD and pass the appropriate code
    final paymentCode = payment?.isCOD == true ? 0 : payment?.id;

    result.addAll({'first_name': billingAddress?.firstName});
    result.addAll({'last_name': billingAddress?.lastName});
    result.addAll({'address': billingAddress?.address});
    result.addAll({'email': billingAddress?.email});
    result.addAll({'phone': billingAddress?.phone});
    result.addAll({'city': billingAddress?.city});
    result.addAll({'state': billingAddress?.state});
    result.addAll({'zip': billingAddress?.zipCode});
    result.addAll({'payment_id': paymentCode});
    result.addAll({'country': billingAddress?.country});
    result.addAll({'shipping_method': shipping?.uid});
    if (createAccount) result.addAll({'create_account': 1});
    result.addAll(
      {
        'custom_input': {
          for (var key in inputs.keys) key: inputs[key],
        },
      },
    );
    result.addAll(
      {
        'items': [
          for (var item in carts)
            {
              'uid': item.product.uid,
              'qty': item.quantity,
              'price': item.product.isDiscounted
                  ? item.product.discountAmount
                  : item.product.price,
              'attribute': item.variant,
            }
        ],
      },
    );

    return result;
  }

  factory CheckoutModel.fromOrder(OrderModel order) {
    return CheckoutModel(
      billingAddress: BillingAddress.fromOrder(order),
      couponCode: '',
      payment: null,
      shipping: null,
    );
  }
}
