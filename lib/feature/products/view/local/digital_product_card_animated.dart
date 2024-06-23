import 'package:e_com/core/core.dart';
import 'package:e_com/feature/region_settings/provider/region_provider.dart';
import 'package:e_com/models/content/digital_product_models.dart';
import 'package:e_com/routes/go_route_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../widgets/widgets.dart';

class DigitalProductCardAnimated extends StatefulHookConsumerWidget {
  const DigitalProductCardAnimated({
    super.key,
    required this.product,
    this.height = 160,
    this.width = 200,
    this.useAnimation = true,
    this.isExpanded = false,
    required this.onButtonTap,
  });

  final bool useAnimation;
  final bool isExpanded;
  final DigitalProduct product;
  final double height;
  final double width;
  final Function() onButtonTap;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DigitalProductAnimationCardState();
}

class _DigitalProductAnimationCardState
    extends ConsumerState<DigitalProductCardAnimated> {
  @override
  void initState() {
    super.initState();
    isExpanded = widget.isExpanded;
  }

  @override
  void didUpdateWidget(covariant DigitalProductCardAnimated oldWidget) {
    super.didUpdateWidget(oldWidget);
    isExpanded = widget.isExpanded;
  }

  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (widget.useAnimation)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            bottom: isExpanded ? 30 : 50,
            width: isExpanded ? 270 : 250,
            height: isExpanded ? 320 : 300,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: defaultRadius,
                color: context.colorTheme.primary.withOpacity(0.1),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: FilledButton(
                        onPressed: widget.onButtonTap,
                        child: Text(
                          Translator.buyNow(context),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        AnimatedPositioned(
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 400),
          bottom: isExpanded ? 100 : 50,
          child: GestureDetector(
            child: _ForegroundCard(
              isExpanded: widget.useAnimation ? isExpanded : null,
              product: widget.product,
              height: widget.height,
              onButtonTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _ForegroundCard extends ConsumerWidget {
  const _ForegroundCard({
    required this.onButtonTap,
    required this.product,
    required this.isExpanded,
    required this.height,
  });

  final DigitalProduct product;
  final Function() onButtonTap;
  final bool? isExpanded;
  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final local = ref.watch(localeCurrencyStateProvider);

    return Stack(
      children: [
        Column(
          children: [
            Container(
              width: 250,
              height: 300,
              decoration: BoxDecoration(
                borderRadius: defaultRadius,
                color: context.colorTheme.surface,
                boxShadow: [
                  BoxShadow(
                    blurRadius: context.isLight ? 10 : 2,
                    color: context.isLight
                        ? const Color.fromARGB(218, 228, 228, 228)
                        : context.colorTheme.secondaryContainer
                            .withOpacity(0.2),
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
                    SizedBox(
                      height: height,
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: defaultRadiusOnlyTop,
                        child: HostedImage(
                          product.featuredImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: context.textTheme.bodyLarge,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            product.price.fromLocal(local),
                            style: context.textTheme.titleSmall!
                                .copyWith(color: context.colorTheme.error),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (isExpanded != null)
          Positioned(
            bottom: 10,
            right: 10,
            child: GestureDetector(
              onTap: onButtonTap,
              child: CircleAvatar(
                backgroundColor: context.colorTheme.secondary,
                child: const Icon(
                  Icons.arrow_upward_rounded,
                ),
              )
                  .animate(target: isExpanded! ? .5 : 0)
                  .rotate(curve: Curves.easeInOut, duration: 700.ms),
            ),
          )
      ],
    );
  }
}
