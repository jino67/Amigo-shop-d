import 'package:e_com/core/core.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

class CategoriesProductLoading extends StatelessWidget {
  const CategoriesProductLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KAppBar(
        leading: SquareButton.backButton(
          onPressed: () => context.pop(),
        ),
        title: Text(Translator.products(context)),
      ),
      body: Padding(
        padding: defaultPadding.copyWith(top: 10),
        child: MasonryGridView.builder(
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          itemCount: 10,
          gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemBuilder: (context, index) {
            return KShimmer.card(height: 200);
          },
        ),
      ),
    );
  }
}
