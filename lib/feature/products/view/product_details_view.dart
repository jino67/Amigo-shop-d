import 'package:badges/badges.dart' as badges;
import 'package:e_com/core/core.dart';
import 'package:e_com/feature/cart/controller/carts_ctrl.dart';
import 'package:e_com/feature/product_review/view/product_review_view.dart';
import 'package:e_com/feature/products/controller/product_ctrl.dart';
import 'package:e_com/models/models.dart';
import 'package:e_com/routes/routes.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import 'local/local.dart';

class ProductDetailsView extends HookConsumerWidget {
  const ProductDetailsView({
    super.key,
    required this.id,
    required this.campaignId,
    required this.animation,
  });

  final String? campaignId;
  final String id;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Route queries

    final isRegular = context.query('isRegular') == 'false' ? false : true;
    final type = context.query('t');
    final toReview = context.query('toReview');

    /// riverpod providers

    final argument = (uid: id, isRegular: isRegular, campaignId: campaignId);
    final productData = ref.watch(productCtrlProvider(argument));

    /// UI methods

    final tabIndex = useState(0);

    final onReviewTap = useCallback(
      () => showDialog(
        context: context,
        builder: (context) => ReviewPopup(productID: id),
      ),
    );

    useEffect(() {
      if (toReview == 'true') {
        tabIndex.value = 1;
        Future.delayed(Duration.zero, () => onReviewTap());
      }
      return null;
    }, const []);

    final tabController =
        useTabController(initialLength: 3, initialIndex: tabIndex.value);
    final tabControllerD = useTabController(initialLength: 1);

    final selectedVariant = useState<Map<String, String>>({});
    final variantPrice = useState<VariantPrice?>(null);

    void setNewValiant(String variantName, String variant) {
      selectedVariant.value = {...selectedVariant.value, variantName: variant};
    }

    void variantInit(ProductsData product) {
      if (selectedVariant.value.isEmpty) {
        for (final entry in product.variantNames.entries) {
          selectedVariant.value[entry.key] = entry.value.first;
        }
      }
    }

