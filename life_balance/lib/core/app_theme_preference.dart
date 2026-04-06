import 'package:flutter/material.dart';

/// User-selected appearance; persisted locally.
enum AppThemePreference {
  system,
  light,
  dark,
}

AppThemePreference appThemePreferenceFromStored(String? raw) {
  if (raw == null) return AppThemePreference.system;
  return AppThemePreference.values.firstWhere(
    (e) => e.name == raw,
    orElse: () => AppThemePreference.system,
  );
}

extension AppThemePreferenceThemeMode on AppThemePreference {
  ThemeMode get themeMode => switch (this) {
        AppThemePreference.system => ThemeMode.system,
        AppThemePreference.light => ThemeMode.light,
        AppThemePreference.dark => ThemeMode.dark,
      };
}
