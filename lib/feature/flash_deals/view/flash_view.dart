import 'package:e_com/core/core.dart';
import 'package:e_com/feature/flash_deals/view/flash_product_card.dart';
import 'package:e_com/models/content/product_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FlashDealView extends HookConsumerWidget {
  const FlashDealView({
    super.key,
    required this.products,
  });

  final List<ProductsData> products;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 160,
      child: MasonryGridView.count(
        clipBehavior: Clip.none,
        crossAxisCount: 1,
        physics: defaultScrollPhysics,
        scrollDirection: Axis.horizontal,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        itemCount: products.length,
        itemBuilder: (BuildContext context, int index) {
          return FlashProductCard(product: products[index]);
        },
      ),
    );
  }
}
