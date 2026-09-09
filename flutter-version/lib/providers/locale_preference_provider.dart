import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:life_balance/providers/theme_preference_provider.dart';

enum AppLocalePreference { system, en, uk }

final appLocalePreferenceProvider =
    NotifierProvider<AppLocalePreferenceNotifier, AppLocalePreference>(
  AppLocalePreferenceNotifier.new,
);

class AppLocalePreferenceNotifier extends Notifier<AppLocalePreference> {
  static const _key = 'app_locale_preference_v1';

  @override
  AppLocalePreference build() {
    final raw = ref.read(sharedPreferencesProvider).getString(_key);
    return _parse(raw);
  }

  Future<void> setPreference(AppLocalePreference value) async {
    state = value;
    await ref
        .read(sharedPreferencesProvider)
        .setString(_key, value.name);
  }

  static AppLocalePreference _parse(String? raw) {
    switch (raw) {
      case 'en':
        return AppLocalePreference.en;
      case 'uk':
        return AppLocalePreference.uk;
      default:
        return AppLocalePreference.system;
    }
  }
}

/// `null` means defer to device + [localeResolutionCallback].
Locale? resolveAppLocale(AppLocalePreference pref) {
  return switch (pref) {
    AppLocalePreference.system => null,
    AppLocalePreference.en => const Locale('en'),
    AppLocalePreference.uk => const Locale('uk'),
  };
}
