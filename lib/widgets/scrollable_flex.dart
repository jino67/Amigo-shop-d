import 'package:flutter/material.dart';

class ScrollableFlex extends StatelessWidget {
  const ScrollableFlex({
    super.key,
    required this.children,
    this.clipBehavior = Clip.hardEdge,
  });

  final List<Widget> children;
  final Axis scrollDirection = Axis.horizontal;
  final Clip clipBehavior;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: scrollDirection,
      clipBehavior: clipBehavior,
      child: Row(children: children),
    );
  }
}
