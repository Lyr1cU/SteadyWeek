/// Static catalog — MASTER_PLAN §9. (Titles/descriptions in l10n by [id].)
enum ShopItemCategory {
  profileBackground,
  frame,
  nameStyle,
  assistantLayer,
  voicePack,
}

class ShopItemDef {
  const ShopItemDef({
    required this.id,
    required this.category,
    required this.priceXp,
    this.minBestStreak = 0,
  });

  final String id;
  final ShopItemCategory category;
  final int priceXp;
  /// Require [UserStats.bestStreak] >= this (0 = no lock).
  final int minBestStreak;

  bool isLocked({required int userBestStreak}) =>
      userBestStreak < minBestStreak;
}

const List<ShopItemDef> kShopCatalog = [
  ShopItemDef(
      id: 'calm_mist_bg',
      category: ShopItemCategory.profileBackground,
      priceXp: 180),
  ShopItemDef(
      id: 'dawn_gradient_bg',
      category: ShopItemCategory.profileBackground,
      priceXp: 260),
  ShopItemDef(
      id: 'lavender_soft_frame',
      category: ShopItemCategory.frame,
      priceXp: 320),
  ShopItemDef(
      id: 'ember_streak_frame',
      category: ShopItemCategory.frame,
      priceXp: 720,
      minBestStreak: 7),
  ShopItemDef(
      id: 'name_gradient_gold',
      category: ShopItemCategory.nameStyle,
      priceXp: 280),
  ShopItemDef(
      id: 'name_soft_violet',
      category: ShopItemCategory.nameStyle,
      priceXp: 240),
  ShopItemDef(
      id: 'assistant_cap_party',
      category: ShopItemCategory.assistantLayer,
      priceXp: 200),
  ShopItemDef(
      id: 'assistant_scarf_cozy',
      category: ShopItemCategory.assistantLayer,
      priceXp: 360),
  ShopItemDef(
      id: 'voice_pack_laconic',
      category: ShopItemCategory.voicePack,
      priceXp: 300),
  ShopItemDef(
      id: 'sticker_balance_set',
      category: ShopItemCategory.assistantLayer,
      priceXp: 420),
];

ShopItemDef? shopItemById(String id) {
  try {
    return kShopCatalog.firstWhere((e) => e.id == id);
  } catch (_) {
    return null;
  }
}
