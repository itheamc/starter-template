import "package:flutter/material.dart";

/// Generate material 3 color scheme [_lightScheme] and [_darkScheme] as per your primary color
/// using this website: https://material-foundation.github.io/material-theme-builder/
///
class AppTheme {
  static ColorScheme _lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff770562),
      surfaceTint: Color(0xff9f3184),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffa33588),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff814e6f),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffffc7e8),
      onSecondaryContainer: Color(0xff5f3151),
      tertiary: Color(0xff7f0e1d),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffb0353c),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      surface: Color(0xfffff8f9),
      onSurface: Color(0xff22191e),
      onSurfaceVariant: Color(0xff53424c),
      outline: Color(0xff86727c),
      outlineVariant: Color(0xffd8c0cc),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff382d33),
      inversePrimary: Color(0xffffade1),
      primaryFixed: Color(0xffffd8ed),
      onPrimaryFixed: Color(0xff3b002f),
      primaryFixedDim: Color(0xffffade1),
      onPrimaryFixedVariant: Color(0xff81146b),
      secondaryFixed: Color(0xffffd8ed),
      onSecondaryFixed: Color(0xff340b29),
      secondaryFixedDim: Color(0xfff3b4da),
      onSecondaryFixedVariant: Color(0xff663757),
      tertiaryFixed: Color(0xffffdad8),
      onTertiaryFixed: Color(0xff410007),
      tertiaryFixedDim: Color(0xffffb3b1),
      onTertiaryFixedVariant: Color(0xff8a1824),
      surfaceDim: Color(0xffe7d6dd),
      surfaceBright: Color(0xfffff8f9),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffff0f6),
      surfaceContainer: Color(0xfffbe9f1),
      surfaceContainerHigh: Color(0xfff5e4eb),
      surfaceContainerHighest: Color(0xffefdee6),
    );
  }

  static ColorScheme _lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff770562),
      surfaceTint: Color(0xff9f3184),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffa33588),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff623353),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff996486),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff7f0e1d),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffb0353c),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff8c0009),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffda342e),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff8f9),
      onSurface: Color(0xff22191e),
      onSurfaceVariant: Color(0xff4f3e48),
      outline: Color(0xff6c5a64),
      outlineVariant: Color(0xff897580),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff382d33),
      inversePrimary: Color(0xffffade1),
      primaryFixed: Color(0xffba499c),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff9c2e82),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff996486),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff7e4c6d),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xffc9484d),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xffa82f37),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffe7d6dd),
      surfaceBright: Color(0xfffff8f9),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffff0f6),
      surfaceContainer: Color(0xfffbe9f1),
      surfaceContainerHigh: Color(0xfff5e4eb),
      surfaceContainerHighest: Color(0xffefdee6),
    );
  }

  static ColorScheme _lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff460039),
      surfaceTint: Color(0xff9f3184),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff7c0d66),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff3c1231),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff623353),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff4d000b),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff851321),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff4e0002),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff8c0009),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff8f9),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff2e2028),
      outline: Color(0xff4f3e48),
      outlineVariant: Color(0xff4f3e48),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff382d33),
      inversePrimary: Color(0xffffe5f2),
      primaryFixed: Color(0xff7c0d66),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff590048),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff623353),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff481d3c),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff851321),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff610010),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffe7d6dd),
      surfaceBright: Color(0xfffff8f9),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffff0f6),
      surfaceContainer: Color(0xfffbe9f1),
      surfaceContainerHigh: Color(0xfff5e4eb),
      surfaceContainerHighest: Color(0xffefdee6),
    );
  }

  static ColorScheme _darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffade1),
      surfaceTint: Color(0xffffade1),
      onPrimary: Color(0xff5f004e),
      primaryContainer: Color(0xff86196e),
      onPrimaryContainer: Color(0xffffdcef),
      secondary: Color(0xfff3b4da),
      onSecondary: Color(0xff4c213f),
      secondaryContainer: Color(0xff5c2e4e),
      onSecondaryContainer: Color(0xffffbfe6),
      tertiary: Color(0xffffb3b1),
      onTertiary: Color(0xff680012),
      tertiaryContainer: Color(0xff901c27),
      onTertiaryContainer: Color(0xffffdfdd),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff191116),
      onSurface: Color(0xffefdee6),
      onSurfaceVariant: Color(0xffd8c0cc),
      outline: Color(0xffa08b96),
      outlineVariant: Color(0xff53424c),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffefdee6),
      inversePrimary: Color(0xff9f3184),
      primaryFixed: Color(0xffffd8ed),
      onPrimaryFixed: Color(0xff3b002f),
      primaryFixedDim: Color(0xffffade1),
      onPrimaryFixedVariant: Color(0xff81146b),
      secondaryFixed: Color(0xffffd8ed),
      onSecondaryFixed: Color(0xff340b29),
      secondaryFixedDim: Color(0xfff3b4da),
      onSecondaryFixedVariant: Color(0xff663757),
      tertiaryFixed: Color(0xffffdad8),
      onTertiaryFixed: Color(0xff410007),
      tertiaryFixedDim: Color(0xffffb3b1),
      onTertiaryFixedVariant: Color(0xff8a1824),
      surfaceDim: Color(0xff191116),
      surfaceBright: Color(0xff41363c),
      surfaceContainerLowest: Color(0xff140c11),
      surfaceContainerLow: Color(0xff22191e),
      surfaceContainer: Color(0xff261d22),
      surfaceContainerHigh: Color(0xff31272d),
      surfaceContainerHighest: Color(0xff3c3238),
    );
  }

  static ColorScheme _darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffb4e3),
      surfaceTint: Color(0xffffade1),
      onPrimary: Color(0xff310027),
      primaryContainer: Color(0xffdc65ba),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfff7b8df),
      onSecondary: Color(0xff2d0624),
      secondaryContainer: Color(0xffb87fa3),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffffb9b7),
      onTertiary: Color(0xff370005),
      tertiaryContainer: Color(0xffee6367),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffbab1),
      onError: Color(0xff370001),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff191116),
      onSurface: Color(0xfffff9f9),
      onSurfaceVariant: Color(0xffdcc4d0),
      outline: Color(0xffb39da8),
      outlineVariant: Color(0xff927d88),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffefdee6),
      inversePrimary: Color(0xff83156c),
      primaryFixed: Color(0xffffd8ed),
      onPrimaryFixed: Color(0xff280020),
      primaryFixedDim: Color(0xffffade1),
      onPrimaryFixedVariant: Color(0xff690056),
      secondaryFixed: Color(0xffffd8ed),
      onSecondaryFixed: Color(0xff27021e),
      secondaryFixedDim: Color(0xfff3b4da),
      onSecondaryFixedVariant: Color(0xff532746),
      tertiaryFixed: Color(0xffffdad8),
      onTertiaryFixed: Color(0xff2d0004),
      tertiaryFixedDim: Color(0xffffb3b1),
      onTertiaryFixedVariant: Color(0xff720215),
      surfaceDim: Color(0xff191116),
      surfaceBright: Color(0xff41363c),
      surfaceContainerLowest: Color(0xff140c11),
      surfaceContainerLow: Color(0xff22191e),
      surfaceContainer: Color(0xff261d22),
      surfaceContainerHigh: Color(0xff31272d),
      surfaceContainerHighest: Color(0xff3c3238),
    );
  }

  static ColorScheme _darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xfffff9f9),
      surfaceTint: Color(0xffffade1),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffffb4e3),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfffff9f9),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xfff7b8df),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfffff9f9),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffffb9b7),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xfffff9f9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffbab1),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff191116),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xfffff9f9),
      outline: Color(0xffdcc4d0),
      outlineVariant: Color(0xffdcc4d0),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffefdee6),
      inversePrimary: Color(0xff540044),
      primaryFixed: Color(0xffffdeef),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffffb4e3),
      onPrimaryFixedVariant: Color(0xff310027),
      secondaryFixed: Color(0xffffdeef),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xfff7b8df),
      onSecondaryFixedVariant: Color(0xff2d0624),
      tertiaryFixed: Color(0xffffe0de),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffffb9b7),
      onTertiaryFixedVariant: Color(0xff370005),
      surfaceDim: Color(0xff191116),
      surfaceBright: Color(0xff41363c),
      surfaceContainerLowest: Color(0xff140c11),
      surfaceContainerLow: Color(0xff22191e),
      surfaceContainer: Color(0xff261d22),
      surfaceContainerHigh: Color(0xff31272d),
      surfaceContainerHighest: Color(0xff3c3238),
    );
  }

  static ThemeData _theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: const TextTheme().apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
      );

  static ThemeData light() {
    return _theme(_lightScheme());
  }

  static ThemeData lightMediumContrast() {
    return _theme(_lightMediumContrastScheme());
  }

  static ThemeData lightHighContrast() {
    return _theme(_lightHighContrastScheme());
  }

  static ThemeData dark() {
    return _theme(_darkScheme());
  }

  static ThemeData darkMediumContrast() {
    return _theme(_darkMediumContrastScheme());
  }

  static ThemeData darkHighContrast() {
    return _theme(_darkHighContrastScheme());
  }
}


