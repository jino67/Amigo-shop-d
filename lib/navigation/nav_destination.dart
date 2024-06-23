import 'package:flutter/material.dart';

class KNavDestination {
  KNavDestination({
    required this.text,
    required this.icon,
    required this.selectedIcon,
    this.focused = false,
    this.isDrawerButton = false,
  });

  final bool focused;
  final IconData icon;
  final bool isDrawerButton;
  final IconData selectedIcon;
  final String text;
}
