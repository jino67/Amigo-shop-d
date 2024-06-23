import 'package:e_com/core/core.dart';
import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.icon,
    this.height,
    this.width,
    this.padding,
    this.style,
  });

  final Function()? onPressed;

  final Widget child;
  final Widget? icon;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final ButtonStyle? style;
  final bool isLoading;

  FilledButton _button(BuildContext context, ButtonStyle style) => icon != null
      ? FilledButton.icon(
          style: style,
          onPressed: onPressed == null ? null : () => onPressed?.call(),
          label: child,
          icon: isLoading ? _loading(context) : icon!,
        )
      : FilledButton(
          style: style,
          onPressed: onPressed == null ? null : () => onPressed?.call(),
          child: isLoading ? _loading(context) : child,
        );

  Widget _loading(BuildContext context) => SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          color: context.colorTheme.onPrimary,
        ),
      );

  @override
  Widget build(BuildContext context) {
    ButtonStyle buttonStyle = FilledButton.styleFrom(
      fixedSize: Size(width ?? context.width, height ?? 40),
    );

    if (style != null) {
      buttonStyle = style!.copyWith(
        fixedSize: MaterialStatePropertyAll(
          Size(width ?? context.width, height ?? 40),
        ),
      );
    }
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: _button(context, buttonStyle),
    );
  }
}
