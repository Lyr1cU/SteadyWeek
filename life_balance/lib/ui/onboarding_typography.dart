import 'package:flutter/material.dart';

/// Типографіка з онбордингу — для узгодження Today та інших екранів.
/// Трохи менші за оригінальні значення онбордингу для щільнішого екрана.
abstract final class OnboardingTypography {
  static const double welcome = 34;
  static const double mainTitle = 44;
  static const double body = 22;
  static const double button = 21;

  static const Color accentLavender = Color(0xFFB8A9F9);

  /// Фіолетова «скляна» плашка для смуги дат і нижнього бару (узгоджено з темою).
  static Color shellChromeSurface(Brightness brightness) {
    return brightness == Brightness.dark
        ? const Color(0xFF352D55).withValues(alpha: 0.88)
        : const Color(0xFFE8E2F8).withValues(alpha: 0.94);
  }

  static Color shellChromeBorderColor() =>
      accentLavender.withValues(alpha: 0.38);

  /// Підсвітка обраного пункту в [NavigationBar] поверх [shellChromeSurface].
  static Color shellChromeNavIndicator(Brightness brightness) {
    return brightness == Brightness.dark
        ? const Color(0xFF5A4D85).withValues(alpha: 0.9)
        : const Color(0xFF6B5DB8).withValues(alpha: 0.22);
  }

  static Color shellChromeNavIcon(Brightness brightness) {
    return brightness == Brightness.dark
        ? const Color(0xFFE8E0FF)
        : const Color(0xFF453A7A);
  }

  static TextStyle titleStyle(Color foreground) => TextStyle(
        fontSize: mainTitle,
        fontWeight: FontWeight.w700,
        color: foreground,
        height: 1.18,
      );

  static TextStyle bodyStyle(Color foreground, {double alpha = 0.92}) =>
      TextStyle(
        fontSize: body,
        fontWeight: FontWeight.w400,
        color: foreground.withValues(alpha: alpha),
        height: 1.68,
      );
}
