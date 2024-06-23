import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

class IGenColorScheme {
  const IGenColorScheme._();

  static Color? _calculateONColor(Color? color) {
    if (color == null) return null;
    return color.computeLuminance() > 0.5
        ? const Color(0xff14100e)
        : const Color(0xffffece7);
  }

  static ColorScheme scheme(bool isLight, [Color? primary, Color? secondary]) {
    final primaryColor = primary ?? const Color(0xfffea34c);
    final onPrimaryColor =
        _calculateONColor(primary) ?? const Color(0xff14100e);

    Color secondaryColor = secondary ?? const Color(0xff1f7f7b);

    if (secondaryColor.computeLuminance() < 0.5) {
      if (!isLight) {
        secondaryColor = secondaryColor.blend(Colors.white, 10);
      }
    }
    final onSecondaryColor =
        _calculateONColor(secondary) ?? const Color(0xff14100e);
    return ColorScheme(
      brightness: isLight ? Brightness.light : Brightness.dark,
      primary: primaryColor,
      onPrimary: onPrimaryColor,
      primaryContainer: secondaryColor,
      onPrimaryContainer: onSecondaryColor,
      secondary: secondaryColor,
      onSecondary: onSecondaryColor,
      secondaryContainer: secondaryColor,
      onSecondaryContainer: onSecondaryColor,
      tertiary: primaryColor,
      onTertiary: onPrimaryColor,
      tertiaryContainer: const Color(0xff94b291),
      onTertiaryContainer: const Color(0xff0d0f0c),
      error: isLight ? const Color(0xffb00020) : const Color(0xFFC0304B),
      onError: const Color(0xFFFFF0F3),
      errorContainer: const Color(0xFF009721),
      onErrorContainer: Colors.white,
      background: isLight ? const Color(0xFFFFFFFF) : const Color(0xFF000F0F),
      onBackground: isLight ? const Color(0xff090909) : const Color(0xffececec),
      surface: isLight ? const Color(0xFFFFFFFF) : const Color(0xFF021111),
      onSurface: isLight ? const Color(0xff090909) : const Color(0xffececec),
      outline: isLight ? const Color(0xFFBDBDBD) : const Color(0xff797979),
      outlineVariant:
          isLight ? const Color(0xFF595959) : const Color(0xFF5D5D5D),
      shadow: const Color(0xff000000),
      scrim: const Color(0xff000000),
      inverseSurface:
          isLight ? const Color(0xff090808) : const Color(0xFFFFFFFF),
      onInverseSurface:
          isLight ? const Color(0xffececec) : const Color(0xff090909),
      inversePrimary: primaryColor,
      surfaceTint: isLight ? const Color(0xffffffff) : const Color(0xff000000),
    );
  }
}
