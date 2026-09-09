import 'package:flutter/material.dart';

/// Metrics for the floating bottom bar in [MainShell]. Keep in sync when changing
/// `SafeArea` / `Padding` / `NavigationBar` there (tabs use `extendBody: true`).
abstract final class ShellChromeMetrics {
  static const double navigationBarHeight = 60;
  static const double navigationBarOuterBottomPadding = 8;
  static const double navigationBarOuterHorizontalPadding = 10;

  /// Space between the bottom of FAB / assistant stack and the top of the nav pill.
  static const double fabGapAboveNavigationBar = 8;

  /// `Positioned(bottom: …)` for overlays that should sit just above the nav bar.
  static double fabStackBottomInset(BuildContext context) {
    return MediaQuery.viewPaddingOf(context).bottom +
        navigationBarOuterBottomPadding +
        navigationBarHeight +
        fabGapAboveNavigationBar;
  }

  /// Full-screen sheets (close day, weekly report): assistant only, nudged toward the nav pill.
  static double assistantFloatBottomTight(BuildContext context) {
    return fabStackBottomInset(context) - 22;
  }
}
