import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:life_balance/core/app_theme_preference.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Injected from [main] after `SharedPreferences.getInstance()`.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw StateError('sharedPreferencesProvider must be overridden in main()');
});

final themePreferenceProvider =
    NotifierProvider<ThemePreferenceNotifier, AppThemePreference>(
  ThemePreferenceNotifier.new,
);

class ThemePreferenceNotifier extends Notifier<AppThemePreference> {
  static const _storageKey = 'app_theme_preference';

  @override
  AppThemePreference build() {
    final prefs = ref.read(sharedPreferencesProvider);
    return appThemePreferenceFromStored(prefs.getString(_storageKey));
  }

  Future<void> setPreference(AppThemePreference value) async {
    state = value;
    await ref.read(sharedPreferencesProvider).setString(_storageKey, value.name);
  }
}
