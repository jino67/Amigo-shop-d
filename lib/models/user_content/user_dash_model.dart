import 'dart:convert';

import 'package:e_com/models/base/item_list_with_page_data.dart';
import 'package:e_com/models/user_content/carts_model.dart';
import 'package:e_com/models/user_content/order_model.dart';
import 'package:e_com/models/user_content/user_profile_model.dart';
import 'package:e_com/models/user_content/wishlist_model.dart';

class UserDashModel {
  UserDashModel({
    required this.wishlists,
    required this.carts,
    required this.user,
    required this.orders,
    required this.digitalOrders,
  });

  factory UserDashModel.fromJson(String source) =>
      UserDashModel.fromMap(json.decode(source));

  factory UserDashModel.fromMap(Map<String, dynamic> map) {
    return UserDashModel(
      user: UserModel.fromMap(map['user']),
      wishlists: ItemListWithPageData.fromMap(
          map['wishlists'], (x) => WishlistData.fromMap(x)),
      carts: ItemListWithPageData.fromMap(
          map['carts'], (x) => CartData.fromMap(x)),
      orders: ItemListWithPageData.fromMap(
          map['orders'], (x) => OrderModel.fromMap(x)),
      digitalOrders: ItemListWithPageData.fromMap(
          map['digital_orders'], (x) => OrderModel.fromMap(x)),
    );
  }

  final ItemListWithPageData<CartData> carts;
  final ItemListWithPageData<OrderModel> digitalOrders;
  final ItemListWithPageData<OrderModel> orders;
  final UserModel user;
  final ItemListWithPageData<WishlistData> wishlists;

  Map<String, dynamic> toMap() => {
        'user': user.toMap(),
        'wishlists': wishlists.toMap((x) => x.toMap()),
        'carts': carts.toMap((x) => x.toMap()),
        'orders': orders.toMap((x) => x.toMap()),
        'digital_orders': digitalOrders.toMap((x) => x.toMap()),
      };

  String toJson() => json.encode(toMap());

  ({int paid, int unPaid}) get totalOrders => (
        paid: orders.listData.length,
        unPaid: orders.listData.where((e) => e.paymentStatus != 'Paid').length
      );

  ({int paid, int unPaid}) get totalDigitalOrders => (
        paid: digitalOrders.listData.length,
        unPaid: digitalOrders.listData
            .where((e) => e.paymentStatus != 'Paid')
            .length
      );

  List<String> get allOrderedProductsID {
    Set<String> allId = {};
    for (var order in orders.listData) {
      final ids = order.orderDetails.map((e) => e.product!.uid).toList();

      allId.addAll(ids);
    }
    return allId.toList();
  }

  UserDashModel updateOrderList(ItemListWithPageData<OrderModel> orders) {
    return UserDashModel(
      orders: orders,
      carts: carts,
      digitalOrders: digitalOrders,
      user: user,
      wishlists: wishlists,
    );
  }

  UserDashModel updateDigitalOrderList(
    ItemListWithPageData<OrderModel> digitalOrders,
  ) {
    return UserDashModel(
      carts: carts,
      digitalOrders: digitalOrders,
      orders: orders,
      user: user,
      wishlists: wishlists,
    );
  }

  UserDashModel updateCartList(ItemListWithPageData<CartData> carts) {
    return UserDashModel(
      carts: carts,
      digitalOrders: digitalOrders,
      orders: orders,
      user: user,
      wishlists: wishlists,
    );
  }

  UserDashModel updateWishList(ItemListWithPageData<WishlistData> wishlists) {
    return UserDashModel(
      carts: carts,
      digitalOrders: digitalOrders,
      orders: orders,
      user: user,
      wishlists: wishlists,
    );
  }
}