/// Extension functions [TextThemeExt] on TextTheme
///
/// Now you can use context.textTheme.regular12 and so on
///
/// TextThemeExt
extension TextThemeExt on TextTheme {
  // Private method to create regular text style
  TextStyle? _regular(double size) => TextStyle(
    fontSize: size,
    fontFamily: bodyLarge?.fontFamily,
    fontWeight: FontWeight.w400,
    color: bodyLarge?.color,
  );

  // Private method to create medium text style
  TextStyle? _medium(double size) => TextStyle(
    fontSize: size,
    fontFamily: bodyLarge?.fontFamily,
    fontWeight: FontWeight.w500,
    color: labelLarge?.color,
  );

  // Private method to create bold text style
  TextStyle? _semibold(double size) => TextStyle(
    fontSize: size,
    fontFamily: bodyLarge?.fontFamily,
    fontWeight: FontWeight.w600,
    color: titleLarge?.color,
  );

  // Private method to create bold text style
  TextStyle? _bold(double size) => TextStyle(
    fontSize: size,
    fontFamily: bodyLarge?.fontFamily,
    fontWeight: FontWeight.w700,
    color: titleLarge?.color,
  );

  // Regular Styles
  TextStyle? get regular8 => _regular(8.0);

  TextStyle? get regular10 => _regular(10.0);

