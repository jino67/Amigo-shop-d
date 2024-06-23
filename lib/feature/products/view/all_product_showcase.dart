import 'package:e_com/core/core.dart';
import 'package:e_com/feature/products/providers/product_providers.dart';
import 'package:e_com/feature/products/view/local/product_card.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AllProductShowcase extends ConsumerWidget {
  const AllProductShowcase({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsData = ref.watch(allProductsLisProvider);
    return SingleChildScrollView(
      physics: defaultScrollPhysics,
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: productsData.when(
        loading: () => Row(
          children: [
            ...List.generate(
              5,
              (index) => KShimmer.card(height: 200, width: 200),
            ),
          ],
        ),
        error: (error, stack) => ErrorView.compact(error),
        data: (products) {
          if (products.isEmpty) {
            return Center(
              child: NoItemsAnimation(
                hight: 100,
                style: context.textTheme.bodyLarge,
              ),
            );
          }
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...products.map(
                (product) => Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ProductCard(
                    product: product,
                    height: 200,
                    type: 'all',
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
