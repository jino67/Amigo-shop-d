import 'package:e_com/core/core.dart';
import 'package:flutter/material.dart';

class DottedBorderPainter extends CustomPainter {
  final BuildContext context;

  DottedBorderPainter(this.context);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = context.colorTheme.outline
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    /// Width of each dash
    const double dashWidth = 12;

    /// Space between each dash
    const double dashSpace = 8;

    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }

    /// Draw right border
    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width, startY),
        Offset(size.width, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }

    /// Draw bottom border
    startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height),
        Offset(startX + dashWidth, size.height),
        paint,
      );
      startX += dashWidth + dashSpace;
    }

    /// Draw left border
    startY = 0;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashWidth), paint);
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
