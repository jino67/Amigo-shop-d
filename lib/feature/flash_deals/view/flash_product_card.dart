import 'package:e_com/core/core.dart';
import 'package:e_com/feature/region_settings/provider/region_provider.dart';
import 'package:e_com/models/content/product_models.dart';
import 'package:e_com/routes/go_route_name.dart';
import 'package:e_com/widgets/app_image.dart';
import 'package:flutter/material.dart';
import 'package:hold_on_pop/hold_on_pop.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FlashProductCard extends ConsumerWidget {
  const FlashProductCard({super.key, required this.product});

  final ProductsData product;

  String percent() {
    num price = product.price;
    num discountPrice = product.discountAmount;
    if (price <= 0) return '0 %';
    final total = ((price - discountPrice) / price) * 100;
    int percentage = total.toInt();
    return '$percentage %';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final local = ref.watch(localeCurrencyStateProvider);
    return Container(
      decoration: BoxDecoration(
        borderRadius: defaultRadius,
        color: context.colorTheme.surface,
      ),
      child: HoldOnPop(
        popup: FlashProductOverlay(
          product: product,
          percent: percent,
        ),
        child: InkWell(
          onTap: () {
            RouteNames.flashDeals.pushNamed(context);
          },
          child: Column(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: defaultRadiusOnlyTop,
                    child: HostedImage(
                      height: 100,
                      product.featuredImage,
                      fit: BoxFit.cover,
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
                          horizontal: 3,
                        ),
                        child: Text(
                          percent(),
                          style: context.textTheme.bodyMedium!.copyWith(
                            color: context.colorTheme.onError,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 120,
                child: Padding(
                  padding: const EdgeInsets.only(right: 5, left: 5, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.bodyMedium,
                      ),
                      Row(
                        children: [
                          if (product.isDiscounted)
                            Text(
                              product.discountAmount.fromLocal(local),
                              style: context.textTheme.bodyMedium!.copyWith(
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.bold,
                                color: context.colorTheme.error,
                              ),
                            ),
                          if (product.isDiscounted) const SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              product.price.fromLocal(local),
                              style: product.isDiscounted
                                  ? context.textTheme.bodyMedium?.copyWith(
                                      overflow: TextOverflow.ellipsis,
                                      decoration: TextDecoration.lineThrough,
                                    )
                                  : context.textTheme.bodyMedium!.copyWith(
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.bold,
                                      color: context.colorTheme.error,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class FlashProductOverlay extends ConsumerWidget {
  const FlashProductOverlay({
    super.key,
    required this.product,
    required this.percent,
  });

  final ProductsData product;
  final Function() percent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final local = ref.watch(localeCurrencyStateProvider);
    final langCode = local.langCode;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: context.width / 2),
        Stack(
          children: [
            Container(
              width: context.width / 1.1,
              height: context.width / 2.5,
              decoration: BoxDecoration(
                borderRadius: defaultRadius,
                border: Border.all(
                  width: 0,
                  color: context.colorTheme.primary,
                ),
                color: context.colorTheme.surface,
              ),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: defaultRadius,
                      border: Border.all(
                        width: 0,
                        color: context.colorTheme.primary.withOpacity(0.5),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: defaultRadius,
                      child: HostedImage(
                        product.featuredImage,
                        height: 100,
                        width: 100,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.name),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          if (product.isDiscounted)
                            Text(
                              product.discountAmount.fromLocal(local),
                              style: context.textTheme.bodyMedium!.copyWith(
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.bold,
                                color: context.colorTheme.error,
                              ),
                            ),
                          if (product.isDiscounted) const SizedBox(width: 5),
                          Text(
                            product.price.fromLocal(local),
                            style: product.isDiscounted
                                ? context.textTheme.bodyMedium?.copyWith(
                                    overflow: TextOverflow.ellipsis,
                                    decoration: TextDecoration.lineThrough,
                                  )
                                : context.textTheme.bodyMedium!.copyWith(
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.bold,
                                    color: context.colorTheme.error,
                                  ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      if (product.brand.isNotEmpty) ...[
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: defaultRadius,
                            color: context.colorTheme.secondaryContainer
                                .withOpacity(0.05),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: product.brand.isEmpty ? 0 : 12,
                              vertical: product.brand.isEmpty ? 0 : 5,
                            ),
                            child: Text(
                              product.brand
                                      .valueOrFirst(langCode, defLocale(ref)) ??
                                  '',
                              style: context.textTheme.bodyLarge,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                      ],
                      if (product.category.isNotEmpty)
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: defaultRadius,
                            color: context.colorTheme.secondaryContainer
                                .withOpacity(0.05),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 5),
                            child: Text(
                              product.category
                                      .valueOrFirst(langCode, defLocale(ref)) ??
                                  '',
                              style: context.textTheme.bodyLarge,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: defaultRadiusPercentage,
                  color: context.colorTheme.primary,
                ),
                child: Text(
                  percent().toString(),
                  style: context.textTheme.bodyLarge!.copyWith(
                    color: context.colorTheme.onPrimary,
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