  TextStyle? get regular12 => _regular(12.0);

  TextStyle? get regular14 => _regular(14.0);

  TextStyle? get regular16 => _regular(16.0);

  TextStyle? get regular18 => _regular(18.0);

  TextStyle? get regular20 => _regular(20.0);

  TextStyle? get regular22 => _regular(22.0);

  TextStyle? get regular24 => _regular(24.0);

  TextStyle? get regular28 => _regular(28.0);

  TextStyle? get regular32 => _regular(32.0);

  TextStyle? get regular36 => _regular(36.0);

  TextStyle? get regular42 => _regular(42.0);

  TextStyle? get regular48 => _regular(48.0);

  // Medium Styles
  TextStyle? get medium8 => _medium(8.0);

  TextStyle? get medium10 => _medium(10.0);

  TextStyle? get medium12 => _medium(12.0);

  TextStyle? get medium14 => _medium(14.0);

  TextStyle? get medium16 => _medium(16.0);

  TextStyle? get medium18 => _medium(18.0);

  TextStyle? get medium20 => _medium(20.0);

  TextStyle? get medium22 => _medium(22.0);

  TextStyle? get medium24 => _medium(24.0);

  TextStyle? get medium28 => _medium(28.0);

  TextStyle? get medium32 => _medium(32.0);

  TextStyle? get medium36 => _medium(36.0);

  TextStyle? get medium42 => _medium(42.0);

  TextStyle? get medium48 => _medium(48.0);

  // Semi-Bold Styles
  TextStyle? get semibold8 => _semibold(8.0);

  TextStyle? get semibold10 => _semibold(10.0);

  TextStyle? get semibold12 => _semibold(12.0);

  TextStyle? get semibold14 => _semibold(14.0);

  TextStyle? get semibold16 => _semibold(16.0);

  TextStyle? get semibold18 => _semibold(18.0);

  TextStyle? get semibold20 => _semibold(20.0);

  TextStyle? get semibold22 => _semibold(22.0);

  TextStyle? get semibold24 => _semibold(24.0);

  TextStyle? get semibold28 => _semibold(28.0);

  TextStyle? get semibold32 => _semibold(32.0);

  TextStyle? get semibold36 => _semibold(36.0);

  TextStyle? get semibold42 => _semibold(42.0);

  TextStyle? get semibold48 => _semibold(48.0);

  // Bold Styles
  TextStyle? get bold8 => _bold(8.0);

  TextStyle? get bold10 => _bold(10.0);

  TextStyle? get bold12 => _bold(12.0);

  TextStyle? get bold14 => _bold(14.0);

  TextStyle? get bold16 => _bold(16.0);

  TextStyle? get bold18 => _bold(18.0);

  TextStyle? get bold20 => _bold(20.0);

  TextStyle? get bold22 => _bold(22.0);

  TextStyle? get bold24 => _bold(24.0);

  TextStyle? get bold28 => _bold(28.0);

  TextStyle? get bold32 => _bold(32.0);

  TextStyle? get bold36 => _bold(36.0);

  TextStyle? get bold42 => _bold(42.0);

  TextStyle? get bold48 => _bold(48.0);
}