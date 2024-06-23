import 'dart:async';
import 'dart:io';

import 'package:e_com/core/core.dart';
import 'package:e_com/feature/address/view/add_address.dart';
import 'package:e_com/feature/auth/controller/auth_ctrl.dart';
import 'package:e_com/feature/auth/view/login_page.dart';
import 'package:e_com/feature/auth/view/registration_page.dart';
import 'package:e_com/feature/brands/view/brand_products.dart';
import 'package:e_com/feature/brands/view/brand_view.dart';
import 'package:e_com/feature/campaign/view/campaign_details_view.dart';
import 'package:e_com/feature/campaign/view/campaigns_view.dart';
import 'package:e_com/feature/cart/view/carts_view.dart';
import 'package:e_com/feature/categories/view/categories_products_view.dart';
import 'package:e_com/feature/categories/view/categories_view.dart';
import 'package:e_com/feature/check_out/view/checkout_payment_view.dart';
import 'package:e_com/feature/check_out/view/checkout_shipping_view.dart';
import 'package:e_com/feature/check_out/view/checkout_summery.dart';
import 'package:e_com/feature/check_out/view/order_placed_page.dart';
import 'package:e_com/feature/flash_deals/view/flash_details.dart';
import 'package:e_com/feature/help/view/contact_us_view.dart';
import 'package:e_com/feature/home/view/home_page.dart';
import 'package:e_com/feature/on_board/view/on_board_page.dart';
import 'package:e_com/feature/orders/view/order_details.dart';
import 'package:e_com/feature/orders/view/order_list_view.dart';
import 'package:e_com/feature/orders/view/track_order_view.dart';
import 'package:e_com/feature/payment/view/after_payment_page.dart';
import 'package:e_com/feature/payment/view/payment_pages/payment_pages.dart';
import 'package:e_com/feature/products/view/product_details_view.dart';
import 'package:e_com/feature/products/view/product_view.dart';
import 'package:e_com/feature/region_settings/view/region_view.dart';
import 'package:e_com/feature/settings/provider/settings_provider.dart';
import 'package:e_com/feature/settings/view/extra_page_view.dart';
import 'package:e_com/feature/settings/view/settings_view.dart';
import 'package:e_com/feature/store/view/all_store.dart';
import 'package:e_com/feature/store/view/store_view.dart';
import 'package:e_com/feature/support_ticket/view/create_ticket_view.dart';
import 'package:e_com/feature/support_ticket/view/support_ticket_list_view.dart';
import 'package:e_com/feature/support_ticket/view/ticket_details_view.dart';
import 'package:e_com/feature/user_profile/view/local/password_change_view.dart';
import 'package:e_com/feature/user_profile/view/user_profile_editing_view.dart';
import 'package:e_com/feature/wishlist/view/wishlist_view.dart';
import 'package:e_com/models/models.dart';
import 'package:e_com/navigation/navigation_root.dart';
import 'package:e_com/routes/routes.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../feature/address/view/address_view.dart';
import '../feature/user_profile/view/user_profile_view.dart';

