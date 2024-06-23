import 'package:e_com/core/core.dart';
import 'package:flutter/material.dart';

class KChip extends StatelessWidget {
  const KChip({
    super.key,
    required this.text,
    required this.onTap,
    this.color,
    required this.borderColor,
    required this.borderWight,
    this.textColor,
  });

  final String text;
  final double borderWight;
  final Function() onTap;
  final Color? color;
  final Color borderColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: borderWight, color: borderColor),
        borderRadius: BorderRadius.circular(100),
        color: color,
      ),
      child: Center(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
            child: Text(
              text,
              style: context.textTheme.titleLarge!.copyWith(
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
