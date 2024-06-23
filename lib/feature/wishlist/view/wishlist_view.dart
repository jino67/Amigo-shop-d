import 'package:e_com/core/core.dart';
import 'package:e_com/feature/cart/view/carts_view.dart';
import 'package:e_com/feature/region_settings/provider/region_provider.dart';
import 'package:e_com/feature/wishlist/controller/wishlist_ctrl.dart';
import 'package:e_com/feature/wishlist/view/wishlist_tile.dart';
import 'package:e_com/routes/routes.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WishListView extends HookConsumerWidget {
  const WishListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlists = ref.watch(wishlistCtrlProvider);
    final wishlistCtrl =
        useCallback(() => ref.read(wishlistCtrlProvider.notifier));
    final local = ref.watch(localeCurrencyStateProvider);

    return Scaffold(
      appBar: KAppBar(
        title: Text(Translator.wishlist(context)),
      ),
      body: PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) {
          if (didPop) {
            return;
          }
          RouteNames.home.goNamed(context);
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          child: wishlists.when(
            error: (e, s) =>
                ErrorView.reload(e, s, () => wishlistCtrl().reload()),
            loading: () => const CartLoading(),
            data: (wishlist) {
              return RefreshIndicator(
                onRefresh: () => wishlistCtrl().reload(),
                child: ListViewWithFooter(
                  pagination: wishlist.pagination,
                  onNext: () => wishlistCtrl().paginationHandler(true),
                  onPrevious: () => wishlistCtrl().paginationHandler(false),
                  physics: defaultScrollPhysics,
                  itemCount: wishlist.length,
                  emptyListWidget:
                      const Center(child: NoItemsAnimationWithFooter()),
                  itemBuilder: (BuildContext context, int index) {
                    final product = wishlist.listData[index].product;
                    return WishlistTile(
                      product: product,
                      local: local,
                      onDelete: () async {
                        await wishlistCtrl()
                            .deleteWishlist(wishlist.listData[index].uid);
                      },
                      onTap: () => RouteNames.productDetails.goNamed(
                        context,
                        pathParams: {'id': product.uid},
                        query: {'isRegular': 'true', 'wish': 'true'},
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
