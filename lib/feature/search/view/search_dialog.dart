import 'dart:ui';

import 'package:e_com/core/core.dart';
import 'package:e_com/feature/search/repository/search_providers.dart';
import 'package:e_com/routes/routes.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../controller/product_search_controller.dart';

class SearchDialog extends HookConsumerWidget {
  const SearchDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchTerms = ref.watch(searchTermsCtrlProvider);
    final searchedItems = ref.watch(searchCtrlProvider);
    final searchCtrl = useCallback(() => ref.read(searchCtrlProvider.notifier));
    final termCtrl =
        useCallback(() => ref.read(searchTermsCtrlProvider.notifier));

    final searchTextCtrl = useTextEditingController();
    final searchFocus = useFocusNode();

    final searchProduct = useCallback(() async {
      termCtrl().setNewTerm(searchTextCtrl.text);
      if (!context.mounted) return;
      context.pop();
      RouteNames.productsView.goNamed(
        context,
        query: {'t': 'search', 'search': searchTextCtrl.text},
      );
    });

    useEffect(() {
      searchFocus.requestFocus();
      return null;
    }, const []);

    return PopScope(
      onPopInvoked: (v) => searchCtrl().clear(),
      child: Dialog(
        elevation: 0,
        alignment: Alignment.topCenter + const Alignment(0, 0.3),
        backgroundColor: Colors.transparent,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.onMobile ? 0 : 100,
                ),
                child: TextField(
                  focusNode: searchFocus,
                  controller: searchTextCtrl,
                  textInputAction: TextInputAction.go,
                  onSubmitted: (value) => searchProduct(),
                  onChanged: (value) =>
                      searchCtrl().search(searchTextCtrl.text),
                  cursorColor: context.colorTheme.surfaceVariant,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: defaultRadius,
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: context.colorTheme.surface.withOpacity(0.8),
                    suffixIcon: IconButton(
                      onPressed: () => searchProduct(),
                      icon: Icon(
                        Icons.search_outlined,
                        color: context.colorTheme.onBackground,
                      ),
                    ),
                    hintText: Translator.searchForProduct(context),
                    hintStyle: context.textTheme.titleSmall?.copyWith(
                      color: context.colorTheme.onSurface.withOpacity(0.8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              searchTerms.when(
                error: ErrorView.errorMethod,
                loading: () => const Center(child: CircularProgressIndicator()),
                data: (terms) => Wrap(
                  children: [
                    ...terms.map(
                      (e) => Padding(
                        padding: const EdgeInsets.all(2),
                        child: ClipRect(
                          child: BackdropFilter(
                            filter:
                                ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: defaultRadius,
                                color:
                                    context.colorTheme.outline.withOpacity(0.8),
                              ),
                              child: InkWell(
                                onTap: () {
                                  searchTextCtrl.text = e;
                                  searchCtrl().search(searchTextCtrl.text);
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 8,
                                      ),
                                      child: Text(
                                        e,
                                        style: context.textTheme.titleMedium,
                                      ),
                                    ),
                                    Container(
                                      height: 20,
                                      width: 20,
                                      margin: const EdgeInsets.only(right: 8),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: context
                                            .colorTheme.secondaryContainer
                                            .withOpacity(0.2),
                                      ),
                                      child: IconButton(
                                        style:
                                            IconButton.styleFrom(iconSize: 15),
                                        padding: const EdgeInsets.all(0),
                                        onPressed: () =>
                                            termCtrl().removeTerm(e),
                                        icon: const Icon(Icons.clear_rounded),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              searchedItems.when(
                error: ErrorView.errorMethod,
                loading: () => const Center(child: CircularProgressIndicator()),
                data: (products) {
                  if (products.isEmpty) return const SizedBox.shrink();

                  final length = products.takeFirst(5).length;
                  return SingleChildScrollView(
                    physics: defaultScrollPhysics,
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: defaultRadius,
                            color: context.colorTheme.outline.withOpacity(0.8),
                          ),
                          child: ListView.builder(
                            physics: defaultScrollPhysics,
                            shrinkWrap: true,
                            itemCount: length + 1,
                            itemBuilder: (context, index) {
                              if (index == length) {
                                return Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: IconButton.filled(
                                    style: IconButton.styleFrom(
                                        iconSize: 20,
                                        shape: const CircleBorder(),
                                        backgroundColor:
                                            context.colorTheme.primary),
                                    onPressed: () => searchProduct(),
                                    icon: const Icon(
                                        Icons.arrow_forward_ios_rounded),
                                  ),
                                );
                              }
                              return ListTile(
                                onTap: () => RouteNames.productDetails.goNamed(
                                  context,
                                  pathParams: {'id': products[index].uid},
                                  query: {'isRegular': 'true'},
                                ),
                                leading: HostedImage(
                                  products[index].featuredImage,
                                  height: 40,
                                  width: 40,
                                ),
                                title: Text(products[index].name),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
