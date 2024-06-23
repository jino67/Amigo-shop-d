import 'package:e_com/core/core.dart';
import 'package:e_com/feature/region_settings/provider/region_provider.dart';
import 'package:e_com/models/models.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProductDescHeader extends ConsumerWidget {
  const ProductDescHeader({
    super.key,
    required this.product,
    required this.variantPrice,
  });

  final ProductsData product;
  final VariantPrice variantPrice;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final local = ref.watch(localeCurrencyStateProvider);
    final langCode = local.langCode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: context.colorTheme.secondaryContainer.withOpacity(0.1),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                child: Text(
                  product.category.valueOrFirst(langCode, defLocale(ref)) ?? '',
                  style: context.textTheme.bodyLarge,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: context.colorTheme.secondaryContainer.withOpacity(0.1),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: product.brand.isEmpty ? 0 : 12,
                  vertical: product.brand.isEmpty ? 0 : 5,
                ),
                child: Text(
                  product.brand.valueOrFirst(langCode, defLocale(ref)) ?? '',
                  style: context.textTheme.bodyLarge,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            KRatingBar(rating: product.rating.avgRating),
            Container(
              height: 20,
              width: 1,
              color: context.colorTheme.secondaryContainer,
              margin: const EdgeInsets.symmetric(
                horizontal: 12,
              ),
            ),
            Text(
              '${product.order} ${Translator.orders(context)}',
              style: context.textTheme.bodyLarge,
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          Translator.stockInfo(context, variantPrice.quantity > 0),
          style: context.textTheme.bodyLarge!.copyWith(
            color: variantPrice.quantity > 0
                ? context.colorTheme.errorContainer
                : context.colorTheme.error,
          ),
        ),
        const SizedBox(height: 5),
        HeroWidget(
          tag: HeroTags.productPriceTag(product, context.query('t')),
          child: Text.rich(
            TextSpan(
              style: context.textTheme.titleLarge!.copyWith(
                color: context.colorTheme.primary,
              ),
              children: [
                if (variantPrice.isDiscounted)
                  TextSpan(
                    text: variantPrice.discount.fromLocal(local),
                  ),
                if (product.isDiscounted) const TextSpan(text: '  '),
                TextSpan(
                  text: variantPrice.price.fromLocal(local),
                  style: (variantPrice.isDiscounted)
                      ? context.textTheme.titleMedium?.copyWith(
                          decoration: TextDecoration.lineThrough,
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
