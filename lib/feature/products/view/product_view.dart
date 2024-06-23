import 'package:e_com/core/core.dart';
import 'package:e_com/feature/products/controller/filtering_ctrl.dart';
import 'package:e_com/models/models.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'local/local.dart';

class ProductView extends HookConsumerWidget {
  const ProductView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final type = context.query('t');
    final query = context.query('search');
    final args = (type: type, query: query);

    final filtered = ref.watch(filteringCtrlProvider(args));

    final filterCtrl =
        useCallback(() => ref.read(filteringCtrlProvider(args).notifier));

    final searchTextCtrl = useTextEditingController();

    void search() {
      filterCtrl().search(searchTextCtrl.text);
    }

    useEffect(() {
      searchTextCtrl.text = query ?? '';
      return null;
    }, const []);

    return Scaffold(
      appBar: context.onMobile
          ? KAppBar(
              title: Text(Translator.products(context)),
              leading: SquareButton.backButton(onPressed: () => context.pop()),
              bottom: AppBarTextField(
                hint: Translator.searchForProduct(context),
                controller: searchTextCtrl,
                onSubmit: search,
                onChanged: (v) => search(),
                suffix: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      scrollControlDisabledMaxHeightRatio: 0.7,
                      builder: (_) => ProviderScope(
                        parent: ProviderScope.containerOf(context),
                        child: FilterBottomSheet(args, searchTextCtrl.text),
                      ),
                    );
                  },
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: defaultRadius,
                      color: context.colorTheme.secondaryContainer,
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Assets.lottie.filter2.lottie(),
                  ),
                ),
              ),
            )
          : KAppBar(
              color: context.colorTheme.primary,
              title: Text(Translator.products(context)),
              leading: SquareButton.backButton(onPressed: () => context.pop()),
              bottom: PreferredSize(
                preferredSize: const Size(double.infinity, 60),
                child: Padding(
                  padding: defaultPadding,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 60,
                            width: context.width / 2,
                            child: TextFormField(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: context.colorTheme.onPrimary,
                                hintText: Translator.searchForProduct(context),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                scrollControlDisabledMaxHeightRatio: 0.7,
                                builder: (_) => ProviderScope(
                                  parent: ProviderScope.containerOf(context),
                                  child: FilterBottomSheet(
                                      args, searchTextCtrl.text),
                                ),
                              );
                            },
                            child: Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                borderRadius: defaultRadius,
                                color: context.colorTheme.secondaryContainer,
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Assets.lottie.filter2.lottie(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
      body: filtered.when(
        loading: () => const ProductsLoading(),
        error: ErrorView.errorMethod,
        data: (data) {
          final isEmpty =
              data.products.fold((l) => l.isEmpty, (r) => r.isEmpty);

          if (isEmpty) {
            return const SingleChildScrollView(
              child: Center(child: NoItemsAnimationWithFooter()),
            );
          }

          final ProductFilteringState(:pagination, :products) = data;
          return Padding(
            padding: EdgeInsets.all(context.onMobile ? 10 : 15),
            child: MGridViewWithFooter(
              physics: defaultScrollPhysics,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              itemCount: products.fold((l) => l.length, (r) => r.length),
              crossAxisCount: context.onMobile ? 2 : 4,
              pagination: pagination,
              onPrevious: () {
                filterCtrl().previousPage();
              },
              onNext: () {
                filterCtrl().nextPage();
              },
              builder: (context, index) {
                return products.fold(
                  (l) => ProductCard(product: l[index], type: type),
                  (r) => DigitalProductCard(product: r[index]),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class ProductsLoading extends StatelessWidget {
  const ProductsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: context.onMobile ? 2 : 4,
      ),
      mainAxisSpacing: 5,
      crossAxisSpacing: 5,
      itemCount: context.onMobile ? 6 : 25,
      itemBuilder: (context, index) =>
          KShimmer.card(height: 200 + (index * 10)),
    );
  }
}
