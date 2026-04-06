import 'package:flutter/material.dart';

/// Light: icy cool whites + soft violet accents.
/// Dark: deep blue-violet shell + frosted lavender highlights (paired identity).
abstract final class AppTheme {
  // —— Light ——
  static const _icyBackground = Color(0xFFF2F4FC);
  static const _icySurface = Color(0xFFFAFBFF);
  static const _violet = Color(0xFF6B5DB8);
  static const _violetDeep = Color(0xFF453A7A);

  // —— Dark ——
  static const _nightBg = Color(0xFF0C0C12);
  static const _nightSurface = Color(0xFF14141E);
  static const _nightSurfaceHigh = Color(0xFF1C1C2A);
  static const _nightBorder = Color(0xFF2E2E42);
  /// Lighter lavender for controls & icons on dark ground.
  static const _frostPrimary = Color(0xFFCAB8FF);
  static const _frostOnPrimary = Color(0xFF1A1530);
  static const _frostContainer = Color(0xFF352D55);
  static const _frostOnContainer = Color(0xFFE8E0FF);

  static ThemeData light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: _violet,
      onPrimary: Colors.white,
      primaryContainer: Color(0xFFE8E2F8),
      onPrimaryContainer: Color(0xFF201843),
      secondary: Color(0xFF8B7EC9),
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFFF2EEFE),
      onSecondaryContainer: Color(0xFF2D2548),
      tertiary: Color(0xFF7A92C4),
      onTertiary: Color(0xFFFFFFFF),
      error: Color(0xFFBA1A1A),
      onError: Colors.white,
      surface: _icySurface,
      onSurface: Color(0xFF18181F),
      onSurfaceVariant: Color(0xFF535366),
      surfaceContainerLowest: Colors.white,
      surfaceContainerLow: Color(0xFFF7F8FD),
      surfaceContainer: Color(0xFFEEF0F8),
      surfaceContainerHigh: Color(0xFFE4E7F2),
      surfaceContainerHighest: Color(0xFFD9DDEB),
      outline: Color(0xFFC1C4D4),
      outlineVariant: Color(0xFFE0E2ED),
      shadow: Color(0x40000000),
      scrim: Color(0x80000000),
      inverseSurface: Color(0xFF2D2D38),
      onInverseSurface: Color(0xFFF3F1FA),
      inversePrimary: Color(0xFFD0C4FF),
    ),
    scaffoldBackgroundColor: _icyBackground,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: _icyBackground,
      foregroundColor: _violetDeep,
      surfaceTintColor: Colors.transparent,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: _icySurface,
      indicatorColor: Color(0xFFE8E2F8),
      surfaceTintColor: Colors.transparent,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: _icySurface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: Color(0xFFDFE3F0)),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: _violet,
        foregroundColor: Colors.white,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: _violet,
      foregroundColor: Colors.white,
      elevation: 2,
    ),
    dividerTheme: DividerThemeData(color: Color(0xFFE4E7F2)),
  );

  static ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: _frostPrimary,
      onPrimary: _frostOnPrimary,
      primaryContainer: _frostContainer,
      onPrimaryContainer: _frostOnContainer,
      secondary: Color(0xFFB4A3E8),
      onSecondary: _frostOnPrimary,
      secondaryContainer: Color(0xFF3D3550),
      onSecondaryContainer: Color(0xFFE5DEFF),
      tertiary: Color(0xFF9FB2E0),
      onTertiary: _frostOnPrimary,
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
      surface: _nightSurface,
      onSurface: Color(0xFFE8E6F2),
      onSurfaceVariant: Color(0xFFC4C1D4),
      surfaceContainerLowest: _nightBg,
      surfaceContainerLow: Color(0xFF12121A),
      surfaceContainer: _nightSurfaceHigh,
      surfaceContainerHigh: Color(0xFF242433),
      surfaceContainerHighest: Color(0xFF2C2C3E),
      outline: Color(0xFF5D5D74),
      outlineVariant: _nightBorder,
      shadow: Color(0x80000000),
      scrim: Color(0xCC000000),
      inverseSurface: Color(0xFFE8E6F2),
      onInverseSurface: Color(0xFF1C1B22),
      inversePrimary: _violet,
    ),
    scaffoldBackgroundColor: _nightBg,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: _nightBg,
      foregroundColor: _frostOnContainer,
      surfaceTintColor: Colors.transparent,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: _nightSurface,
      indicatorColor: _frostContainer,
      surfaceTintColor: Colors.transparent,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: _nightSurfaceHigh,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: _nightBorder),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: _frostPrimary,
        foregroundColor: _frostOnPrimary,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: _frostPrimary,
      foregroundColor: _frostOnPrimary,
      elevation: 3,
    ),
    dividerTheme: DividerThemeData(color: _nightBorder),
  );
}
