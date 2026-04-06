import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:life_balance/data/shop_repository.dart';
import 'package:life_balance/domain/shop_catalog.dart';
import 'package:life_balance/l10n/app_localizations.dart';
import 'package:life_balance/logic/assistant_picker.dart';
import 'package:life_balance/providers.dart';
import 'package:life_balance/ui/shop_item_strings.dart';

Widget _ownedShopTrailing({
  required BuildContext context,
  required WidgetRef ref,
  required ShopItemDef item,
  required AppLocalizations l10n,
}) {
  final accent = Theme.of(context).colorScheme.primary;
  final activeStyle = Theme.of(context).textTheme.labelLarge?.copyWith(
        color: accent,
        fontWeight: FontWeight.w600,
      );

  switch (item.category) {
    case ShopItemCategory.profileBackground:
      final equipped =
          ref.watch(effectiveProfileBackgroundIdProvider) == item.id;
      if (equipped) {
        return Text(l10n.shopBackgroundActive, style: activeStyle);
      }
      return TextButton(
        onPressed: () async {
          await ref
              .read(profileBackgroundIdProvider.notifier)
              .setBackgroundId(item.id);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.profileLookUpdated)),
            );
          }
        },
        child: Text(l10n.shopUseBackground),
      );
    case ShopItemCategory.frame:
      final equipped =
          ref.watch(effectiveProfileAvatarFrameIdProvider) == item.id;
      if (equipped) {
        return Text(l10n.shopBackgroundActive, style: activeStyle);
      }
      return TextButton(
        onPressed: () async {
          await ref
              .read(profileAvatarFrameIdProvider.notifier)
              .setFrameId(item.id);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.profileLookUpdated)),
            );
          }
        },
        child: Text(l10n.shopUseBackground),
      );
    case ShopItemCategory.nameStyle:
      final equipped =
          ref.watch(effectiveProfileNameStyleIdProvider) == item.id;
      if (equipped) {
        return Text(l10n.shopBackgroundActive, style: activeStyle);
      }
      return TextButton(
        onPressed: () async {
          await ref
              .read(profileNameStyleIdProvider.notifier)
              .setNameStyleId(item.id);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.profileLookUpdated)),
            );
          }
        },
        child: Text(l10n.shopUseBackground),
      );
    case ShopItemCategory.assistantLayer:
    case ShopItemCategory.voicePack:
      return Text(
        l10n.shopOwned,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: accent),
      );
  }
}

enum ShopShelfFilter { all, profile, assistant }

final shopShelfFilterProvider =
    StateProvider<ShopShelfFilter>((ref) => ShopShelfFilter.all);

bool _itemMatchesShelf(ShopItemDef def, ShopShelfFilter f) {
  final isProfile = def.category == ShopItemCategory.profileBackground ||
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

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navShop),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: statsAsync.maybeWhen(
                data: (s) => Text(
                  l10n.shopYourBalance(s?.totalXp ?? 0),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
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
        error: (e, _) => Center(child: Text('$e')),
        data: (stats) {
          final xp = stats?.totalXp ?? 0;
          final best = stats?.bestStreak ?? 0;
          return ownedAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('$e')),
            data: (owned) {
              final items = kShopCatalog
                  .where((e) => _itemMatchesShelf(e, filter))
                  .toList();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: SegmentedButton<ShopShelfFilter>(
                      segments: [
                        ButtonSegment(
                          value: ShopShelfFilter.all,
                          label: Text(l10n.shopFilterAll),
                        ),
                        ButtonSegment(
                          value: ShopShelfFilter.profile,
                          label: Text(l10n.shopFilterProfile),
                        ),
                        ButtonSegment(
                          value: ShopShelfFilter.assistant,
                          label: Text(l10n.shopFilterAssistant),
                        ),
                      ],
                      selected: {filter},
                      onSelectionChanged: (next) {
                        ref.read(shopShelfFilterProvider.notifier).state =
                            next.first;
                      },
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 88),
                      itemCount: items.length,
                      itemBuilder: (context, i) {
                        final item = items[i];
                        final copy = shopItemStrings(l10n, item.id);
                        final isOwned = owned.contains(item.id);
                        final locked =
                            item.isLocked(userBestStreak: best);
                        final canBuy = !isOwned &&
                            !locked &&
                            xp >= item.priceXp;

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        copy.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                    ),
                                    Text(
                                      '${item.priceXp} XP',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  shopCategoryLabel(
                                    l10n,
                                    item.category,
                                  ),
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  copy.description,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium,
                                ),
                                if (locked) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    l10n.shopLockedStreak(
                                      item.minBestStreak,
                                    ),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                        ),
                                  ),
                                ],
                                const SizedBox(height: 12),
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
                                          onPressed: canBuy
                                              ? () async {
                                                  final result =
                                                      await ref
                                                          .read(
                                                            shopRepositoryProvider,
                                                          )
                                                          .tryPurchase(
                                                            item.id,
                                                          );
                                                  if (!context.mounted) {
                                                    return;
                                                  }
                                                  final messenger =
                                                      ScaffoldMessenger
                                                          .of(context);
                                                  switch (result) {
                                                    case PurchaseResult
                                                          .success:
                                                      messenger
                                                          .showSnackBar(
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
                                                                  voicePackId: item
                                                                              .category ==
                                                                          ShopItemCategory
                                                                              .voicePack
                                                                      ? item.id
                                                                      : ref.read(
                                                                          effectiveVoicePackIdProvider,
                                                                        ),
                                                                ),
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodySmall,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    case PurchaseResult
                                                          .alreadyOwned:
                                                      messenger
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                            l10n.shopAlreadyOwned,
                                                          ),
                                                        ),
                                                      );
                                                    case PurchaseResult
                                                          .insufficientXp:
                                                      messenger
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                            l10n.shopNotEnoughXp,
                                                          ),
                                                        ),
                                                      );
                                                    case PurchaseResult
                                                          .lockedByStreak:
                                                      messenger
                                                          .showSnackBar(
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
                                          child: Text(l10n.shopBuy),
                                        ),
                                ),
                              ],
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
