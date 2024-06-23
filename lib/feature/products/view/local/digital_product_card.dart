// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:e_com/core/core.dart';
import 'package:e_com/feature/region_settings/provider/region_provider.dart';
import 'package:e_com/models/models.dart';
import 'package:e_com/routes/routes.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DigitalProductCard extends ConsumerWidget {
  const DigitalProductCard({
    super.key,
    required this.product,
    this.height = 160,
    this.width = 200,
  });

  final DigitalProduct product;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final local = ref.watch(localeCurrencyStateProvider);

    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: defaultRadius,
        color: context.colorTheme.surface,
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            color: context.colorTheme.primaryContainer
                .withOpacity(context.isDark ? 0.3 : 0.04),
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          RouteNames.productDetails.pushNamed(
            context,
            pathParams: {'id': product.uid},
            query: {'isRegular': 'false'},
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: defaultRadiusOnlyTop,
              child: HostedImage(
                height: height,
                width: double.infinity,
                product.featuredImage,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name.showUntil(38),
                    style: context.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 5),
                  Wrap(
                    children: [
                      Text(
                        product.price.fromLocal(local),
                        style: context.textTheme.titleSmall!
                            .copyWith(color: context.colorTheme.error),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
