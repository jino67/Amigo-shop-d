import 'package:e_com/core/core.dart';
import 'package:e_com/feature/auth/controller/auth_ctrl.dart';
import 'package:e_com/feature/cart/controller/carts_ctrl.dart';
import 'package:e_com/feature/region_settings/provider/region_provider.dart';
import 'package:e_com/feature/settings/provider/settings_provider.dart';
import 'package:e_com/feature/user_dash/provider/user_dash_provider.dart';
import 'package:e_com/models/content/digital_product_models.dart';
import 'package:e_com/models/content/product_models.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductFabButton extends HookConsumerWidget {
  const ProductFabButton({
    super.key,
    required this.product,
    // required this.digital,
    // required this.isProduct,
    required this.selectedVariant,
    required this.campaignId,
    required this.onReviewTap,
    required this.isInStock,
    required this.onBuyTap,
  });

  final Function()? onReviewTap;
  final Function()? onBuyTap;
  final String? campaignId;
  final bool isInStock;
  // final ProductsData? product;
  // final DigitalProduct? digital;
  // final bool isProduct;
  final Either<ProductsData, DigitalProduct> product;

  final String? selectedVariant;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final local = ref.watch(localeCurrencyStateProvider);

    // final (sellerWA, isWAActive) = (
    //   product?.store?.whatsappNumber,
    //   product?.store?.whatsappActive ?? false
    // );

    final orderedProducts = ref.watch(userDashProvider)?.allOrderedProductsID;
    final whatsApp =
        ref.watch(settingsProvider.select((v) => v?.settings.whatsappConfig));

    final isLoggedIn = ref.watch(authCtrlProvider);

    final cartsCtrl = useCallback(() => ref.read(cartCtrlProvider.notifier));

    final uid = product.fold((l) => l.uid, (r) => r.uid);
    final canReview = orderedProducts?.contains(uid) ?? false;

    final enableCart = isInStock;
    final isLoading = useState(false);

    final seller = product.fold((l) => l.store, (r) => r.store);

    final (waNum, isActive) =
        (seller?.whatsappNumber, seller?.whatsappActive ?? false);

    final useSeller = (waNum?.isNotEmpty ?? false) && isActive;
    final adminWAActive = whatsApp?.enabled ?? false;

    void orderViaWhatsapp() async {
      if (whatsApp == null) return;

      final query = {
        'phone': useSeller ? waNum : whatsApp.phone,
        'text': whatsApp.messageBuilder(product, selectedVariant ?? '', local),
        'type': 'phone_number',
        'app_absent': '0',
      };

      final uri = Uri(
        scheme: 'https',
        host: 'api.whatsapp.com',
        path: 'send/',
        queryParameters: query,
      );

      await launchUrl(uri);
    }

    final showForAdmin = adminWAActive && seller == null;
    return Container(
      color: context.colorTheme.surface,
      child: Row(
        children: [
          if (isLoggedIn)
            if (canReview && onReviewTap != null)
              CircularButton.filled(
                fillColor: context.colorTheme.secondaryContainer,
                margin: defaultPaddingAll.copyWith(right: 0),
                onPressed: onReviewTap,
                iconSize: 22,
                icon: const Icon(Icons.star_border_rounded),
              ),
          Expanded(
            flex: 3,
            child: SubmitButton(
              padding: defaultPaddingAll.copyWith(
                right: (whatsApp?.enabled ?? false) ? 5 : 10,
              ),
              height: 50,
              isLoading: isLoading.value,
              onPressed: enableCart
                  ? () async {
                      isLoading.value = true;
                      product.fold(
                        (l) async => await cartsCtrl().addToCart(
                          product: l,
                          attribute: selectedVariant,
                          cUid: campaignId,
                        ),
                        (r) => onBuyTap?.call(),
                      );

                      isLoading.value = false;
                    }
                  : null,
              icon: const Icon(Icons.shopping_basket_rounded),
              child: Text(
                product.fold(
                  (l) => Translator.addToCart(context),
                  (r) => Translator.chooseAttributes(context),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          if (adminWAActive)
            if (showForAdmin || useSeller)
              Expanded(
                flex: 3,
                child: SubmitButton(
                  padding: defaultPaddingAll.copyWith(left: 5),
                  height: 50,
                  isLoading: isLoading.value,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF1D5E54),
                    foregroundColor: const Color(0xFF4ED35D),
                  ),
                  onPressed: enableCart ? () => orderViaWhatsapp() : null,
                  icon: Icon(MdiIcons.whatsapp),
                  child: const Text(
                    'WhatsApp Order',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
