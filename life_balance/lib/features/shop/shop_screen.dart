import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:life_balance/data/shop_repository.dart';
import 'package:life_balance/domain/shop_catalog.dart';
import 'package:life_balance/l10n/app_localizations.dart';
import 'package:life_balance/logic/assistant_picker.dart';
import 'package:life_balance/providers.dart';
import 'package:life_balance/ui/shop_item_strings.dart';
import 'package:life_balance/ui/chrome_surfaces.dart';
import 'package:life_balance/ui/onboarding_typography.dart';

Widget _ownedShopTrailing({
  required BuildContext context,
  required WidgetRef ref,
  required ShopItemDef item,
  required AppLocalizations l10n,
}) {
  final accent = OnboardingTypography.accentLavender;
  final brightness = Theme.of(context).brightness;
  final tc = OnboardingTypography.textColor(brightness);
  final activeStyle = OnboardingTypography.bodyStyle(accent, alpha: 1).copyWith(
    fontWeight: FontWeight.w600,
    fontSize: OnboardingTypography.body - 2,
  );

  switch (item.category) {
    case ShopItemCategory.profileBackground:
      final equipped =
          ref.watch(effectiveProfileBackgroundIdProvider) == item.id;
      if (equipped) {
        return Text(l10n.shopBackgroundActive, style: activeStyle);
      }
      return OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: tc,
          side: BorderSide(color: accent.withValues(alpha: 0.45)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        onPressed: () async {
          await ref
              .read(profileBackgroundIdProvider.notifier)
              .setBackgroundId(item.id);
          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(l10n.profileLookUpdated)));
          }
        },
        child: Text(
          l10n.shopUseBackground,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: OnboardingTypography.body - 4,
          ),
        ),
      );
    case ShopItemCategory.frame:
      final equipped =
          ref.watch(effectiveProfileAvatarFrameIdProvider) == item.id;
      if (equipped) {
        return Text(l10n.shopBackgroundActive, style: activeStyle);
      }
      return OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: tc,
          side: BorderSide(color: accent.withValues(alpha: 0.45)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        onPressed: () async {
          await ref
              .read(profileAvatarFrameIdProvider.notifier)
              .setFrameId(item.id);
          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(l10n.profileLookUpdated)));
          }
        },
        child: Text(
          l10n.shopUseBackground,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: OnboardingTypography.body - 4,
          ),
        ),
      );
    case ShopItemCategory.nameStyle:
      final equipped =
          ref.watch(effectiveProfileNameStyleIdProvider) == item.id;
      if (equipped) {
        return Text(l10n.shopBackgroundActive, style: activeStyle);
      }
      return OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: tc,
          side: BorderSide(color: accent.withValues(alpha: 0.45)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        onPressed: () async {
          await ref
              .read(profileNameStyleIdProvider.notifier)
              .setNameStyleId(item.id);
          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(l10n.profileLookUpdated)));
          }
        },
        child: Text(
          l10n.shopUseBackground,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: OnboardingTypography.body - 4,
          ),
        ),
      );
    case ShopItemCategory.assistantLayer:
    case ShopItemCategory.voicePack:
      return Text(
        l10n.shopOwned,
        style: OnboardingTypography.bodyStyle(tc, alpha: 0.5)
            .copyWith(
              fontWeight: FontWeight.w600,
              fontSize: OnboardingTypography.body - 2,
            ),
      );
  }
}

enum ShopShelfFilter { all, profile, assistant }

final shopShelfFilterProvider = StateProvider<ShopShelfFilter>(
  (ref) => ShopShelfFilter.all,
);

bool _itemMatchesShelf(ShopItemDef def, ShopShelfFilter f) {
  final isProfile =
      def.category == ShopItemCategory.profileBackground ||
      def.category == ShopItemCategory.frame ||
      def.category == ShopItemCategory.nameStyle;
  return switch (f) {
    ShopShelfFilter.all => true,
    ShopShelfFilter.profile => isProfile,
    ShopShelfFilter.assistant => !isProfile,
  };
}

