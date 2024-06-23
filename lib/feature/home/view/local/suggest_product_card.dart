import 'package:e_com/core/core.dart';
import 'package:e_com/feature/region_settings/provider/region_provider.dart';
import 'package:e_com/models/content/product_models.dart';
import 'package:e_com/routes/go_route_name.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SuggestProductCard extends ConsumerWidget {
  const SuggestProductCard({
    super.key,
    required this.product,
    this.cId,
  });
  final ProductsData product;
  final String? cId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final local = ref.watch(localeCurrencyStateProvider);
    return Padding(
      padding: const EdgeInsets.all(3),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          RouteNames.productDetails.pushNamed(
            context,
            pathParams: {'id': product.uid},
            query: {
              'isRegular': 'true',
              't': 'suggest',
              if (cId != null) 'cid': cId!,
            },
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: defaultRadius,
            color: context.colorTheme.surface,
            border: Border.all(
              width: 0,
              color: context.colorTheme.secondary,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                flex: context.onMobile ? 3 : 2,
                child: Padding(
                  padding: defaultPaddingAll,
                  child: ClipRRect(
                    borderRadius: defaultRadius,
                    child: HostedImage(
                      product.featuredImage,
                      fit: BoxFit.cover,
                      height: 85,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: Container(
                  height: context.height,
                  width: 1,
                  color:
                      context.colorTheme.secondaryContainer.withOpacity(0.03),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 6,
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          product.name,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
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
                        Wrap(
                          children: [
                            if (product.isDiscounted)
                              Text(
                                product.discountAmount.fromLocal(local),
                                style: context.textTheme.bodyMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: context.colorTheme.error,
                                ),
                              ),
                            if (product.isDiscounted) const SizedBox(width: 5),
                            Text(
                              product.price.fromLocal(local),
                              style: product.isDiscounted
                                  ? context.textTheme.bodyMedium?.copyWith(
                                      decoration: TextDecoration.lineThrough,
                                    )
                                  : context.textTheme.bodyMedium!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: context.colorTheme.error,
                                    ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Positioned(
                      top: 5,
                      right: 5,
                      child: Container(
                        width: 50,
                        decoration: BoxDecoration(
                          color: context.colorTheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 2,
                          ),
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
                                style: context.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