final routeListProvider = Provider.family
    .autoDispose<List<RouteBase>, GlobalKey<NavigatorState>>((ref, rootKey) {
  final GlobalKey<NavigatorState> shellNavigator =
      GlobalKey(debugLabel: 'shell');

  final isLoggedIn = ref.watch(authCtrlProvider);
  final canGuestCheckOut = ref.watch(
      settingsProvider.select((v) => v?.settings.guestCheckout ?? false));
  FutureOr<String?> authRedirect(BuildContext context, GoRouterState state) {
    final current = state.uri.toString();
    if (current.contains(RouteNames.login.path)) {
      Logger('Going to Login page', 'auth redirect');
      return null;
    }

    if (!isLoggedIn) {
      Logger('Not logged in', 'auth redirect');
      return RouteNames.notAuthorize.path;
    }

    return null;
  }

  final routeList = [
    GoRoute(
      path: RouteNames.splash.path,
      name: RouteNames.splash.name,
      pageBuilder: (context, state) => NoTransitionPage(
        name: state.name,
        key: state.pageKey,
        child: const SplashView(),
      ),
    ),
    GoRoute(
      path: RouteNames.onboard.path,
      name: RouteNames.onboard.name,
      pageBuilder: (context, state) => AnimatePageRoute(
        name: state.name,
        key: state.pageKey,
        child: (animation) => const OnBoardPage(),
      ),
    ),
    GoRoute(
      path: RouteNames.notAuthorize.path,
      name: RouteNames.notAuthorize.name,
      pageBuilder: (context, state) => AnimatePageRoute(
        name: state.name,
        key: state.pageKey,
        child: (animation) => const NotAuthorizedPage(),
      ),
    ),
    GoRoute(
      path: RouteNames.noInternet.path,
      name: RouteNames.noInternet.name,
      pageBuilder: (context, state) => NoTransitionPage(
        key: state.pageKey,
        name: state.name,
        child: const NoInternetPage(),
      ),
    ),
    GoRoute(
      path: RouteNames.maintenance.path,
      name: RouteNames.maintenance.name,
      pageBuilder: (context, state) => NoTransitionPage(
        name: state.name,
        key: state.pageKey,
        child: const MaintenancePage(),
      ),
    ),
    GoRoute(
      path: RouteNames.invalidPurchase.path,
      name: RouteNames.invalidPurchase.name,
      pageBuilder: (context, state) => NoTransitionPage(
        name: state.name,
        key: state.pageKey,
        child: const InvalidPurchasePage(),
      ),
    ),
    GoRoute(
      path: RouteNames.login.path,
      name: RouteNames.login.name,
      pageBuilder: (context, state) => AnimatePageRoute(
        name: state.name,
        key: state.pageKey,
        child: (animation) => const LoginPage(),
      ),
      routes: [
        GoRoute(
          path: RouteNames.register.path,
          name: RouteNames.register.name,
          pageBuilder: (context, state) => AnimatePageRoute(
            name: state.name,
            key: state.pageKey,
            child: (animation) => const RegistrationPage(),
          ),
        ),
      ],
    ),
    GoRoute(
      path: RouteNames.error.path,
      name: RouteNames.error.name,
      pageBuilder: (context, state) => AnimatePageRoute(
        name: state.name,
        key: state.pageKey,
        child: (animation) => ErrorRoutePage(
          error: state.uri.queryParameters['error'],
        ),
      ),
    ),
    GoRoute(
      path: RouteNames.notFound.path,
      name: RouteNames.notFound.name,
      pageBuilder: (context, state) => AnimatePageRoute(
        name: state.name,
        key: state.pageKey,
        child: (animation) => NotFoundPage(path: state.fullPath),
      ),
    ),
    GoRoute(
      path: RouteNames.afterPayment.path,
      name: RouteNames.afterPayment.name,
      pageBuilder: (context, state) {
        final status = state.uri.queryParameters['status'];
        return AnimatePageRoute(
          name: state.name,
          key: state.pageKey,
          child: (animation) => AfterPaymentView(status),
        );
      },
    ),
    GoRoute(
      path: RouteNames.photoView.path,
      name: RouteNames.photoView.name,
      parentNavigatorKey: rootKey,
      pageBuilder: (context, state) => AnimatePageRoute(
        name: state.name,
        key: state.pageKey,
        fullscreen: true,
        child: (animation) {
          final extra = state.extra;
          if (extra is File) {
            return PhotoView.file(extra);
          }
          if (extra is String) {
            return extra.startsWith('assets')
                ? PhotoView.asset(extra)
                : PhotoView.network(extra);
          }
          return const ErrorView(error: 'Invalid Image');
        },
      ),
    ),
    ShellRoute(
      navigatorKey: shellNavigator,
      builder: (context, state, child) =>
          NavigationRoot(child, key: state.pageKey),
      routes: [
        //! Home section
        GoRoute(
          path: RouteNames.home.path,
          name: RouteNames.home.name,
          pageBuilder: (context, state) => NoTransitionPage(
            name: state.name,
            key: state.pageKey,
            child: const HomePage(),
          ),
          routes: [
            GoRoute(
              parentNavigatorKey: rootKey,
              path: RouteNames.userProfile.path,
              name: RouteNames.userProfile.name,
              redirect: authRedirect,
              pageBuilder: (context, state) => AnimatePageRoute(
                name: state.name,
                key: state.pageKey,
                child: (animation) => const UserProfileView(),
              ),
              routes: [
                GoRoute(
                  parentNavigatorKey: rootKey,
                  path: RouteNames.userEditing.path,
                  name: RouteNames.userEditing.name,
                  pageBuilder: (context, state) => AnimatePageRoute(
                    name: state.name,
                    key: state.pageKey,
                    child: (animation) => const UserProfileEditingView(),
                  ),
                ),
                GoRoute(
                  parentNavigatorKey: rootKey,
                  path: RouteNames.changePassword.path,
                  name: RouteNames.changePassword.name,
                  pageBuilder: (context, state) => AnimatePageRoute(
                    name: state.name,
                    key: state.pageKey,
                    child: (animation) => const PasswordChangeView(),
                  ),
                ),
              ],
            ),
            GoRoute(
              parentNavigatorKey: rootKey,
              path: RouteNames.flashDeals.path,
              name: RouteNames.flashDeals.name,
              pageBuilder: (context, state) => AnimatePageRoute(
                name: state.name,
                key: state.pageKey,
                child: (animation) => const FlashDetailsView(),
              ),
            ),
            GoRoute(
              parentNavigatorKey: rootKey,
              path: RouteNames.allStore.path,
              name: RouteNames.allStore.name,
              pageBuilder: (context, state) => AnimatePageRoute(
                name: state.name,
                key: state.pageKey,
                child: (animation) => const AllStoreView(),
              ),
              routes: [
                GoRoute(
                  parentNavigatorKey: rootKey,
                  path: RouteNames.store.path,
                  name: RouteNames.store.name,
                  pageBuilder: (context, state) => AnimatePageRoute(
                    name: state.name,
                    key: state.pageKey,
                    child: (animation) =>
                        StoreView(state.pathParameters['id']!),
                  ),
                ),
              ],
            ),
            GoRoute(
              parentNavigatorKey: rootKey,
              path: RouteNames.productsView.path,
              name: RouteNames.productsView.name,
              pageBuilder: (context, state) => AnimatePageRoute(
                name: state.name,
                key: state.pageKey,
                child: (animation) => const ProductView(),
              ),
              routes: [
                GoRoute(
                  parentNavigatorKey: rootKey,
                  path: RouteNames.productDetails.path,
                  name: RouteNames.productDetails.name,
                  pageBuilder: (context, state) {
                    final id = state.pathParameters['id']!;
                    return AnimatePageRoute(
                      name: state.name,
                      key: state.pageKey,
                      child: (animation) => ProductDetailsView(
                        id: id,
                        key: ValueKey(id),
                        animation: animation,
                        campaignId: state.uri.queryParameters['cid'],
                      ),
                    );
                  },
                ),
              ],
            ),
            GoRoute(
              parentNavigatorKey: rootKey,
              path: RouteNames.categories.path,
              name: RouteNames.categories.name,
              pageBuilder: (context, state) => AnimatePageRoute(
                name: state.name,
                key: state.pageKey,
                child: (animation) => const CategoriesView(),
              ),
              routes: [
                GoRoute(
                  parentNavigatorKey: rootKey,
                  path: RouteNames.categoryProducts.path,
                  name: RouteNames.categoryProducts.name,
                  pageBuilder: (context, state) => AnimatePageRoute(
                    name: state.name,
                    key: state.pageKey,
                    child: (animation) => CategoriesProductsView(
                      state.pathParameters['id']!,
                    ),
                  ),
                ),
              ],
            ),
            GoRoute(
              parentNavigatorKey: rootKey,
              path: RouteNames.brands.path,
              name: RouteNames.brands.name,
              pageBuilder: (context, state) => AnimatePageRoute(
                name: state.name,
                key: state.pageKey,
                child: (animation) => const BrandsView(),
              ),
              routes: [
                GoRoute(
                  parentNavigatorKey: rootKey,
                  path: RouteNames.brandProducts.path,
                  name: RouteNames.brandProducts.name,
                  pageBuilder: (context, state) => AnimatePageRoute(
                    name: state.name,
                    key: state.pageKey,
                    child: (animation) =>
                        BrandProductsView(state.pathParameters['id']!),
                  ),
                ),
              ],
            ),
            GoRoute(
              parentNavigatorKey: rootKey,
              path: RouteNames.orders.path,
              name: RouteNames.orders.name,
              redirect: authRedirect,
              pageBuilder: (context, state) => AnimatePageRoute(
                name: state.name,
                key: state.pageKey,
                child: (animation) => const OrderListView(),
              ),
            ),
            GoRoute(
              parentNavigatorKey: rootKey,
              path: RouteNames.orderDetails.path,
              name: RouteNames.orderDetails.name,
              pageBuilder: (context, state) => AnimatePageRoute(
                name: state.name,
                key: state.pageKey,
                child: (animation) => OrderDetailsView(
                  orderId: state.uri.queryParameters['id'],
                ),
              ),
            ),
            GoRoute(
              parentNavigatorKey: rootKey,
              path: RouteNames.trackOrder.path,
              name: RouteNames.trackOrder.name,
              pageBuilder: (context, state) => AnimatePageRoute(
                name: state.name,
                key: state.pageKey,
                child: (animation) => TrackOrderView(
                  orderId: state.uri.queryParameters['id'],
                ),
              ),
            ),
            GoRoute(
              parentNavigatorKey: rootKey,
              path: RouteNames.address.path,
              name: RouteNames.address.name,
              pageBuilder: (context, state) => AnimatePageRoute(
                name: state.name,
                key: state.pageKey,
                child: (animation) => const AddressView(),
              ),
              routes: [
                GoRoute(
                  parentNavigatorKey: rootKey,
                  path: RouteNames.addAddress.path,
                  name: RouteNames.addAddress.name,
                  redirect: authRedirect,
                  pageBuilder: (context, state) => AnimatePageRoute(
                    name: state.name,
                    key: state.pageKey,
                    child: (animation) => const AddAddressView(),
                  ),
                ),
                GoRoute(
                  parentNavigatorKey: rootKey,
                  path: RouteNames.editAddress.path,
                  name: RouteNames.editAddress.name,
                  redirect: authRedirect,
                  pageBuilder: (context, state) {
                    final address = state.extra as BillingAddress;
                    return AnimatePageRoute(
                      name: state.name,
                      key: state.pageKey,
                      child: (animation) => AddAddressView(address: address),
                    );
                  },
                ),
              ],
            ),
            GoRoute(
              parentNavigatorKey: rootKey,
              path: RouteNames.contactUs.path,
              name: RouteNames.contactUs.name,
              pageBuilder: (context, state) => AnimatePageRoute(
                name: state.name,
                key: state.pageKey,
                child: (animation) => const ContactUsView(),
              ),
              routes: [
                GoRoute(
                  parentNavigatorKey: rootKey,
                  path: RouteNames.supportTicket.path,
                  name: RouteNames.supportTicket.name,
                  redirect: authRedirect,
                  pageBuilder: (context, state) => AnimatePageRoute(
                    name: state.name,
                    key: state.pageKey,
                    child: (animation) => const SupportTicketListView(),
                  ),
                  routes: [
                    GoRoute(
                      parentNavigatorKey: rootKey,
                      path: RouteNames.createTicket.path,
                      name: RouteNames.createTicket.name,
                      pageBuilder: (context, state) => AnimatePageRoute(
                        name: state.name,
                        key: state.pageKey,
                        fullscreen: true,
                        child: (animation) => const CreateTicketView(),
                      ),
                    ),
                    GoRoute(
                      parentNavigatorKey: rootKey,
                      path: RouteNames.ticketDetails.path,
                      name: RouteNames.ticketDetails.name,
                      pageBuilder: (context, state) {
                        final id = state.pathParameters['id'];
                        return AnimatePageRoute(
                          name: state.name,
                          key: state.pageKey,
                          child: (animation) => TicketDetailsView(id!),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            GoRoute(
              parentNavigatorKey: rootKey,
              path: RouteNames.settings.path,
              name: RouteNames.settings.name,
              pageBuilder: (context, state) => AnimatePageRoute(
                name: state.name,
                key: state.pageKey,
                child: (animation) => const SettingsView(),
              ),
              routes: [
                GoRoute(
                  parentNavigatorKey: rootKey,
                  path: RouteNames.region.path,
                  name: RouteNames.region.name,
                  pageBuilder: (context, state) => AnimatePageRoute(
                    name: state.name,
                    key: state.pageKey,
                    child: (animation) => const RegionView(),
                  ),
                ),
                GoRoute(
                  parentNavigatorKey: rootKey,
                  path: RouteNames.extraPage.path,
                  name: RouteNames.extraPage.name,
                  pageBuilder: (context, state) {
                    final id = state.pathParameters['pageId']!;
                    return AnimatePageRoute(
                      name: state.name,
                      key: state.pageKey,
                      child: (animation) => ExtraPageView(id: id),
                    );
                  },
                ),
              ],
            ),
          ],
        ),

        ///! wishlist Section
        GoRoute(
          path: RouteNames.wishlist.path,
          name: RouteNames.wishlist.name,
          pageBuilder: (context, state) => NoTransitionPage(
            name: state.name,
            key: state.pageKey,
            child: const WishListView(),
          ),
        ),

        //! Campaign section
        GoRoute(
          path: RouteNames.campaigns.path,
          name: RouteNames.campaigns.name,
          pageBuilder: (context, state) => NoTransitionPage(
              name: state.name,
              key: state.pageKey,
              child: const CampaignsView()),
          routes: [
            GoRoute(
              path: RouteNames.campaignDetails.path,
              name: RouteNames.campaignDetails.name,
              parentNavigatorKey: rootKey,
              pageBuilder: (context, state) => AnimatePageRoute(
                name: state.name,
                key: state.pageKey,
                child: (animation) => CampaignDetailsView(
                  state.pathParameters['id']!,
                ),
              ),
            ),
          ],
        ),

        //! Cart section
        GoRoute(
          path: RouteNames.carts.path,
          name: RouteNames.carts.name,
          pageBuilder: (context, state) => NoTransitionPage(
            name: state.name,
            child: const CartsView(),
          ),
          routes: [
            GoRoute(
              path: RouteNames.checkoutPayment.path,
              name: RouteNames.checkoutPayment.name,
              redirect: canGuestCheckOut ? null : authRedirect,
              parentNavigatorKey: rootKey,
              pageBuilder: (context, state) => AnimatePageRoute(
                name: state.name,
                key: state.pageKey,
                child: (animation) => const CheckoutPaymentView(),
              ),
            ),
            GoRoute(
              path: RouteNames.checkoutSummary.path,
              name: RouteNames.checkoutSummary.name,
              redirect: canGuestCheckOut ? null : authRedirect,
              parentNavigatorKey: rootKey,
              pageBuilder: (context, state) => AnimatePageRoute(
                name: state.name,
                key: state.pageKey,
                child: (animation) => const CheckoutSummeryView(),
              ),
            ),
            GoRoute(
              path: RouteNames.shippingDetails.path,
              name: RouteNames.shippingDetails.name,
              redirect: canGuestCheckOut ? null : authRedirect,
              parentNavigatorKey: rootKey,
              pageBuilder: (context, state) => AnimatePageRoute(
                name: state.name,
                key: state.pageKey,
                child: (animation) => const CheckoutShippingView(),
              ),
            ),
            GoRoute(
              path: RouteNames.orderPlaced.path,
              name: RouteNames.orderPlaced.name,
              redirect: canGuestCheckOut ? null : authRedirect,
              parentNavigatorKey: rootKey,
              pageBuilder: (context, state) => AnimatePageRoute(
                name: state.name,
                key: state.pageKey,
                child: (animation) => const OrderPlacedPage(),
              ),
            ),
            GoRoute(
              path: RouteNames.bkashPayment.path,
              name: RouteNames.bkashPayment.name,
              parentNavigatorKey: rootKey,
              pageBuilder: (context, state) => AnimatePageRoute(
                name: state.name,
                key: state.pageKey,
                child: (animation) => BkashWebviewPage(
                  url: state.extra as String,
                ),
              ),
            ),
            GoRoute(
              path: RouteNames.nagadPayment.path,
              name: RouteNames.nagadPayment.name,
              parentNavigatorKey: rootKey,
              pageBuilder: (context, state) => AnimatePageRoute(
                name: state.name,
                key: state.pageKey,
                child: (animation) => NagadWebviewPage(
                  url: state.extra as String,
                ),
              ),
            ),
            GoRoute(
              path: RouteNames.flutterWavePayment.path,
              name: RouteNames.flutterWavePayment.name,
              redirect: authRedirect,
              parentNavigatorKey: rootKey,
              pageBuilder: (context, state) => AnimatePageRoute(
                name: state.name,
                key: state.pageKey,
                child: (animation) => FlutterWaveWebviewPage(
                  url: state.extra as String,
                ),
              ),
            ),
            GoRoute(
              path: RouteNames.instaMojoPayment.path,
              name: RouteNames.instaMojoPayment.name,
              parentNavigatorKey: rootKey,
              pageBuilder: (context, state) => AnimatePageRoute(
                name: state.name,
                key: state.pageKey,
                child: (animation) => InstaMojoWebviewPage(
                  url: state.extra as String,
                ),
              ),
            ),
            GoRoute(
              path: RouteNames.paystackPayment.path,
              name: RouteNames.paystackPayment.name,
              parentNavigatorKey: rootKey,
              pageBuilder: (context, state) => AnimatePageRoute(
                name: state.name,
                key: state.pageKey,
                child: (animation) => PaystackWebviewPage(
                  url: state.extra as String,
                ),
              ),
            ),
            GoRoute(
              path: RouteNames.paypalPayment.path,
              name: RouteNames.paypalPayment.name,
              parentNavigatorKey: rootKey,
              pageBuilder: (context, state) => AnimatePageRoute(
                name: state.name,
                key: state.pageKey,
                child: (animation) => PaypalWebviewPage(
                  url: state.extra as String,
                ),
              ),
            ),
            GoRoute(
              path: RouteNames.stripePayment.path,
              name: RouteNames.stripePayment.name,
              parentNavigatorKey: rootKey,
              pageBuilder: (context, state) => AnimatePageRoute(
                name: state.name,
                key: state.pageKey,
                child: (animation) {
                  return StripeWebviewPage(state.extra as String);
                },
              ),
            ),
          ],
        ),
      ],
    ),
  ];
  return routeList;
});

Future<bool> showExitDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return const ExitDialog();
    },
  );

  return result ?? false;
}
