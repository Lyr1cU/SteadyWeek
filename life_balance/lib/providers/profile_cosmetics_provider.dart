import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:life_balance/providers/theme_preference_provider.dart';

final profileAvatarFrameIdProvider =
    NotifierProvider<ProfileAvatarFrameIdNotifier, String?>(
  ProfileAvatarFrameIdNotifier.new,
);

final profileNameStyleIdProvider =
    NotifierProvider<ProfileNameStyleIdNotifier, String?>(
  ProfileNameStyleIdNotifier.new,
);

class ProfileAvatarFrameIdNotifier extends Notifier<String?> {
  static const _key = 'profile_avatar_frame_shop_id';

  @override
  String? build() {
    return ref.read(sharedPreferencesProvider).getString(_key);
  }

  Future<void> setFrameId(String? shopItemId) async {
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

class ProfileNameStyleIdNotifier extends Notifier<String?> {
  static const _key = 'profile_name_style_shop_id';

  @override
  String? build() {
    return ref.read(sharedPreferencesProvider).getString(_key);
  }

  Future<void> setNameStyleId(String? shopItemId) async {
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
