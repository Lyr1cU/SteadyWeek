import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:life_balance/core/date_key.dart';
import 'package:life_balance/core/week_key.dart';
import 'package:life_balance/data/day_closure_service.dart';
import 'package:life_balance/data/drift/app_database.dart';
import 'package:life_balance/domain/day_tier.dart';
import 'package:life_balance/logic/assistant_picker.dart';
import 'package:life_balance/l10n/app_localizations.dart';
import 'package:life_balance/providers.dart';
import 'package:life_balance/ui/assistant_buddy.dart';
import 'package:life_balance/ui/assistant_bubble_dock.dart';
import 'package:life_balance/ui/chrome_surfaces.dart';
import 'package:life_balance/ui/onboarding_typography.dart';
import 'package:life_balance/ui/pressable_scale.dart';
import 'package:life_balance/ui/shell_chrome_metrics.dart';

String _tierTitle(AppLocalizations l10n, DayTier t) {
  switch (t) {
    case DayTier.green:
      return l10n.tierGreen;
    case DayTier.yellow:
      return l10n.tierYellow;
    case DayTier.red:
      return l10n.tierRed;
  }
}

class CloseDayScreen extends ConsumerStatefulWidget {
  const CloseDayScreen({super.key, required this.dayKey});

  final String dayKey;

  @override
  ConsumerState<CloseDayScreen> createState() => _CloseDayScreenState();
}

class _CloseDayScreenState extends ConsumerState<CloseDayScreen> {
  final _highlight = TextEditingController();
  final _reflection = TextEditingController();
  int? _mood;
  bool _submitting = false;

  static const Color _saveFg = Color(0xFF1E1B4B);

