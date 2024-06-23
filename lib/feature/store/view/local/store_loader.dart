import 'package:e_com/core/core.dart';
import 'package:e_com/widgets/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class StoreLoading extends StatelessWidget {
  const StoreLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  KShimmer.card(
                    height: 80,
                    width: double.infinity,
                  ),
                  Positioned(
                    left: 10,
                    bottom: -50,
                    child: Row(
                      children: [
                        KShimmer.card(
                          height: 80,
                          width: 80,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            KShimmer.card(
                              height: 30,
                              width: context.width / 1.5,
                            ),
                            const SizedBox(height: 10),
                            KShimmer.card(
                              height: 30,
                              width: context.width / 3,
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 70),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    KShimmer.card(
                      height: 30,
                      width: context.width,
                    ),
                    const SizedBox(height: 5),
                    KShimmer.card(
                      height: 30,
                      width: context.width,
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        KShimmer.card(
                          height: 45,
                          width: 100,
                        ),
                        const SizedBox(width: 10),
                        KShimmer.card(
                          height: 45,
                          width: 100,
                        ),
                        const Spacer(),
                        KShimmer.card(
                          height: 45,
                          width: 100,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  KShimmer.card(
                    height: 30,
                    width: 120,
                  ),
                  const SizedBox(width: 10),
                  KShimmer.card(
                    height: 30,
                    width: 120,
                  ),
                  const Spacer(),
                  KShimmer.card(
                    height: 40,
                    width: 40,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              MasonryGridView.builder(
                shrinkWrap: true,
                itemCount: 6,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                gridDelegate:
                    const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemBuilder: (context, index) {
                  return KShimmer(
                    child: KShimmer.card(
                      height: 250,
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
