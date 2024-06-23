import 'dart:math' as m;

import 'package:e_com/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'local.dart';

class ProductDesc extends StatelessWidget {
  const ProductDesc({
    super.key,
    required this.relatedProduct,
    required this.isRegular,
    required this.description,
  });

  final String description;
  final List relatedProduct;
  final bool isRegular;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colorTheme.secondaryContainer.withOpacity(0.01),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        clipBehavior: Clip.none,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Html(
                data: description.replaceAll('<br>', ''),
                onLinkTap: (url, attributes, element) =>
                    url != null ? URLHelper.url(url) : null,
                style: {
                  "*": Style(
                    fontSize: FontSize(16),
                    lineHeight: const LineHeight(1.3),
                    fontWeight: FontWeight.w400,
                    color: context.colorTheme.onSurface,
                    backgroundColor: context.colorTheme.surface,
                  ),
                },
              ),
              const SizedBox(height: 30),
              Text(
                Translator.relatedProduct(context),
                style: context.textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              MasonryGridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: context.onMobile ? 2 : 3,
                ),
                clipBehavior: Clip.none,
                itemCount: relatedProduct.length,
                itemBuilder: (context, index) {
                  final relatedData = relatedProduct[index];
                  return isRegular
                      ? Padding(
                          padding: const EdgeInsets.all(5),
                          child: ProductCard(
                            product: relatedData,
                            // to stop hero animation when pushing to related product
                            type: 'related${m.Random().nextInt(300)}',
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(5),
                          child: DigitalProductCard(product: relatedData),
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
