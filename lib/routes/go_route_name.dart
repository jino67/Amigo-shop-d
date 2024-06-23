import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RouteNames {
  const RouteNames._();
  static const RouteName onboard = RouteName('/onboarding');
  static const RouteName notAuthorize = RouteName('/not_authorize');
  static const RouteName login = RouteName('/login');
  static const RouteName register = RouteName('register');
  static const RouteName splash = RouteName('/splash');
  static const RouteName error = RouteName('/oops');
  static const RouteName notFound = RouteName('/404');
  static const RouteName noInternet = RouteName('/no_internet');
  static const RouteName maintenance = RouteName('/maintenance');
  static const RouteName invalidPurchase = RouteName('/invalid_purchase');

  static const RouteName home = RouteName('/home');
  static const RouteName wishlist = RouteName('/wishlist');
  static const RouteName campaigns = RouteName('/campaigns');
  static const RouteName carts = RouteName('/carts');
  static const RouteName photoView = RouteName('/photo-view');

  /// query param 'status' : 's' or 'f'
  /// query param 'method' : any
  static const RouteName afterPayment = RouteName('/after-payment');

  // subRoute of home
  static const RouteName userProfile = RouteName('user_view');
  static const RouteName userEditing = RouteName('user_profile_edit');
  static const RouteName changePassword = RouteName('change-password');
  static const RouteName categories = RouteName('categories');
  static const RouteName store = RouteName('store/:id');
  static const RouteName allStore = RouteName('all-store');
  static const RouteName test = RouteName('test');
  static const RouteName address = RouteName('address');
  static const RouteName addAddress = RouteName('add-address');
  static const RouteName editAddress = RouteName('edit-address');

  /// Pass {'id':category.id}
  static const RouteName categoryProducts = RouteName('cat/:id');

  static const RouteName brands = RouteName('brands');

  /// Pass {'id':brand.id}
  static const RouteName brandProducts = RouteName('b/:id');

  static const RouteName notifications = RouteName('notification');
  static const RouteName orders = RouteName('orders');

  // subRoute of home
  /// Pass {'id':order.id} as query
  static const RouteName orderDetails = RouteName('order-details');
  static const RouteName trackOrder = RouteName('track-order');

  /// Pass {'id':order.id}
  // static const RouteName orderDetails = RouteName('o/:id');

  // static const RouteName search = RouteName('searched');
  static const RouteName productsView = RouteName('products');
  static const RouteName allProductsView = RouteName('all-products');

  /// Must pass {'id':product.id} path parameter
  ///
  /// Must pass {'isRegular':product or digital} query param
  ///
  /// pass {'cat':category.id} query param
  ///
  /// pass {'brand':brand.id} query param
  ///
  /// pass {'type':deal|new|best|digital} query param
  static const RouteName productDetails = RouteName('p/:id');

  static const RouteName settings = RouteName('settings');
  // subRoute of settings
  static const RouteName region = RouteName('region');

  static const RouteName contactUs = RouteName('contact-us');
  static const RouteName supportTicket = RouteName('support_ticket');
  static const RouteName createTicket = RouteName('create_ticket');

  /// Pass {'id':ticket.id}
  static const RouteName ticketDetails = RouteName('ticket_details/:id');

  /// Pass {'pageId':page.id}
  static const RouteName extraPage = RouteName('extra/:pageId');

  // subRoute of campaigns
  /// Pass {'pageId':campaign.id}
  static const RouteName campaignDetails = RouteName('camp/:id');
  static const RouteName flashDeals = RouteName('flash-deals');

  // subRoute of cart
  static const RouteName shippingDetails = RouteName('shipping_details');
  // subRoute of shippingDetails
  static const RouteName checkoutPayment = RouteName('shipping_payment');
  static const RouteName checkoutSummary = RouteName('checkout-summary');
  static const RouteName orderPlaced = RouteName('order_placed');

  static const RouteName bkashPayment = RouteName('payment/bkash');
  static const RouteName paypalPayment = RouteName('payment/paypal');
  static const RouteName instaMojoPayment = RouteName('payment/instamojo');
  static const RouteName paystackPayment = RouteName('payment/paystack');
  static const RouteName sslCommerzPayment = RouteName('payment/sslcommerz');
  static const RouteName nagadPayment = RouteName('payment/nagad');
  static const RouteName flutterWavePayment = RouteName('payment/flutterwave');
  static const RouteName stripePayment = RouteName('payment/stripe');

  static const List<RouteName> nestedRoutes = [
    home,
    wishlist,
    campaigns,
    carts
  ];
}

class RouteName {
  const RouteName(this.path, {String? name}) : _name = name;

  final String path;
  final String? _name;

  RouteName addQuery(Map<String, String> query) {
    final encoded = {
      for (final q in query.entries) q.key: Uri.encodeComponent(q.value)
    };

    final pathWithQuery = Uri(path: path, queryParameters: encoded).toString();
    return RouteName(pathWithQuery, name: _name);
  }

  String get name => _name ?? path.replaceFirst('/', '').replaceAll('/', '_');

  Future<T?> push<T extends Object?>(BuildContext context, {Object? extra}) =>
      context.push(path, extra: extra);

  Future<T?> pushNamed<T extends Object?>(
    BuildContext context, {
    Map<String, String> pathParams = const <String, String>{},
    Map<String, String> query = const <String, String>{},
    Object? extra,
  }) {
    return context.pushNamed(
      name,
      extra: extra,
      pathParameters: pathParams,
      queryParameters: query,
    );
  }

  void go(BuildContext context, {Object? extra}) =>
      context.go(path, extra: extra);

  void goNamed(
    BuildContext context, {
    Map<String, String> pathParams = const <String, String>{},
    Map<String, String> query = const <String, String>{},
    Object? extra,
  }) =>
      context.goNamed(
        name,
        pathParameters: pathParams,
        queryParameters: query,
        extra: extra,
      );
}
