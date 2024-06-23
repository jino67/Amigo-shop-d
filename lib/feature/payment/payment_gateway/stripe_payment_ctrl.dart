// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:e_com/core/core.dart';
import 'package:e_com/feature/check_out/providers/provider.dart';
import 'package:e_com/feature/payment/repository/payment_repo.dart';
import 'package:e_com/models/models.dart';
import 'package:e_com/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final stripePaymentCtrlProvider =
    NotifierProviderFamily<StripePaymentCtrlNotifier, String, PaymentData>(
        StripePaymentCtrlNotifier.new);

class StripePaymentCtrlNotifier extends FamilyNotifier<String, PaymentData> {
  @override
  String build(PaymentData arg) {
    return '';
  }

  Dio get _dio => Dio()..interceptors.add(talk.dioLogger);

  String callbackUrl() => 'https://stripecallback.com/stripe/payment/callback';

  StripeParam get _cred => StripeParam.fromMap(arg.paymentParameter);

  /// Start Stripe payment Process
  Future<void> initializePayment(context) async {
    RouteNames.stripePayment.goNamed(context);
  }

  Future<void> initializePaymentWEB(BuildContext context) async {
    try {
      Toaster.showLoading('Redirecting to Stripe...');

      final customer = await _createCustomer();
      final session = await _createSession(customer['id']);

      state = session['id'];
      Logger(state, 'session id');

      Toaster.remove();
      RouteNames.stripePayment.goNamed(context, extra: session['url']);
    } on DioException catch (e) {
      Toaster.showError(e.response?.data['message']);
    }
  }

  // creates payment intent from stripe API
  Future<Map<String, dynamic>> _createCustomer() async {
    const api = 'https://api.stripe.com/v1/customers';
    final order = _order!.order;

    final body = {
      'name': order.billingInformation?.fullName,
      'email': order.billingInformation?.email,
      'phone': order.billingInformation?.phone,
      'shipping': {
        'name': order.billingInformation?.fullName,
        'address': {
          'line1': order.billingInformation?.address,
          'city': order.billingInformation?.city,
          'postal_code': order.billingInformation?.zip,
          'state': order.billingInformation?.state,
          'country': order.billingInformation?.country,
        },
      },
    };

    final option = Options(
      headers: {
        'Authorization': 'Bearer ${_cred.secretKey}',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );

    final response = await _dio.post(api, data: body, options: option);

    return response.data;
  }

  int get _finalAmount => _order!.paymentLog.finalAmount.round();

  Future<Map<String, dynamic>> _createSession(customerID) async {
    final currencyCode = arg.currency.name;
    const api = 'https://api.stripe.com/v1/checkout/sessions';

    final body = {
      'mode': 'payment',
      'customer': customerID,
      'success_url': '${callbackUrl()}?type=success',
      'cancel_url': '${callbackUrl()}?type=failed',
      'line_items': [
        {
          'quantity': 1,
          'price_data': {
            'currency': currencyCode.toLowerCase(),
            'unit_amount': (_finalAmount * 100).toInt(),
            'product_data': {'name': _order!.order.orderId},
          },
        }
      ],
    };

    final option = Options(
      headers: {
        'Authorization': 'Bearer ${_cred.secretKey}',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );

    final response = await _dio.post(api, data: body, options: option);

    Logger.json(response.data, 'SESSION');

    return response.data;
  }

  Future<void> executePayment(BuildContext context, Uri? url) async {
    Logger(url, 'url');

    final type = url!.queryParameters['type'];

    final body = {'payment_id': state};

    final trx = _order!.paymentLog.trx;
    final callbackUrl = '${arg.callbackUrl}/$trx/$type';

    Logger.json(body);

    await PaymentRepo().confirmPayment(context, body, callbackUrl);
  }

  OrderBaseModel? get _order => ref.read(checkoutStateProvider);
}