class ShopScreen extends ConsumerWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final statsAsync = ref.watch(userStatsProvider);
    final ownedAsync = ref.watch(ownedShopItemIdsProvider);
    final filter = ref.watch(shopShelfFilterProvider);
    final accent = OnboardingTypography.accentLavender;
    final brightness = Theme.of(context).brightness;
    final tc = OnboardingTypography.textColor(brightness);
    const saveFg = Color(0xFF1E1B4B);

    final topInset = MediaQuery.paddingOf(context).top + kToolbarHeight;
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom + 80;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        foregroundColor: tc,
        iconTheme: IconThemeData(color: tc),
        title: Text(
          l10n.navShop,
          style: OnboardingTypography.titleStyle(tc).copyWith(
            fontWeight: FontWeight.w700,
            fontSize: OnboardingTypography.welcome,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: statsAsync.maybeWhen(
                data: (s) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: brightness == Brightness.dark
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: brightness == Brightness.dark
                          ? Colors.white.withValues(alpha: 0.2)
                          : OnboardingTypography.shellChromeBorderColor(
                              Brightness.light,
                            ),
                    ),
                    boxShadow: brightness == Brightness.light
                        ? [
                            BoxShadow(
                              color: const Color(0xFF453A7A)
                                  .withValues(alpha: 0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.stars_rounded, color: accent, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        l10n.shopYourBalance(s?.totalXp ?? 0),
                        style:
                            OnboardingTypography.bodyStyle(
                              tc,
                              alpha: 0.95,
                            ).copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: OnboardingTypography.body - 4,
                            ),
                      ),
                    ],
                  ),
                ),
                orElse: () => const SizedBox.shrink(),
              ),
            ),
          ),
        ],
      ),
      body: statsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text('$e', style: TextStyle(color: tc)),
        ),
        data: (stats) {
          final xp = stats?.totalXp ?? 0;
          final best = stats?.bestStreak ?? 0;
          return ownedAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(
              child: Text('$e', style: TextStyle(color: tc)),
            ),
            data: (owned) {
              final items = kShopCatalog
                  .where((e) => _itemMatchesShelf(e, filter))
                  .toList();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: topInset),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _FilterChip(
                            label: l10n.shopFilterAll,
                            selected: filter == ShopShelfFilter.all,
                            onTap: () =>
                                ref
                                        .read(shopShelfFilterProvider.notifier)
                                        .state =
                                    ShopShelfFilter.all,
                          ),
                          const SizedBox(width: 8),
                          _FilterChip(
                            label: l10n.shopFilterProfile,
                            selected: filter == ShopShelfFilter.profile,
                            onTap: () =>
                                ref
                                        .read(shopShelfFilterProvider.notifier)
                                        .state =
                                    ShopShelfFilter.profile,
                          ),
                          const SizedBox(width: 8),
                          _FilterChip(
                            label: l10n.shopFilterAssistant,
                            selected: filter == ShopShelfFilter.assistant,
                            onTap: () =>
                                ref
                                        .read(shopShelfFilterProvider.notifier)
                                        .state =
                                    ShopShelfFilter.assistant,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.fromLTRB(16, 4, 16, bottomInset),
                      itemCount: items.length,
                      itemBuilder: (context, i) {
                        final item = items[i];
                        final copy = shopItemStrings(l10n, item.id);
                        final isOwned = owned.contains(item.id);
                        final locked = item.isLocked(userBestStreak: best);
                        final canBuy =
                            !isOwned && !locked && xp >= item.priceXp;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: ChromeCard(
                            borderRadius: 22,
                            lightElevation: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(18),
                              child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                copy.title,
                                                style:
                                                    OnboardingTypography.bodyStyle(
                                                      tc,
                                                      alpha: 1,
                                                    ).copyWith(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                shopCategoryLabel(
                                                  l10n,
                                                  item.category,
                                                ),
                                                style:
                                                    OnboardingTypography.bodyStyle(
                                                      tc,
                                                      alpha: 0.62,
                                                    ).copyWith(
                                                      fontSize:
                                                          OnboardingTypography
                                                              .body -
                                                          6,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      letterSpacing: 0.5,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: accent.withValues(
                                              alpha: 0.15,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            border: Border.all(
                                              color: accent.withValues(
                                                alpha: 0.3,
                                              ),
                                            ),
                                          ),
                                          child: Text(
                                            '${item.priceXp} XP',
                                            style:
                                                OnboardingTypography.bodyStyle(
                                                  accent,
                                                  alpha: 1,
                                                ).copyWith(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize:
                                                      OnboardingTypography
                                                          .body -
                                                      4,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      copy.description,
                                      style:
                                          OnboardingTypography.bodyStyle(
                                            tc,
                                            alpha: 0.88,
                                          ).copyWith(
                                            fontSize:
                                                OnboardingTypography.body - 4,
                                            height: 1.4,
                                          ),
                                    ),
                                    if (locked) ...[
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.lock_outline,
                                            color: tc.withValues(
                                              alpha: 0.5,
                                            ),
                                            size: 16,
                                          ),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              l10n.shopLockedStreak(
                                                item.minBestStreak,
                                              ),
                                              style:
                                                  OnboardingTypography.bodyStyle(
                                                    tc,
                                                    alpha: 0.5,
                                                  ).copyWith(
                                                    fontSize:
                                                        OnboardingTypography
                                                            .body -
                                                        4,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                    const SizedBox(height: 16),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: isOwned
                                          ? _ownedShopTrailing(
                                              context: context,
                                              ref: ref,
                                              item: item,
                                              l10n: l10n,
                                            )
                                          : FilledButton(
                                              style: FilledButton.styleFrom(
                                                backgroundColor: accent,
                                                foregroundColor: saveFg,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 24,
                                                      vertical: 12,
                                                    ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        999,
                                                      ),
                                                ),
                                              ),
                                              onPressed: canBuy
                                                  ? () async {
                                                      final result = await ref
                                                          .read(
                                                            shopRepositoryProvider,
                                                          )
                                                          .tryPurchase(item.id);
                                                      if (!context.mounted) {
                                                        return;
                                                      }
                                                      final messenger =
                                                          ScaffoldMessenger.of(
                                                            context,
                                                          );
                                                      switch (result) {
                                                        case PurchaseResult
                                                            .success:
                                                          messenger.showSnackBar(
                                                            SnackBar(
                                                              duration:
                                                                  const Duration(
                                                                    seconds: 5,
                                                                  ),
                                                              content: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Text(
                                                                    l10n.shopPurchaseSuccess,
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 6,
                                                                  ),
                                                                  Text(
                                                                    assistantAfterShopPurchase(
                                                                      l10n,
                                                                      voicePackId:
                                                                          item.category ==
                                                                              ShopItemCategory.voicePack
                                                                          ? item.id
                                                                          : ref.read(
                                                                              effectiveVoicePackIdProvider,
                                                                            ),
                                                                    ),
                                                                    style: Theme.of(
                                                                      context,
                                                                    ).textTheme.bodySmall,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        case PurchaseResult
                                                            .alreadyOwned:
                                                          messenger.showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                l10n.shopAlreadyOwned,
                                                              ),
                                                            ),
                                                          );
                                                        case PurchaseResult
                                                            .insufficientXp:
                                                          messenger.showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                l10n.shopNotEnoughXp,
                                                              ),
                                                            ),
                                                          );
                                                        case PurchaseResult
                                                            .lockedByStreak:
                                                          messenger.showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                l10n.shopLockedStreak(
                                                                  item.minBestStreak,
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        case PurchaseResult
                                                            .unknownItem:
                                                          break;
                                                      }
                                                    }
                                                  : null,
                                              child: Text(
                                                l10n.shopBuy,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize:
                                                      OnboardingTypography
                                                          .body -
                                                      4,
                                                ),
                                              ),
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = OnboardingTypography.accentLavender;
    const saveFg = Color(0xFF1E1B4B);
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final tc = OnboardingTypography.textColor(brightness);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: selected
                ? accent
                : (isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : const Color(0xFFF5F3FA)),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected
                  ? Colors.transparent
                  : (isDark
                      ? Colors.white.withValues(alpha: 0.2)
                      : const Color(0xFFE2DBF5)),
            ),
          ),
          child: Text(
            label,
            style:
                OnboardingTypography.bodyStyle(
                  selected ? saveFg : tc,
                  alpha: selected ? 1 : (isDark ? 0.8 : 0.85),
                ).copyWith(
                  fontSize: OnboardingTypography.body - 4,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
          ),
        ),
      ),
    );
  }
}
