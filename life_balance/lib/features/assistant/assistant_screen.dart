import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:life_balance/l10n/app_localizations.dart';
import 'package:life_balance/logic/assistant_picker.dart';
import 'package:life_balance/providers.dart';
import 'package:life_balance/ui/assistant_buddy.dart';
import 'package:life_balance/ui/shop_item_strings.dart';
import 'package:life_balance/ui/chrome_surfaces.dart';
import 'package:life_balance/ui/onboarding_typography.dart';

class _AssistantChromeCard extends StatelessWidget {
  const _AssistantChromeCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ChromeCard(
        borderRadius: 22,
        lightElevation: 3,
        child: Material(color: Colors.transparent, child: child),
      ),
    );
  }
}

class AssistantScreen extends ConsumerWidget {
  const AssistantScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final layers = ref.watch(equippedAssistantLayersProvider);
    final voiceId = ref.watch(effectiveVoicePackIdProvider);
    final accent = OnboardingTypography.accentLavender;
    final brightness = Theme.of(context).brightness;
    final tc = OnboardingTypography.textColor(brightness);

    final bottomInset = MediaQuery.viewPaddingOf(context).bottom + 28;

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
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        title: Text(
          l10n.assistantScreenTitle,
          style: OnboardingTypography.titleStyle(tc).copyWith(
            fontWeight: FontWeight.w700,
            fontSize: OnboardingTypography.welcome,
          ),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          const Positioned.fill(child: ChromePageBackground()),
          SafeArea(
            child: ListView(
              padding: EdgeInsets.fromLTRB(20, 20, 20, bottomInset),
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
                  style: OnboardingTypography.bodyStyle(
                    tc,
                    alpha: 0.72,
                  ).copyWith(fontSize: OnboardingTypography.body - 2),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 12),
                  child: Text(
                    l10n.assistantScreenLayersHeading,
                    style: OnboardingTypography.titleStyle(tc).copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: OnboardingTypography.body + 2,
                    ),
                  ),
                ),
                if (layers.isEmpty)
                  _AssistantChromeCard(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        l10n.assistantScreenLayersEmpty,
                        style: OnboardingTypography.bodyStyle(
                          tc,
                          alpha: 0.72,
                        ).copyWith(fontSize: OnboardingTypography.body - 4),
                      ),
                    ),
                  )
                else
                  _AssistantChromeCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (var i = 0; i < layers.length; i++) ...[
                          if (i > 0)
                            Divider(
                              height: 1,
                              color: tc.withValues(alpha: 0.12),
                            ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  _layerIcon(layers[i]),
                                  color: accent,
                                  size: 28,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        shopItemStrings(l10n, layers[i]).title,
                                        style: OnboardingTypography.bodyStyle(
                                          tc,
                                          alpha: 1,
                                        ).copyWith(fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        shopItemStrings(
                                          l10n,
                                          layers[i],
                                        ).description,
                                        style:
                                            OnboardingTypography.bodyStyle(
                                              tc,
                                              alpha: 0.72,
                                            ).copyWith(
                                              fontSize:
                                                  OnboardingTypography.body - 6,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 12),
                  child: Text(
                    l10n.assistantScreenVoiceHeading,
                    style: OnboardingTypography.titleStyle(tc).copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: OnboardingTypography.body + 2,
                    ),
                  ),
                ),
                _AssistantChromeCard(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.record_voice_over_outlined,
                          color: accent,
                          size: 28,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                voiceId == null
                                    ? l10n.assistantScreenVoiceDefaultTitle
                                    : shopItemStrings(l10n, voiceId).title,
                                style: OnboardingTypography.bodyStyle(
                                  tc,
                                  alpha: 1,
                                ).copyWith(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                voiceId == null
                                    ? l10n.assistantScreenVoiceDefault
                                    : voiceId == laconicVoicePackId
                                    ? l10n.assistantScreenVoiceLaconicLine
                                    : shopItemStrings(
                                        l10n,
                                        voiceId,
                                      ).description,
                                style:
                                    OnboardingTypography.bodyStyle(
                                      tc,
                                      alpha: 0.72,
                                    ).copyWith(
                                      fontSize: OnboardingTypography.body - 6,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: accent,
                    foregroundColor: const Color(0xFF1E1B4B),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  onPressed: () {
                    context.go('/shop');
                  },
                  child: Text(
                    l10n.assistantOpenShopAssistant,
                    style: const TextStyle(
                      fontSize: OnboardingTypography.body - 2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
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
