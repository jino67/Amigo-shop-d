import 'package:e_com/core/core.dart';
import 'package:e_com/feature/categories/view/local/category_card.dart';
import 'package:e_com/models/content/category_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CategoryShowcase extends HookConsumerWidget {
  const CategoryShowcase({super.key, required this.categories});
  final List<CategoriesData> categories;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: categories.length <= 4 ? 120 : 240,
      child: MasonryGridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: categories.length <= 4
              ? context.onMobile
                  ? 4
                  : 8
              : context.onMobile
                  ? 4
                  : 8,
        ),
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        clipBehavior: Clip.none,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return CategoryCard(category: category);
        },
      ),
    );
  }
}
