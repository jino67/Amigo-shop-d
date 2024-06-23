import 'package:e_com/core/core.dart';
import 'package:e_com/feature/brands/controller/brand_controller.dart';
import 'package:e_com/feature/products/view/local/product_card.dart';
import 'package:e_com/feature/region_settings/provider/region_provider.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BrandProductsView extends ConsumerWidget {
  const BrandProductsView(this.id, {super.key});
  final String id;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brandData = ref.watch(brandCtrlProvider(id));
    final brandCtrl = ref.read(brandCtrlProvider(id).notifier);

    final locale = ref.watch(localeCurrencyStateProvider);
    return brandData.when(
      error: (e, s) => ErrorView.reload(e, s, () => brandCtrl.reload()),
      loading: () => Loader.withScaffold(Translator.brands(context)),
      data: (brand) {
        return Scaffold(
          appBar: KAppBar(
            title: Text(
              brand.brand.name.valueOrFirst(locale.langCode, defLocale(ref)) ??
                  '',
            ),
            leading: SquareButton.backButton(
              onPressed: () => context.pop(),
            ),
          ),
          body: Padding(
            padding: defaultPadding.copyWith(top: 20),
            child: brand.products.isEmpty
                ? const Center(child: NoItemsAnimation())
                : RefreshIndicator(
                    onRefresh: () => brandCtrl.reload(),
                    child: MasonryGridView.builder(
                      physics: defaultScrollPhysics,
                      clipBehavior: Clip.none,
                      gridDelegate:
                          SliverSimpleGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: context.onMobile ? 2 : 4,
                      ),
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      itemCount: brand.products.length,
                      itemBuilder: (context, index) {
                        final product = brand.products[index];
                        return ProductCard(product: product, type: 'brand');
                      },
                    ),
                  ),
          ),
        );
      },
    );
  }
}
