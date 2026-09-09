import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:life_balance/core/date_key.dart';
import 'package:life_balance/core/week_key.dart';
import 'package:life_balance/l10n/app_localizations.dart';
import 'package:life_balance/logic/weekly_report_summary.dart';
import 'package:life_balance/providers.dart';
import 'package:life_balance/ui/assistant_buddy.dart';
import 'package:life_balance/ui/assistant_bubble_dock.dart';
import 'package:life_balance/ui/chrome_surfaces.dart';
import 'package:life_balance/ui/onboarding_typography.dart';
import 'package:life_balance/ui/pressable_scale.dart';
import 'package:life_balance/ui/shell_chrome_metrics.dart';

class WeeklyReportScreen extends ConsumerWidget {
  const WeeklyReportScreen({super.key, required this.weekKey});

  /// Monday of the week, `yyyy-MM-dd`.
  final String weekKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final range = weekRangeDisplay(
      parseDateKeyLocal(weekKey),
      Localizations.localeOf(context),
    );
    final summaryAsync = ref.watch(weeklyReportSummaryProvider(weekKey));
    final notesAsync = ref.watch(weeklyNotesForWeekProvider(weekKey));

    final assistantBottom = ShellChromeMetrics.assistantFloatBottomTight(
      context,
    );
    final scrollBottomPad = assistantBottom + 56;
    final brightness = Theme.of(context).brightness;
    final tc = OnboardingTypography.textColor(brightness);

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
          l10n.weeklyReportTitle,
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
            child: summaryAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Text('$e', style: TextStyle(color: tc)),
              ),
              data: (summary) => notesAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(
                  child: Text('$e', style: TextStyle(color: tc)),
                ),
                data: (row) => SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, scrollBottomPad),
                  child: _WeeklyReportNotesForm(
                    key: ValueKey(weekKey),
                    weekKey: weekKey,
                    rangeLabel: range,
                    summary: summary,
                    initialWin: row?.noteWin ?? '',
                    initialFocus: row?.noteFocus ?? '',
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: ShellChromeMetrics.navigationBarOuterHorizontalPadding,
            bottom: assistantBottom,
            child: const _WeeklyReportAssistantFloat(),
          ),
        ],
      ),
    );
  }
}

class _WeeklyReportAssistantFloat extends ConsumerWidget {
  const _WeeklyReportAssistantFloat();

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
            AppLocalizations.of(context)!.assistantReviewWeekBubble,
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

class _WeeklyReportNotesForm extends ConsumerStatefulWidget {
  const _WeeklyReportNotesForm({
    super.key,
    required this.weekKey,
    required this.rangeLabel,
    required this.summary,
    required this.initialWin,
    required this.initialFocus,
  });

  final String weekKey;
  final String rangeLabel;
  final WeeklyReportSummary summary;
  final String initialWin;
  final String initialFocus;

  @override
  ConsumerState<_WeeklyReportNotesForm> createState() =>
      _WeeklyReportNotesFormState();
}

class _WeeklyReportNotesFormState
    extends ConsumerState<_WeeklyReportNotesForm> {
  late final TextEditingController _win;
  late final TextEditingController _focus;
  bool _saving = false;

  static const Color _saveFg = Color(0xFF1E1B4B);

  @override
  void initState() {
    super.initState();
    _win = TextEditingController(text: widget.initialWin);
    _focus = TextEditingController(text: widget.initialFocus);
  }

  @override
  void didUpdateWidget(covariant _WeeklyReportNotesForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialWin != widget.initialWin) {
      _win.text = widget.initialWin;
    }
    if (oldWidget.initialFocus != widget.initialFocus) {
      _focus.text = widget.initialFocus;
    }
  }

  @override
  void dispose() {
    _win.dispose();
    _focus.dispose();
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
      alignLabelWithHint: true,
    );
  }

  Widget _statCard(BuildContext context, {required Widget child}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.08)
            : const Color(0xFFF5F3FA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.2)
              : const Color(0xFFE2DBF5),
        ),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final s = widget.summary;
    final accent = OnboardingTypography.accentLavender;
    final brightness = Theme.of(context).brightness;
    final tc = OnboardingTypography.textColor(brightness);

    return ChromeCard(
      borderRadius: 22,
      lightElevation: 12,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.rangeLabel,
              textAlign: TextAlign.center,
              style: OnboardingTypography.titleStyle(tc).copyWith(
                fontSize: OnboardingTypography.welcome,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            _statCard(
              context,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.weeklyReportStatsHeading,
                    style: OnboardingTypography.titleStyle(tc).copyWith(
                      fontSize: OnboardingTypography.body,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.weeklyReportDaysClosed(s.daysClosed, s.daysInWeek),
                    style: OnboardingTypography.bodyStyle(tc, alpha: 0.9),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.weeklyReportTierCounts(
                      s.greenDays,
                      s.yellowDays,
                      s.redDays,
                    ),
                    style: OnboardingTypography.bodyStyle(tc, alpha: 0.9),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.weeklyReportXpWeek(s.weekXp),
                    style: OnboardingTypography.bodyStyle(
                      accent,
                      alpha: 1,
                    ).copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.weeklyReportGoalsSummary(
                      s.goalsCompleted,
                      s.goalsTotal,
                    ),
                    style: OnboardingTypography.bodyStyle(tc, alpha: 0.9),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _win,
              style: OnboardingTypography.bodyStyle(tc, alpha: 0.96),
              decoration: _inputDecoration(
                accent: accent,
                brightness: brightness,
                labelText: l10n.weeklyNoteWinHint,
              ),
              textCapitalization: TextCapitalization.sentences,
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _focus,
              style: OnboardingTypography.bodyStyle(tc, alpha: 0.96),
              decoration: _inputDecoration(
                accent: accent,
                brightness: brightness,
                labelText: l10n.weeklyNoteFocusHint,
              ),
              textCapitalization: TextCapitalization.sentences,
              maxLines: 3,
            ),
            const SizedBox(height: 32),
            PressableScale(
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: accent,
                  foregroundColor: _saveFg,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                onPressed: _saving
                    ? null
                    : () async {
                        setState(() => _saving = true);
                        try {
                          await ref
                              .read(weeklyReportRepositoryProvider)
                              .saveNotes(
                                weekKey: widget.weekKey,
                                noteWin: _win.text.trim(),
                                noteFocus: _focus.text.trim(),
                              );
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l10n.weeklyReportSaved)),
                            );
                          }
                        } finally {
                          if (mounted) setState(() => _saving = false);
                        }
                      },
                child: Text(
                  l10n.weeklyReportSave,
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
    );
  }
}
