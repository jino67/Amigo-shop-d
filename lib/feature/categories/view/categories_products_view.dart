import 'package:e_com/core/core.dart';
import 'package:e_com/feature/categories/controller/category_ctrl.dart';
import 'package:e_com/feature/categories/view/local/categories_product_loading.dart';
import 'package:e_com/feature/products/view/local/product_card.dart';
import 'package:e_com/feature/region_settings/provider/region_provider.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CategoriesProductsView extends HookConsumerWidget {
  const CategoriesProductsView(this.id, {super.key});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryData = ref.watch(categoryCtrlProvider(id));
    final categoryCtrl =
        useCallback(() => ref.read(categoryCtrlProvider(id).notifier));
    final locale = ref.watch(localeCurrencyStateProvider);

    return categoryData.when(
      error: ErrorView.withScaffold,
      loading: () => const CategoriesProductLoading(),
      data: (details) {
        final category = details.category;
        final products = details.products;
        return Scaffold(
          appBar: KAppBar(
            leading: SquareButton.backButton(
              onPressed: () => context.pop(),
            ),
            title: Text(
              category.name.valueOrFirst(locale.langCode, defLocale(ref)) ?? '',
            ),
          ),
          body: Padding(
            padding: defaultPadding,
            child: products.isEmpty
                ? const Center(child: NoItemsAnimation())
                : RefreshIndicator(
                    onRefresh: () => categoryCtrl().reload(),
                    child: MGridViewWithFooter(
                      physics: defaultScrollPhysics,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      itemCount: products.length,
                      crossAxisCount: context.onMobile ? 2 : 4,
                      pagination: products.pagination,
                      onPrevious: () => categoryCtrl().handlePagination(false),
                      onNext: () => categoryCtrl().handlePagination(true),
                      builder: (context, index) {
                        return ProductCard(
                          product: products[index],
                          type: 'category',
                        );
                      },
                    ),
                  ),
          ),
        );
      },
    );
  }
}
