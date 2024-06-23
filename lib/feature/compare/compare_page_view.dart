import 'package:e_com/core/core.dart';
import 'package:e_com/widgets/buttons/circle_button.dart';
import 'package:e_com/widgets/buttons/square_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ComparePageView extends ConsumerWidget {
  const ComparePageView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 140),
        child: Column(
          children: [
            const SizedBox(height: 25),
            Row(
              children: [
                SquareButton.backButton(
                  onPressed: () => context.pop(),
                ),
                const SizedBox(width: 50),
                Text(
                  "Compare Product",
                  style: context.textTheme.titleLarge,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Search for products...',
                  suffixIcon: Icon(Icons.search),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: defaultPadding,
        child: SingleChildScrollView(
          physics: defaultScrollPhysics,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.green,
                              ),
                            ),
                            Positioned(
                              right: -10,
                              top: 5,
                              child: CircularButton.filled(
                                fillColor: context.colorTheme.primary,
                                border: Border.all(
                                  color: Colors.transparent,
                                ),
                                height: 20,
                                padding: EdgeInsets.zero,
                                onPressed: () {},
                                icon: Icon(
                                  Icons.close,
                                  size: 10,
                                  color: context.colorTheme.secondary,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Apple MacBook Air',
                          style: context.textTheme.titleLarge,
                        ),
                        Text(
                          'Apple M1 chip',
                          style: context.textTheme.bodyLarge,
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.blue,
                              ),
                            ),
                            Positioned(
                              right: -10,
                              top: 5,
                              child: CircularButton.filled(
                                fillColor: context.colorTheme.primary,
                                border: Border.all(color: Colors.transparent),
                                height: 20,
                                padding: EdgeInsets.zero,
                                onPressed: () {},
                                icon: Icon(
                                  Icons.close,
                                  size: 10,
                                  color: context.colorTheme.secondary,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Microsoft Surface',
                          style: context.textTheme.titleLarge,
                        ),
                        Text(
                          '2022 New Edition',
                          style: context.textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              const Column(
                children: [
                  CompareCard(
                    productDetails1: '1099',
                    description: 'Price',
                    productDetails2: '799',
                  ),
                  SizedBox(height: 10),
                  CompareCard(
                    productDetails1: 'MacBook Air MGN73',
                    description: 'Model',
                    productDetails2: 'Surface Laptop Go',
                  ),
                  SizedBox(height: 10),
                  CompareCard(
                    productDetails1:
                        'Apple M1 chip 8GB RAM 512GB SSD 13.3-inch 2560x1600 LED-backlit Retina Display',
                    description: 'Details',
                    productDetails2:
                        'Intel i5-1035G1 8GB RAM 128GB SSD 12.4" Pixelsense (1536x1024) Multi-Touch Display',
                  ),
                  SizedBox(height: 10),
                  CompareCard(
                    productDetails1: 'Mac OS',
                    description: 'Operating System',
                    productDetails2: 'Windows 11',
                  ),
                  SizedBox(height: 10),
                  CompareCard(
                    productDetails1: 'Space Gray',
                    description: 'Color',
                    productDetails2: 'Platinum Silver',
                  ),
                  SizedBox(height: 10),
                  CompareCard(
                    productDetails1: '1.29 kg',
                    description: 'Weight',
                    productDetails2: '1.1 kg',
                  ),
                  SizedBox(height: 10),
                  CompareCard(
                    productDetails1: '01 year (Limited) ',
                    description: 'Warranty',
                    productDetails2: '01 year (hardware) ',
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CompareCard extends StatelessWidget {
  const CompareCard({
    super.key,
    required this.productDetails1,
    required this.description,
    required this.productDetails2,
  });
  final String productDetails1;
  final String description;
  final String productDetails2;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.070),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 5,
              child: Center(
                child: Text(
                  productDetails1,
                  style: context.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Center(
                child: Text(
                  description,
                  style: context.textTheme.bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Center(
                child: Text(
                  productDetails2,
                  style: context.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
