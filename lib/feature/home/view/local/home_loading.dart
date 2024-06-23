import 'package:e_com/core/core.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';

class HomePageLoading extends StatelessWidget {
  const HomePageLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        KShimmer.card(
            height: context.onMobile ? 150 : 300, width: double.infinity),
        const SizedBox(height: 5),
        KShimmer.card(height: 30, width: 200),
        const SizedBox(height: 5),
        Row(
          children: [
            Expanded(
              child: KShimmer.card(height: 60),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: KShimmer.card(height: 60),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Expanded(
              child: KShimmer.card(height: 60),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: KShimmer.card(height: 60),
            ),
          ],
        ),
        const SizedBox(height: 5),
        KShimmer.card(height: 100, width: double.infinity),
        const SizedBox(height: 5),
        KShimmer(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Expanded(child: KShimmer.card(height: 50)),
                    const SizedBox(width: 5),
                    Expanded(child: KShimmer.card(height: 50)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: context.onMobile ? 3 : 5,
                    mainAxisSpacing: 3,
                    crossAxisSpacing: 3,
                  ),
                  itemCount: context.onMobile ? 3 : 5,
                  itemBuilder: (context, index) => KShimmer.card(height: 50),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        KShimmer.card(height: 100, width: double.infinity),
        const SizedBox(height: 5),
        KShimmer.card(height: 100, width: double.infinity),
      ],
    );
  }
}
