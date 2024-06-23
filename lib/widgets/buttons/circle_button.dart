import 'package:e_com/core/core.dart';
import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  const CircularButton.filled({
    super.key,
    this.onPressed,
    required this.icon,
    this.border,
    this.margin,
    this.padding,
    this.splashRadius,
    this.iconSize,
    this.fillColor,
    this.iconColor,
    this.height,
    this.weight,
  });

  final Function()? onPressed;
  final BoxBorder? border;
  final Widget icon;
  final Color? fillColor;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? splashRadius;
  final double? iconSize;
  final Color? iconColor;
  final double? height;
  final double? weight;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: fillColor ?? context.colorTheme.onSecondary,
        shape: BoxShape.circle,
        border: border ?? Border.all(color: context.colorTheme.surface),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 10),
            blurRadius: 40,
            color: Color(0x11000000),
          ),
        ],
      ),
      child: Theme(
        data: ThemeData(
          iconTheme: IconThemeData(
            size: iconSize ?? 14,
            color: iconColor ?? context.colorTheme.onSecondary,
          ),
        ),
        child: IconButton(
          constraints: const BoxConstraints(),
          padding: padding ?? const EdgeInsets.all(8),
          splashRadius: splashRadius,
          onPressed: onPressed,
          icon: icon,
        ),
      ),
    );
  }
}
