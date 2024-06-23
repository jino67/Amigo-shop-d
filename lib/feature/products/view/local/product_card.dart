import 'package:collection/collection.dart';
import 'package:e_com/core/core.dart';
import 'package:e_com/feature/cart/controller/carts_ctrl.dart';
import 'package:e_com/feature/region_settings/provider/region_provider.dart';
import 'package:e_com/models/models.dart';
import 'package:e_com/routes/routes.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProductCard extends HookConsumerWidget {
  const ProductCard({
    super.key,
    required this.product,
    this.height = 160,
    this.width = 180,
    this.cId,
    required this.type,
  });

  final ProductsData product;
  final String? type;
  final double height;
  final double width;
  final String? cId;

  String percent() {
    num price = product.price;
    num discountPrice = product.discountAmount;
    if (price <= 0) return '0 %';
    final total = ((price - discountPrice) / price) * 100;

    final percentage = total.toInt();
    return '$percentage %';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final local = ref.watch(localeCurrencyStateProvider);
    final isLoading = useState(false);
    final cartList = ref.watch(
          cartCtrlProvider.select((carts) => carts.valueOrNull?.listData),
        ) ??
        [];
    final bool isCart =
        cartList.any((element) => element.product.uid == product.uid);

    final availableVariant = useState<MapEntry<String, VariantPrice>?>((null));

    useEffect(
      () {
        final variantPrices = product.variantPrices.map(
          (k, v) => MapEntry(k, VariantPrice.fromMap(v)),
        );
        availableVariant.value =
            variantPrices.entries.firstWhereOrNull((e) => e.value.quantity > 0);
        return null;
      },
      [product.uid],
    );


    final price = availableVariant.value == null
        ? product.price
        : product.price;

    final discountPrice = availableVariant.value == null
        ? product.discountAmount
        : availableVariant.value!.value.discount;
    final isDiscount = availableVariant.value == null
        ? product.isDiscounted
        : availableVariant.value!.value.isDiscounted;

    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: defaultRadius,
        color: context.colorTheme.surface,
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            color: context.colorTheme.primaryContainer
                .withOpacity(context.isDark ? 0.3 : 0.04),
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          RouteNames.productDetails.pushNamed(
            context,
            pathParams: {'id': product.uid},
            query: {
              'isRegular': 'true',
              if (type != null) 't': type!,
              if (cId != null) 'cid': cId!,
            },
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: defaultRadiusOnlyTop,
                  child: HeroWidget(
                    tag: HeroTags.productImgTag(product, type ?? ''),
                    child: HostedImage(
                      height: 160,
                      width: double.infinity,
                      product.featuredImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 5,
                  right: 0,
                  child: HeroWidget(
                    tag: HeroTags.iconTag(
                      product.uid.ifEmpty(DateTime.now().toString()),
                      type,
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        isLoading.value = true;

                        await ref.read(cartCtrlProvider.notifier).addToCart(
                              product: product,
                              attribute: availableVariant.value?.key,
                              cUid: cId,
                            );
                        isLoading.value = false;
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                          left: 15,
                          right: 10,
                          top: 8,
                          bottom: 8,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(100),
                            bottomLeft: Radius.circular(100),
                          ),
                          color: context.colorTheme.secondaryContainer,
                        ),
                        child: isLoading.value
                            ? SizedBox.square(
                                dimension: 25,
                                child: CircularProgressIndicator(
                                  color: context.colorTheme.onSecondary,
                                ),
                              )
                            : isCart
                                ? Icon(
                                    Icons.done,
                                    color: context.colorTheme.onSecondary,
                                  )
                                : Icon(
                                    Icons.shopping_basket_rounded,
                                    color: context.colorTheme.onSecondary,
                                    size: 25,
                                  ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      width: 60,
                      decoration: BoxDecoration(
                        color: context.colorTheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.star,
                              size: 15,
                              color: context.colorTheme.primary,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              product.rating.avgRating.toString(),
                              style: context.textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.colorTheme.error,
                      borderRadius: defaultRadiusPercentage,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                      ),
                      child: Text(
                        percent(),
                        style: context.textTheme.bodyLarge!.copyWith(
                          color: context.colorTheme.onError,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  HeroWidget(
                    tag: HeroTags.productNameTag(product, type),
                    child: Text(
                      product.name,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodyLarge!
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                  Text(
                    product.availableAny
                        ? Translator.inStock(context)
                        : Translator.stockOut(context),
                    style: context.textTheme.bodyLarge!.copyWith(
                      color: product.availableAny
                          ? context.colorTheme.errorContainer
                          : context.colorTheme.error,
                    ),
                  ),
                  const SizedBox(height: 5),
                  HeroWidget(
                    tag: HeroTags.productPriceTag(product, type),
                    child: Text.rich(
                      TextSpan(
                        style: context.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.colorTheme.primary,
                        ),
                        children: [
                          if (isDiscount) ...[
                            TextSpan(
                              text: discountPrice.fromLocal(local),
                            ),
                            const TextSpan(text: '  '),
                          ],
                          TextSpan(
                            text: price.fromLocal(local),
                            style: isDiscount
                                ? context.textTheme.bodyMedium?.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
