import 'package:life_balance/domain/shop_catalog.dart';
import 'package:life_balance/l10n/app_localizations.dart';

typedef ShopItemStrings = ({String title, String description});

ShopItemStrings shopItemStrings(AppLocalizations l, String id) {
  return switch (id) {
    'calm_mist_bg' => (
      title: l.shopItemCalmMistBgTitle,
      description: l.shopItemCalmMistBgDesc,
    ),
    'dawn_gradient_bg' => (
      title: l.shopItemDawnGradientBgTitle,
      description: l.shopItemDawnGradientBgDesc,
    ),
    'lavender_soft_frame' => (
      title: l.shopItemLavenderSoftFrameTitle,
      description: l.shopItemLavenderSoftFrameDesc,
    ),
    'ember_streak_frame' => (
      title: l.shopItemEmberStreakFrameTitle,
      description: l.shopItemEmberStreakFrameDesc,
    ),
    'name_gradient_gold' => (
      title: l.shopItemNameGradientGoldTitle,
      description: l.shopItemNameGradientGoldDesc,
    ),
    'name_soft_violet' => (
      title: l.shopItemNameSoftVioletTitle,
      description: l.shopItemNameSoftVioletDesc,
    ),
    'assistant_cap_party' => (
      title: l.shopItemAssistantCapPartyTitle,
      description: l.shopItemAssistantCapPartyDesc,
    ),
    'assistant_scarf_cozy' => (
      title: l.shopItemAssistantScarfCozyTitle,
      description: l.shopItemAssistantScarfCozyDesc,
    ),
    'voice_pack_laconic' => (
      title: l.shopItemVoicePackLaconicTitle,
      description: l.shopItemVoicePackLaconicDesc,
    ),
    'sticker_balance_set' => (
      title: l.shopItemStickerBalanceSetTitle,
      description: l.shopItemStickerBalanceSetDesc,
    ),
    _ => (title: id, description: ''),
  };
}

String shopCategoryLabel(AppLocalizations l, ShopItemCategory c) {
  return switch (c) {
    ShopItemCategory.profileBackground => l.shopCategoryProfileBg,
    ShopItemCategory.frame => l.shopCategoryFrame,
    ShopItemCategory.nameStyle => l.shopCategoryNameStyle,
    ShopItemCategory.assistantLayer => l.shopCategoryAssistant,
    ShopItemCategory.voicePack => l.shopCategoryVoice,
  };
}