  @override
  void dispose() {
    _highlight.dispose();
    _reflection.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration({
    required Color accent,
    required Brightness brightness,
    String? labelText,
    String? hintText,
  }) {
    final isDark = brightness == Brightness.dark;
    final fg = OnboardingTypography.textColor(brightness);
    final borderRadius = BorderRadius.circular(12);
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      hintStyle: OnboardingTypography.bodyStyle(
        fg,
        alpha: isDark ? 0.42 : 0.48,
      ),
      labelStyle: OnboardingTypography.bodyStyle(
        fg,
        alpha: isDark ? 0.68 : 0.72,
      ).copyWith(fontSize: OnboardingTypography.body - 4),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      filled: true,
      fillColor: isDark
          ? Colors.white.withValues(alpha: 0.08)
          : const Color(0xFFF5F3FA),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(borderRadius: borderRadius),
      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(
          color: isDark
              ? Colors.white.withValues(alpha: 0.32)
              : const Color(0xFFE2DBF5),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: accent, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final date = parseDateKeyLocal(widget.dayKey);
    final reportAsync = ref.watch(dailyReportForDayProvider(widget.dayKey));
    final accent = OnboardingTypography.accentLavender;
    final brightness = Theme.of(context).brightness;
    final tc = OnboardingTypography.textColor(brightness);
    final isDark = brightness == Brightness.dark;
    final assistantBottom = ShellChromeMetrics.assistantFloatBottomTight(
      context,
    );
    final scrollBottomPad = assistantBottom + 56;

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
        leading: PressableScale(
          child: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(),
          ),
        ),
        title: Text(
          l10n.closeDayTitle,
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
            child: reportAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Text('$e', style: TextStyle(color: tc)),
              ),
              data: (existing) {
                if (existing != null) {
                  return _ClosedSummary(
                    l10n: l10n,
                    report: existing,
                    scrollBottomPad: scrollBottomPad,
                  );
                }
                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, scrollBottomPad),
                  child: ChromeCard(
                    borderRadius: 22,
                    lightElevation: 12,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            DateFormat.yMMMEd(
                              dateFormatLocaleForIntl(
                                Localizations.localeOf(context),
                              ),
                            ).format(date),
                            textAlign: TextAlign.center,
                            style: OnboardingTypography.titleStyle(tc).copyWith(
                              fontSize: OnboardingTypography.welcome,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.reportQualityTip,
                            textAlign: TextAlign.center,
                            style: OnboardingTypography.bodyStyle(
                              tc,
                              alpha: 0.72,
                            ).copyWith(fontSize: OnboardingTypography.body - 6),
                          ),
                          const SizedBox(height: 24),
                          TextField(
                            controller: _highlight,
                            maxLines: 2,
                            style: OnboardingTypography.bodyStyle(
                              tc,
                              alpha: 0.96,
                            ),
                            decoration: _inputDecoration(
                              accent: accent,
                              brightness: brightness,
                              hintText: l10n.noteHighlightHint,
                            ),
                            textCapitalization: TextCapitalization.sentences,
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _reflection,
                            maxLines: 3,
                            style: OnboardingTypography.bodyStyle(
                              tc,
                              alpha: 0.96,
                            ),
                            decoration: _inputDecoration(
                              accent: accent,
                              brightness: brightness,
                              hintText: l10n.noteReflectionHint,
                            ),
                            textCapitalization: TextCapitalization.sentences,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            l10n.moodOptional,
                            style: OnboardingTypography.bodyStyle(
                              tc,
                              alpha: isDark ? 0.8 : 0.85,
                            ).copyWith(fontSize: OnboardingTypography.body - 4),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              for (var i = 1; i <= 5; i++)
                                ChoiceChip(
                                  label: Text('$i'),
                                  selected: _mood == i,
                                  onSelected: (_) {
                                    setState(() {
                                      _mood = _mood == i ? null : i;
                                    });
                                  },
                                  backgroundColor: isDark
                                      ? Colors.white.withValues(alpha: 0.08)
                                      : const Color(0xFFF5F3FA),
                                  selectedColor: accent,
                                  checkmarkColor: _saveFg,
                                  labelStyle:
                                      OnboardingTypography.bodyStyle(
                                        _mood == i ? _saveFg : tc,
                                        alpha: _mood == i
                                            ? 1
                                            : (isDark ? 0.8 : 0.85),
                                      ).copyWith(
                                        fontSize: OnboardingTypography.body - 2,
                                        fontWeight: _mood == i
                                            ? FontWeight.w700
                                            : FontWeight.normal,
                                      ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(
                                      color: _mood == i
                                          ? Colors.transparent
                                          : (isDark
                                                ? Colors.white.withValues(
                                                    alpha: 0.2,
                                                  )
                                                : const Color(0xFFE2DBF5)),
                                    ),
                                  ),
                                  showCheckmark: false,
                                ),
                              if (_mood != null)
                                PressableScale(
                                  child: IconButton(
                                    style: IconButton.styleFrom(
                                      backgroundColor: isDark
                                          ? Colors.white.withValues(alpha: 0.08)
                                          : const Color(0xFFF5F3FA),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () =>
                                        setState(() => _mood = null),
                                    icon: Icon(
                                      Icons.close,
                                      color: isDark
                                          ? Colors.white70
                                          : OnboardingTypography.textMutedColor(
                                              Brightness.light,
                                            ),
                                    ),
                                    tooltip: l10n.moodClear,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 36),
                          PressableScale(
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: accent,
                                foregroundColor: _saveFg,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(999),
                                ),
                              ),
                              onPressed: _submitting
                                  ? null
                                  : () => _onSubmit(context, l10n),
                              child: Text(
                                l10n.submitCloseDay,
                                style: const TextStyle(
                                  fontSize: OnboardingTypography.body - 2,
                                  fontWeight: FontWeight.w600,
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
          Positioned(
            left: ShellChromeMetrics.navigationBarOuterHorizontalPadding,
            bottom: assistantBottom,
            child: const _CloseDayAssistantFloat(),
          ),
        ],
      ),
    );
  }

  Future<void> _onSubmit(BuildContext context, AppLocalizations l10n) async {
    setState(() => _submitting = true);
    try {
      final service = ref.read(dayClosureServiceProvider);
      final outcome = await service.submit(
        date: parseDateKeyLocal(widget.dayKey),
        noteHighlight: _highlight.text,
        noteReflection: _reflection.text,
        mood: _mood,
      );
      ref.invalidate(dailyReportForDayProvider(widget.dayKey));
      ref.invalidate(userStatsProvider);
      if (context.mounted) {
        final voicePack = ref.read(effectiveVoicePackIdProvider);
        final assistant = assistantAfterCloseDay(
          l10n,
          outcome.tier,
          outcome.newStreak,
          voicePackId: voicePack,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 6),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${_tierTitle(l10n, outcome.tier)} · ${l10n.xpGained(outcome.xpAwarded)}',
                ),
                const SizedBox(height: 6),
                Text(assistant, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        );
        context.pop();
      }
    } on DayAlreadyClosedException {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.dayAlreadyClosed)));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$e')));
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }
}

