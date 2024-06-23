import 'package:e_com/core/core.dart';
import 'package:e_com/feature/settings/provider/settings_provider.dart';
import 'package:e_com/themes/colors_scheme.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final appThemeProvider = Provider.autoDispose<AppTheme>((ref) {
  final config = ref.watch(settingsProvider.select((value) => value?.settings));

  return AppTheme(config?.primaryColor, config?.secondaryColor);
});

class AppTheme {
  AppTheme(this.primaryColor, this.secondaryColor);

  final Color? primaryColor;
  final Color? secondaryColor;

  ThemeData theme(bool isLight) => _mainTheme(isLight).copyWith(
        snackBarTheme: _snackBarTheme(isLight),
        filledButtonTheme: _filledButtonTheme(isLight),
      );

  FilledButtonThemeData _filledButtonTheme(bool isLight) {
    return FilledButtonThemeData(
      style: _mainTheme(isLight).filledButtonTheme.style?.copyWith(
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.isDisabled) {
            return _color(isLight).onSurface.withOpacity(0.2);
          }
          return null;
        }),
        foregroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.isDisabled) {
            return _color(isLight).onSurface.withOpacity(0.5);
          }
          return null;
        }),
      ),
    );
  }

  SnackBarThemeData _snackBarTheme(bool isLight) {
    return SnackBarThemeData(
      backgroundColor:
          isLight ? const Color(0xFFF3FFFE) : const Color(0xFF061C1B),
      actionTextColor: _color(isLight).onSurface,
    );
  }

  ThemeData _mainTheme(bool isLight) {
    final flex = _ThemeFlex(primaryColor, secondaryColor);
    return isLight ? flex.lightTheme : flex.darkTheme;
  }

  ColorScheme _color(bool isLight) =>
      IGenColorScheme.scheme(isLight, primaryColor, secondaryColor);
}

class _ThemeFlex {
  _ThemeFlex(this.primaryColor, this.secondaryColor);

  final Color? primaryColor;
  final Color? secondaryColor;

  int _blendLvl(bool isLight) => isLight ? 4 : 7;
  String? _fontFamily() => GoogleFonts.notoSans().fontFamily;

  static FlexSubThemesData _subTheme(bool isLight) {
    return FlexSubThemesData(
      blendOnLevel: isLight ? 10 : 20,
      blendOnColors: isLight ? false : true,
      useTextTheme: true,
      useM2StyleDividerInM3: true,
      thinBorderWidth: 0.5,
      splashType: FlexSplashType.inkSparkle,
      defaultRadius: Corners.med,
      sliderValueTinted: true,
      sliderTrackHeight: 3,
      inputDecoratorIsFilled: false,
      inputDecoratorUnfocusedBorderIsColored: false,
      fabUseShape: true,
      chipRadius: Corners.med,
      popupMenuElevation: 2.0,
      alignedDropdown: true,
      useInputDecoratorThemeInDialogs: true,
      tabBarIndicatorWeight: 2,
      tabBarDividerColor: const Color(0x00000000),
      drawerIndicatorSchemeColor: SchemeColor.primary,
      drawerIndicatorOpacity: 0.2,
      drawerSelectedItemSchemeColor: SchemeColor.primary,
      bottomNavigationBarElevation: 2.0,
      bottomNavigationBarShowUnselectedLabels: false,
      navigationBarLabelBehavior:
          NavigationDestinationLabelBehavior.onlyShowSelected,
    );
  }

  ThemeData get lightTheme => FlexThemeData.light(
        colorScheme: IGenColorScheme.scheme(true, primaryColor, secondaryColor),
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: _blendLvl(false),
        bottomAppBarElevation: 1.0,
        tooltipsMatchBackground: true,
        subThemesData: _subTheme(false),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        swapLegacyOnMaterial3: true,
        fontFamily: _fontFamily(),
        textTheme: textTheme,
      );

  ThemeData get darkTheme => FlexThemeData.dark(
        colorScheme:
            IGenColorScheme.scheme(false, primaryColor, secondaryColor),
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: _blendLvl(true),
        bottomAppBarElevation: 1.0,
        tooltipsMatchBackground: true,
        subThemesData: _subTheme(true),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        swapLegacyOnMaterial3: true,
        textTheme: textTheme,
      );

  static final TextStyle _primaryFont = GoogleFonts.getFont('Rubik');
  static final TextStyle _secondaryFont = GoogleFonts.getFont('Roboto');

  static TextTheme textTheme = TextTheme(
    displayLarge: _primaryFont.copyWith(
      fontSize: 98,
      fontWeight: FontWeight.w300,
      letterSpacing: -1.5,
    ),
    displayMedium: _primaryFont.copyWith(
      fontSize: 61,
      fontWeight: FontWeight.w300,
      letterSpacing: -0.5,
    ),
    displaySmall: _primaryFont.copyWith(
      fontSize: 49,
      fontWeight: FontWeight.w400,
    ),
    headlineMedium: _primaryFont.copyWith(
      fontSize: 35,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
    ),
    headlineSmall: _primaryFont.copyWith(
      fontSize: 24,
      fontWeight: FontWeight.w400,
    ),
    titleLarge: _primaryFont.copyWith(
      fontSize: 19,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
    ),
    titleMedium: _primaryFont.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.15,
    ),
    titleSmall: _primaryFont.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
    ),
    bodyLarge: _secondaryFont.copyWith(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
    ),
    bodyMedium: _secondaryFont.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
    ),
    labelLarge: _primaryFont.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.25,
    ),
    bodySmall: _secondaryFont.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
    ),
    labelSmall: _secondaryFont.copyWith(
      fontSize: 10,
      fontWeight: FontWeight.w400,
      letterSpacing: 1.5,
    ),
  );
}
