import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:life_balance/l10n/app_localizations.dart';
import 'package:life_balance/logic/assistant_picker.dart';
import 'package:life_balance/providers.dart';
import 'package:life_balance/ui/assistant_buddy.dart';
import 'package:life_balance/ui/shop_item_strings.dart';

class AssistantScreen extends ConsumerWidget {
  const AssistantScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final layers = ref.watch(equippedAssistantLayersProvider);
    final voiceId = ref.watch(effectiveVoicePackIdProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.assistantScreenTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          Center(
            child: AssistantBuddy(
              ownedLayerIds: layers.toSet(),
              size: 132,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.assistantScreenIntro,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 28),
          Text(
            l10n.assistantScreenLayersHeading,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          if (layers.isEmpty)
            Text(
              l10n.assistantScreenLayersEmpty,
              style: Theme.of(context).textTheme.bodyMedium,
            )
          else
            Card(
              child: Column(
                children: [
                  for (var i = 0; i < layers.length; i++)
                    ListTile(
                      leading: Icon(
                        _layerIcon(layers[i]),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      title: Text(shopItemStrings(l10n, layers[i]).title),
                      subtitle: Text(
                        shopItemStrings(l10n, layers[i]).description,
                      ),
                    ),
                ],
              ),
            ),
          const SizedBox(height: 24),
          Text(
            l10n.assistantScreenVoiceHeading,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: Icon(
                Icons.record_voice_over_outlined,
                color: Theme.of(context).colorScheme.secondary,
              ),
              title: Text(
                voiceId == null
                    ? l10n.assistantScreenVoiceDefaultTitle
                    : shopItemStrings(l10n, voiceId).title,
              ),
              subtitle: Text(
                voiceId == null
                    ? l10n.assistantScreenVoiceDefault
                    : voiceId == laconicVoicePackId
                        ? l10n.assistantScreenVoiceLaconicLine
                        : shopItemStrings(l10n, voiceId).description,
              ),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.tonal(
            onPressed: () {
              context.go('/shop');
            },
            child: Text(l10n.assistantOpenShopAssistant),
          ),
        ],
      ),
    );
  }

  IconData _layerIcon(String id) {
    return switch (id) {
      'assistant_cap_party' => Icons.celebration_rounded,
      'assistant_scarf_cozy' => Icons.checkroom_outlined,
      'sticker_balance_set' => Icons.auto_awesome,
      _ => Icons.layers_outlined,
    };
  }
}