    return productData.when(
      error: (error, st) => ErrorView.withScaffold(error, st),
      loading: () => const ProductDetailsLoader(),
      data: (productBase) {
        final product = productBase.product;
        final digitalProduct = productBase.digitalProduct;
        final relatedProduct = productBase.relatedProduct;

        // is regular product or digital
        final bool isProduct = product != null;

        if (product != null) {
          variantInit(product);
          final vAttr =
              selectedVariant.value.values.join('-').replaceAll(' ', '');

          final priceKey = product.variantPrices[vAttr];

          variantPrice.value = VariantPrice.fromMap(priceKey);
        }

        return Scaffold(
          appBar: _ProductDetailsAppBar(
            animation,
            url: isProduct ? product.url : digitalProduct?.url,
          ),
          bottomNavigationBar: ProductFabButton(
            product: isProduct ? left(product) : right(digitalProduct!),
            // digital: digitalProduct,
            // isProduct: isProduct,
            selectedVariant:
                selectedVariant.value.values.join('-').replaceAll(' ', ''),
            campaignId: campaignId,
            onReviewTap: tabController.index == 1 ? onReviewTap : null,
            isInStock:
                isProduct ? (variantPrice.value?.quantity ?? 0) > 0 : true,
            onBuyTap: () async {
              await showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                showDragHandle: true,
                builder: (_) => ProviderScope(
                  parent: ProviderScope.containerOf(context),
                  child: DigitalBuySheet(product: digitalProduct!),
                ),
              );
            },
          ),
          body: NestedScrollView(
            physics: defaultScrollPhysics,
            headerSliverBuilder: (context, _) {
              return [
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      const SizedBox(height: 20),
                      HeroWidget(
                        tag: HeroTags.productImgTag(product, type ?? ''),
                        child: ProductImageSlider(
                          id: id,
                          isProduct: isProduct,
                          images: [
                            if (isProduct)
                              ...product.galleryImage
                            else
                              digitalProduct!.featuredImage,
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: context.isLight
                              ? context.colorTheme.surface
                              : context.colorTheme.secondaryContainer
                                  .withOpacity(0.1),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(30),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            HeroWidget(
                              tag: HeroTags.productNameTag(product, type),
                              child: SelectableText(
                                isProduct ? product.name : digitalProduct!.name,
                                style:
                                    context.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (isProduct)
                              ProductDescHeader(
                                product: product,
                                variantPrice: variantPrice.value!,
                              ),
                            const SizedBox(height: 20),
                            if (isProduct)
                              VariantSelection(
                                product: product,
                                selectedVariant: selectedVariant.value,
                                onVariantChange: setNewValiant,
                              ),
                            const SizedBox(height: 10),
                            if (product?.shortDescription != null ||
                                digitalProduct?.shortDescription != null) ...[
                              Text(
                                Translator.shortDescription(context),
                                style: context.textTheme.titleLarge,
                              ),
                              const SizedBox(height: 5),
                              Container(
                                height: 2,
                                width: context.width / 2.4,
                                decoration: BoxDecoration(
                                  color: context.colorTheme.primary,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                            ],
                            const SizedBox(height: 5),
                            if (isProduct)
                              Html(
                                data: product.shortDescription,
                                style: {
                                  "*": Style(
                                    fontSize: FontSize(16),
                                    lineHeight: const LineHeight(1.3),
                                    fontWeight: FontWeight.w400,
                                    color: context.colorTheme.onSurface,
                                    backgroundColor: context.colorTheme.surface,
                                  ),
                                },
                              )
                            else if (digitalProduct?.shortDescription != null)
                              Html(
                                data: digitalProduct!.shortDescription,
                                style: {
                                  "*": Style(
                                    lineHeight: const LineHeight(1.2),
                                    fontSize: FontSize(16),
                                    fontWeight: FontWeight.w400,
                                    color: context.colorTheme.onSurface,
                                    backgroundColor: context.colorTheme.surface,
                                  ),
                                },
                              ),
                            TabBar(
                              tabAlignment: TabAlignment.start,
                              isScrollable: true,
                              controller:
                                  isProduct ? tabController : tabControllerD,
                              onTap: (value) => tabIndex.value = value,
                              physics: const NeverScrollableScrollPhysics(),
                              indicatorColor: context.colorTheme.primary,
                              labelStyle: context.textTheme.bodyLarge,
                              unselectedLabelStyle: context.textTheme.bodyLarge,
                              indicatorSize: TabBarIndicatorSize.label,
                              labelPadding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              tabs: [
                                Tab(
                                  child: Text(
                                    Translator.description(context),
                                  ),
                                ),
                                if (isProduct) ...[
                                  Tab(
                                    child: Text(
                                      Translator.review(context),
                                    ),
                                  ),
                                  Tab(
                                    child: Text(
                                      Translator.shippingDetails(context),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: isProduct ? tabController : tabControllerD,
              physics: defaultScrollPhysics,
              clipBehavior: Clip.none,
              children: [
                ProductDesc(
                  description:
                      product?.description ?? digitalProduct?.description ?? '',
                  relatedProduct: relatedProduct,
                  isRegular: isRegular,
                ),
                if (isProduct)
                  Container(
                    color:
                        context.colorTheme.secondaryContainer.withOpacity(0.01),
                    child: ProductReview(
                      rating: product.rating,
                      productID: product.uid,
                    ),
                  ),
                if (isProduct) ShippingTabView(product: product)
              ],
            ),
          ),
        );
      },
    );
  }
}

class ProductDetailsLoader extends StatelessWidget {
  const ProductDetailsLoader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _ProductDetailsAppBar(null, url: null),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            KShimmer.card(height: 120, width: context.width),
            const SizedBox(height: 10),
            KShimmer.card(height: 20, width: context.width / 1.4),
            const SizedBox(height: 10),
            Row(
              children: [
                KShimmer.card(height: 20, width: 80),
                const SizedBox(width: 10),
                KShimmer.card(height: 20, width: 100),
              ],
            ),
            const SizedBox(height: 10),
            KShimmer.card(height: 20, width: context.width / 1.6),
            const SizedBox(height: 10),
            KShimmer.card(height: 60, width: context.width),
            const SizedBox(height: 10),
            Row(
              children: [
                KShimmer.card(height: 40, width: 80),
                const SizedBox(width: 10),
                KShimmer.card(height: 40, width: 80),
              ],
            ),
            const SizedBox(height: 10),
            KShimmer.card(height: 40, width: 80),
            const SizedBox(height: 10),
            Expanded(child: KShimmer.card(width: context.width)),
          ],
        ),
      ),
    );
  }
}

class _ProductDetailsAppBar extends ConsumerWidget
    implements PreferredSizeWidget {
  const _ProductDetailsAppBar(
    this.animation, {
    required this.url,
  });
  final Animation<double>? animation;
  final String? url;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartCount = ref.watch(
      cartCtrlProvider.select((carts) => carts.valueOrNull?.length ?? 0),
    );

    final animation = this.animation ?? kAlwaysCompleteAnimation;

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) => FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: const Interval(.0, 1, curve: Curves.easeInExpo),
        ),
        child: child,
      ),
      child: KAppBar(
        actions: [
          IconButton.outlined(
            onPressed:
                url == null ? null : () => Share.shareUri(Uri.parse(url!)),
            icon: const Icon(Icons.share),
          ),
          badges.Badge(
            badgeContent: Text(
              cartCount.toString(),
              style: context.textTheme.bodyLarge
                  ?.copyWith(color: context.colorTheme.background),
            ),
            child: IconButton.outlined(
              onPressed: () => RouteNames.carts.goNamed(context),
              icon: const Icon(Icons.shopping_basket_outlined),
            ),
          ),
          const SizedBox(width: 20),
        ],
        title: Text(Translator.productDetails(context)),
        leading: SquareButton.backButton(
          onPressed: () => context.pop(),
        ),
      ),
    );
  }
}
