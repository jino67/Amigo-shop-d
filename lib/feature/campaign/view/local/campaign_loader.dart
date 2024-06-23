import 'package:e_com/core/strings/app_const.dart';
import 'package:e_com/widgets/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class CampaignLoader extends StatelessWidget {
  const CampaignLoader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        KShimmer.card(
          height: 100,
          width: double.infinity,
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: KShimmer(
                child: Padding(
                  padding: defaultPaddingAll,
                  child: SizedBox(
                    height: 100,
                    width: double.infinity,
                    child: MasonryGridView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: 4,
                      mainAxisSpacing: 10,
                      gridDelegate:
                          const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1),
                      itemBuilder: (context, index) =>
                          KShimmer.card(height: 50, width: 80),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20)
      ],
    );
  }
}
