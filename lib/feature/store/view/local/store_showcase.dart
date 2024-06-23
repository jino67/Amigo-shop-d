import 'package:e_com/core/core.dart';
import 'package:e_com/feature/store/view/local/store_product_card.dart';
import 'package:e_com/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StoreShowcase extends ConsumerWidget {
  const StoreShowcase(this.storeList, {super.key});

  final List<StoreModel> storeList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 150,
      child: MasonryGridView.builder(
        shrinkWrap: true,
        physics: defaultScrollPhysics,
        gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
        ),
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        clipBehavior: Clip.none,
        scrollDirection: Axis.horizontal,
        itemCount: storeList.length,
        itemBuilder: (BuildContext context, int index) {
          return StoreProductCard(store: storeList[index]);
        },
      ),
    );
  }
}
