import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:life_balance/providers/theme_preference_provider.dart';

/// Bumps when [onboardingCompleteProvider] changes so [GoRouter] re-runs redirect.
final goRouterRefreshProvider = Provider<ValueNotifier<int>>((ref) {
  final n = ValueNotifier(0);
  ref.listen(onboardingCompleteProvider, (previous, next) => n.value++);
  ref.onDispose(n.dispose);
  return n;
});

final onboardingCompleteProvider =
    NotifierProvider<OnboardingCompleteNotifier, bool>(
  OnboardingCompleteNotifier.new,
);

class OnboardingCompleteNotifier extends Notifier<bool> {
  static const _key = 'onboarding_done_v1';

  @override
  bool build() =>
      ref.read(sharedPreferencesProvider).getBool(_key) ?? false;

  Future<void> complete() async {
    await ref.read(sharedPreferencesProvider).setBool(_key, true);
    state = true;
  }
}

final userDisplayNameProvider =
    NotifierProvider<UserDisplayNameNotifier, String?>(
  UserDisplayNameNotifier.new,
);

class UserDisplayNameNotifier extends Notifier<String?> {
  static const _key = 'user_display_name';

  @override
  String? build() {
    final raw = ref.read(sharedPreferencesProvider).getString(_key);
    if (raw == null || raw.trim().isEmpty) return null;
    return raw.trim();
  }

  Future<void> setName(String name) async {
    final t = name.trim();
    await ref.read(sharedPreferencesProvider).setString(_key, t);
    state = t.isEmpty ? null : t;
  }
}
