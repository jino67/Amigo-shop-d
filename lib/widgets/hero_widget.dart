import 'package:flutter/material.dart';

class HeroWidget extends StatelessWidget {
  const HeroWidget({
    required this.child,
    required this.tag,
    this.debug = false,
    super.key,
  });

  final Widget child;
  final String tag;
  final bool debug;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: Material(
        type: MaterialType.transparency,
        child: child,
      ),
    );
  }
}
