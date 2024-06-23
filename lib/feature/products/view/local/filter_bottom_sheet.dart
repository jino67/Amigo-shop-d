import 'package:e_com/core/core.dart';
import 'package:e_com/feature/brands/provider/brand_provider.dart';
import 'package:e_com/feature/categories/providers/categories_provider.dart';
import 'package:e_com/feature/products/controller/filtering_ctrl.dart';
import 'package:e_com/feature/products/view/local/filter_n_search_list_dialog.dart';
import 'package:e_com/feature/region_settings/provider/region_provider.dart';
import 'package:e_com/feature/settings/provider/settings_provider.dart';
import 'package:e_com/models/models.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FilterBottomSheet extends HookConsumerWidget {
  const FilterBottomSheet(this.args, this.localSearch, {super.key});

  final FilterArgs args;
  final String localSearch;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final local = ref.watch(localeCurrencyStateProvider);
    final range =
        ref.watch(settingsProvider.select((x) => x?.settings.filterRange));
    final categories = ref.watch(categoryListProvider);
    final brands = ref.watch(brandListProvider);
    final filtered = ref.watch(filteringCtrlProvider(args));
    final minPriceCtrl = useTextEditingController();
    final maxPriceCtrl = useTextEditingController();

    final filterCtrl =
        useCallback(() => ref.read(filteringCtrlProvider(args).notifier));

    final onReset = useCallback(() {
      minPriceCtrl.clear();
      maxPriceCtrl.clear();
      filterCtrl().reset();
      context.pop();
    }, const []);

    final onSubmit = useCallback(() async {
      context.pop();
      await filterCtrl().setMin(minPriceCtrl.text);
      await filterCtrl().setMax(maxPriceCtrl.text);
      await filterCtrl().filter(localSearch);
    }, const []);

    useEffect(() {
      final value = filtered.valueOrNull;
      minPriceCtrl.text = value?.min ?? '';
      maxPriceCtrl.text = value?.max ?? '';
      return null;
    }, const []);

    return Card(
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Text(
                  Translator.filters(context),
                  style: context.textTheme.titleLarge,
                ),
                const SizedBox(height: 5),
                Container(
                  height: 3,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: context.colorTheme.primary,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            flex: 7,
            child: filtered.when(
              loading: Loader.loading,
              error: ErrorView.errorMethod,
              data: (filterData) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),
                        Text(
                          Translator.sortWithPrice(context),
                          style: context.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Flexible(
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                controller: minPriceCtrl,
                                decoration: InputDecoration(
                                  hintText:
                                      '${Translator.min(context)} ${range?.start.fromLocal(local)}',
                                  suffixIcon: IconButton(
                                    onPressed: () => minPriceCtrl.clear(),
                                    icon: const Icon(Icons.clear),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              height: 1,
                              width: 20,
                              color: context.colorTheme.outline,
                            ),
                            Flexible(
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                controller: maxPriceCtrl,
                                decoration: InputDecoration(
                                  hintText:
                                      '${Translator.max(context)} ${range?.start.fromLocal(local)}',
                                  suffixIcon: IconButton(
                                    onPressed: () => maxPriceCtrl.clear(),
                                    icon: const Icon(Icons.clear),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          Translator.sortOrder(context),
                          style: context.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ...SortType.values.map(
                              (e) => Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: e == filterData.sortType
                                          ? context.colorTheme.primary
                                          : Colors.transparent,
                                      side: e == filterData.sortType
                                          ? BorderSide(
                                              width: 1.5,
                                              color: context.colorTheme.primary,
                                            )
                                          : null,
                                      shape: const StadiumBorder(),
                                    ),
                                    onPressed: () =>
                                        filterCtrl().setSortType(e),
                                    child: Text(
                                      e.translated(context),
                                      style: context.textTheme.titleSmall!
                                          .copyWith(
                                        color: e == filterData.sortType
                                            ? context.colorTheme.onPrimary
                                            : context.colorTheme.secondary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              Translator.category(context),
                              style: context.textTheme.titleMedium,
                            ),
                            const SizedBox(width: 10),
                            Container(
                              decoration: BoxDecoration(
                                color: context.colorTheme.secondaryContainer
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 2,
                                ),
                                child: Text(
                                  categories.length.toString(),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: defaultRadius,
                            color: context.colorTheme.secondaryContainer
                                .withOpacity(0.05),
                          ),
                          child: InkWell(
                            borderRadius: defaultRadius,
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (_) => ProviderScope(
                                  parent: ProviderScope.containerOf(context),
                                  child: FilterNSearchListDialog(
                                    labelBuilder: (value) =>
                                        value.name.valueOrFirst(
                                            local.langCode, defLocale(ref)) ??
                                        'N/A',
                                    hinText:
                                        Translator.searchCategories(context),
                                    onConfirm: (data) {
                                      ref
                                          .read(filteringCtrlProvider(args)
                                              .notifier)
                                          .setCategory(data);
                                    },
                                    title: Translator.searchCategories(context),
                                    listData: categories,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    filterData.category?.name.valueOrFirst(
                                            local.langCode, defLocale(ref)) ??
                                        Translator.select(context),
                                    style: context.textTheme.titleMedium,
                                  ),
                                  const Icon(Icons.arrow_downward),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (args.type != 'digital') ...[
                          Row(
                            children: [
                              Text(
                                Translator.brands(context),
                                style: context.textTheme.titleMedium,
                              ),
                              const SizedBox(width: 10),
                              Container(
                                decoration: BoxDecoration(
                                  color: context.colorTheme.secondaryContainer
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 2,
                                  ),
                                  child: Text(
                                    brands.length.toString(),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: defaultRadius,
                              color: context.colorTheme.secondaryContainer
                                  .withOpacity(0.05),
                            ),
                            child: InkWell(
                              borderRadius: defaultRadius,
                              onTap: () => showDialog(
                                context: context,
                                builder: (_) => ProviderScope(
                                  parent: ProviderScope.containerOf(context),
                                  child: FilterNSearchListDialog(
                                    labelBuilder: (value) =>
                                        value.name.valueOrFirst(
                                            local.langCode, defLocale(ref)) ??
                                        'N/A',
                                    hinText: Translator.searchBrands(context),
                                    onConfirm: (data) =>
                                        filterCtrl().setBrand(data),
                                    title: Translator.brands(context),
                                    listData: brands,
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      filterData.brand?.name.valueOrFirst(
                                              local.langCode, defLocale(ref)) ??
                                          Translator.select(context),
                                      style: context.textTheme.titleMedium,
                                    ),
                                    const Icon(Icons.arrow_downward),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => onReset(),
                      child: Text(Translator.reset(context)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => onSubmit(),
                      child: Text(Translator.submit(context)),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
