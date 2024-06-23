import 'package:e_com/core/core.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class KShimmer extends StatelessWidget {
  const KShimmer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(0),
  });

  KShimmer.card({
    super.key,
    double? height = 200,
    double? width,
    this.padding = const EdgeInsets.all(0),
  }) : child = SizedBox(height: height, width: width);

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: ClipRRect(
        borderRadius: Corners.smBorder,
        child: Shimmer(
          color: context.colorTheme.secondary,
          colorOpacity: .2,
          duration: const Duration(milliseconds: 1500),
          child: Container(color: context.colorTheme.surface, child: child),
        ),
      ),
    );
  }
}
