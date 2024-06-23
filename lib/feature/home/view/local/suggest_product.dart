import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_com/core/core.dart';
import 'package:e_com/feature/home/view/local/suggest_product_card.dart';
import 'package:e_com/models/content/product_models.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SuggestProductView extends ConsumerWidget {
  const SuggestProductView({
    super.key,
    required this.products,
  });
  final List<ProductsData> products;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CarouselSlider.builder(
      options: CarouselOptions(
        autoPlayCurve: Curves.easeInExpo,
        clipBehavior: Clip.none,
        enlargeCenterPage: true,
        viewportFraction: 1,
        initialPage: 0,
        autoPlayInterval: const Duration(seconds: 3),
        height: context.onMobile ? 100 : 130,
        autoPlay: true,
      ),
      itemCount: products.length,
      itemBuilder: (context, index, realIndex) {
        return SuggestProductCard(product: products[index]);
      },
    );
  }
}
