import 'package:flutter/material.dart';

class SpacedText extends StatelessWidget {
  const SpacedText({
    super.key,
    required this.leftText,
    required this.rightText,
    this.rightAction,
    TextStyle? style,
  })  : styleRight = style,
        styleLeft = style;

  const SpacedText.diffStyle({
    super.key,
    required this.leftText,
    required this.rightText,
    this.rightAction,
    this.styleRight,
    this.styleLeft,
  });

  final String leftText;
  final String rightText;
  final Widget? rightAction;
  final TextStyle? styleRight;
  final TextStyle? styleLeft;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(leftText, style: styleLeft),
        const Spacer(),
        Text(rightText, style: styleRight),
        rightAction ?? const SizedBox.shrink(),
      ],
    );
  }
}