class _CloseDayAssistantFloat extends ConsumerWidget {
  const _CloseDayAssistantFloat();

  static const double _buddySize = 136;

  static double get _buddyLeftAlignShift => _buddySize * (1 - 0.72) / 2;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layers = ref.watch(equippedAssistantLayersProvider);
    final bubble = ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 260),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.black.withValues(alpha: 0.55)
              : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withValues(alpha: 0.22)
                : OnboardingTypography.shellChromeBorderColor(Brightness.light),
          ),
          boxShadow: Theme.of(context).brightness == Brightness.light
              ? [
                  BoxShadow(
                    color: const Color(0xFF453A7A).withValues(alpha: 0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Text(
            AppLocalizations.of(context)!.assistantCloseDayBubble,
            style: OnboardingTypography.bodyStyle(
              OnboardingTypography.textColor(Theme.of(context).brightness),
              alpha: 0.95,
            ).copyWith(fontSize: OnboardingTypography.body - 2, height: 1.45),
          ),
        ),
      ),
    );
    final buddy = PressableScale(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push('/assistant'),
          customBorder: const CircleBorder(),
          child: AssistantBuddy(
            ownedLayerIds: layers.toSet(),
            size: _buddySize,
          ),
        ),
      ),
    );
    return AssistantBubbleDock(
      bubble: bubble,
      buddy: buddy,
      buddyLeftAlignShift: -_buddyLeftAlignShift,
    );
  }
}

class _ClosedSummary extends StatelessWidget {
  const _ClosedSummary({
    required this.l10n,
    required this.report,
    required this.scrollBottomPad,
  });

  final AppLocalizations l10n;
  final DailyReport report;
  final double scrollBottomPad;

  @override
  Widget build(BuildContext context) {
    final tier = DayTier.fromStorage(report.dayTier);
    final accent = OnboardingTypography.accentLavender;
    final brightness = Theme.of(context).brightness;
    final tc = OnboardingTypography.textColor(brightness);
    final isDark = brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20, 20, 20, scrollBottomPad),
      child: ChromeCard(
        borderRadius: 22,
        lightElevation: 12,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.daySummary,
                textAlign: TextAlign.center,
                style: OnboardingTypography.titleStyle(tc).copyWith(
                  fontSize: OnboardingTypography.welcome,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '${_tierTitle(l10n, tier)} · ${l10n.xpGained(report.xpAwarded)}',
                textAlign: TextAlign.center,
                style: OnboardingTypography.bodyStyle(
                  accent,
                  alpha: 1,
                ).copyWith(fontWeight: FontWeight.w600),
              ),
              if (report.mood != null) ...[
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.08)
                            : const Color(0xFFF5F3FA),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.2)
                              : const Color(0xFFE2DBF5),
                        ),
                      ),
                      child: Text(
                        '${l10n.moodOptional}: ${report.mood}',
                        style: OnboardingTypography.bodyStyle(
                          tc,
                          alpha: 0.9,
                        ).copyWith(fontSize: OnboardingTypography.body - 2),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 24),
              if (report.noteHighlight.isNotEmpty) ...[
                Text(
                  report.noteHighlight,
                  style: OnboardingTypography.bodyStyle(tc, alpha: 0.95),
                ),
                const SizedBox(height: 12),
              ],
              if (report.noteReflection.isNotEmpty)
                Text(
                  report.noteReflection,
                  style: OnboardingTypography.bodyStyle(
                    tc,
                    alpha: isDark ? 0.8 : 0.85,
                  ).copyWith(fontSize: OnboardingTypography.body - 2),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
