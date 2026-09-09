import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:life_balance/providers/theme_preference_provider.dart';

final profileBackgroundIdProvider =
    NotifierProvider<ProfileBackgroundNotifier, String?>(
  ProfileBackgroundNotifier.new,
);

class ProfileBackgroundNotifier extends Notifier<String?> {
  static const _key = 'profile_background_shop_id';

  @override
  String? build() {
    return ref.read(sharedPreferencesProvider).getString(_key);
  }

  Future<void> setBackgroundId(String? shopItemId) async {
    final prefs = ref.read(sharedPreferencesProvider);
    if (shopItemId == null || shopItemId.isEmpty) {
      await prefs.remove(_key);
      state = null;
    } else {
      await prefs.setString(_key, shopItemId);
      state = shopItemId;
    }
  }
}
