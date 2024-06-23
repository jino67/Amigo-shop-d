import 'package:e_com/core/core.dart';
import 'package:e_com/feature/store/providers/store_providers.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'local/store_product_card.dart';

class AllStoreView extends ConsumerWidget {
  const AllStoreView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storeList = ref.watch(storeListProvider);

    if (storeList == null) {
      return ErrorView.withScaffold('Something went wrong');
    }

    return Scaffold(
      appBar: KAppBar(
        leading: SquareButton.backButton(
          onPressed: () => context.pop(),
        ),
        title: Text(Translator.store(context)),
      ),
      body: Padding(
        padding: defaultPadding.copyWith(top: 10),
        child: RefreshIndicator(
          onRefresh: () async {
            return ref.refresh(storeListProvider);
          },
          child: MasonryGridView.builder(
            shrinkWrap: true,
            physics: defaultScrollPhysics,
            gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: context.onMobile ? 2 : 3,
            ),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            clipBehavior: Clip.none,
            itemCount: storeList.listData.length,
            itemBuilder: (BuildContext context, int index) {
              return StoreProductCard(
                store: storeList.listData[index],
                direction: Axis.vertical,
              );
            },
          ),
        ),
      ),
    );
  }
}
