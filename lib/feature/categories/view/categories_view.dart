import 'package:e_com/core/core.dart';
import 'package:e_com/feature/categories/providers/categories_provider.dart';
import 'package:e_com/feature/categories/view/local/category_card.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CategoriesView extends ConsumerWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoryListProvider);
    return Scaffold(
      appBar: KAppBar(
        title: Text(Translator.category(context)),
        leading: SquareButton.backButton(
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: context.onMobile
            ? defaultPadding.copyWith(top: 15)
            : const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: MasonryGridView.builder(
          physics: defaultScrollPhysics,
          shrinkWrap: true,
          gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: context.onMobile ? 4 : 5,
          ),
          mainAxisSpacing: context.onMobile ? 10 : 30,
          clipBehavior: Clip.none,
          crossAxisSpacing: context.onMobile ? 10 : 30,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return CategoryCard(category: category);
          },
        ),
      ),
    );
  }
}
