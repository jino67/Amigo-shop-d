import 'package:e_com/core/core.dart';
import 'package:flutter/material.dart';

MaterialStateProperty<T> materialStateProp<T>({
  required T def,
  required T hovered,
  T? disabled,
}) {
  return MaterialStateProperty.resolveWith<T>(
    (states) {
      if (states.isHovered) return hovered;
      if (states.isFocused) return hovered;
      if (disabled != null && states.isDisabled) return disabled;

      return def;
    },
  );
}
