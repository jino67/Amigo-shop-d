import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_com/core/core.dart';
import 'package:e_com/feature/auth/controller/auth_ctrl.dart';
import 'package:e_com/feature/user_dash/provider/user_dash_provider.dart';
import 'package:e_com/feature/wishlist/controller/wishlist_ctrl.dart';
import 'package:e_com/models/models.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProductImageSlider extends HookConsumerWidget {
  const ProductImageSlider({
    super.key,
    required this.images,
    required this.isProduct,
    required this.id,
  });

  final List<String> images;
  final bool isProduct;
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(authCtrlProvider);

    final wishList =
        ref.watch(userDashProvider.select((v) => v?.wishlists.listData ?? []));
    final wishListCtrl =
        useCallback(() => ref.read(wishlistCtrlProvider.notifier));

    final WishlistData? wishListId =
        wishList.where((e) => e.product.uid == id).firstOrNull;

    final bool isWishListed = wishListId != null;

    final isLoading = useState(false);

    return Stack(
      children: [
        CarouselSlider.builder(
          itemCount: images.length,
          options: CarouselOptions(
            clipBehavior: Clip.none,
            height: context.onMobile ? 270 : 400,
            viewportFraction: 1,
            initialPage: 0,
            autoPlay: true,
          ),
          itemBuilder: (context, index, _) {
            final img = images[index];
            return ClipRRect(
              borderRadius: defaultRadius,
              child: HostedImage(
                fit: BoxFit.fitHeight,
                img,
                width: context.width / 1.1,
                enablePreviewing: true,
              ),
            );
          },
        ),
        if (isLoggedIn)
          if (isProduct)
            Positioned(
              bottom: 10,
              right: 20,
              child: IconButton.filled(
                onPressed: () async {
                  isLoading.value = true;
                  if (isWishListed) {
                    await wishListCtrl().deleteWishlist(wishListId.uid);
                    isLoading.value = false;
                    return;
                  }
                  await wishListCtrl().addToWishlist(id);

                  isLoading.value = false;
                },
                icon: isLoading.value
                    ? SizedBox.square(
                        dimension: 25,
                        child: CircularProgressIndicator(
                          color: context.colorTheme.onPrimary,
                        ),
                      )
                    : isWishListed
                        ? const Icon(Icons.favorite, size: 25)
                        : const Icon(Icons.favorite_border, size: 25),
              ),
            ),
      ],
    );
  }
}
