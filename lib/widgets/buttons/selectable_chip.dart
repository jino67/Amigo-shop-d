import 'package:e_com/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SelectableChip extends StatelessWidget {
  const SelectableChip({
    super.key,
    this.onTap,
    this.isSelected = false,
    required this.child,
    this.color,
    this.overlayColor,
    this.overlayIconColor,
    this.width,
    this.height,
    this.borderRadius,
  });

  final Function()? onTap;
  final bool isSelected;
  final Widget child;
  final Color? color;
  final Color? overlayColor;
  final Color? overlayIconColor;
  final double? height;
  final double? width;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(2),
      child: CustomPaint(
        painter: CornerPainter(
          isSelected,
          overlayColor ?? context.colorTheme.secondaryContainer,
          overlayIconColor ?? context.colorTheme.onSecondaryContainer,
        ),
        child: InkWell(
          onTap: onTap,
          child: AnimatedContainer(
            curve: Curves.easeInCubic,
            duration: 150.ms,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: context.colorTheme.secondaryContainer.withOpacity(.05),
              border: isSelected
                  ? Border.all(color: context.colorTheme.secondaryContainer)
                  : null,
            ),
            height: height,
            width: width,
            child: child,
          ),
        ),
      ),
    );
  }
}

class CornerPainter extends CustomPainter {
  CornerPainter(this.show, this.overlayColor, this.overlayIconColor);

  final bool show;
  final Color overlayColor;
  final Color overlayIconColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (!show) return;
    final height = size.height;
    final width = size.width;
    double widthOffset = 1;

    final paint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill;

    Path path = Path()
      ..moveTo(width * .5, height)
      ..lineTo(width, height)
      ..lineTo(width, height * .5)
      ..close();

    const icon = Icons.check_rounded;
    TextPainter tp = TextPainter(textDirection: TextDirection.ltr)
      ..text = TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(color: overlayIconColor, fontFamily: icon.fontFamily),
      );
    tp.layout();
    if (width > 55) widthOffset = .95;

    Offset iconOffset =
        Offset(width * widthOffset - tp.width, height * .95 - tp.height);

    canvas.drawPath(path, paint);
    tp.paint(canvas, iconOffset);
  }

  @override
  bool shouldRebuildSemantics(CornerPainter oldDelegate) => false;

  @override
  bool shouldRepaint(CornerPainter oldDelegate) => oldDelegate.show != show;
}
