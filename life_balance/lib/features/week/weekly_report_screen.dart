import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:life_balance/core/date_key.dart';
import 'package:life_balance/core/week_key.dart';
import 'package:life_balance/l10n/app_localizations.dart';
import 'package:life_balance/logic/weekly_report_summary.dart';
import 'package:life_balance/providers.dart';

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

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.weeklyReportTitle),
      ),
      body: summaryAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (summary) => notesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
          data: (row) => _WeeklyReportNotesForm(
            key: ValueKey(weekKey),
            weekKey: weekKey,
            rangeLabel: range,
            summary: summary,
            initialWin: row?.noteWin ?? '',
            initialFocus: row?.noteFocus ?? '',
          ),
        ),
      ),
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

class _WeeklyReportNotesFormState extends ConsumerState<_WeeklyReportNotesForm> {
  late final TextEditingController _win;
  late final TextEditingController _focus;
  bool _saving = false;

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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final s = widget.summary;
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.rangeLabel,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          _statCard(
            context,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.weeklyReportStatsHeading,
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.weeklyReportDaysClosed(s.daysClosed, s.daysInWeek),
                ),
                const SizedBox(height: 4),
                Text(l10n.weeklyReportTierCounts(
                  s.greenDays,
                  s.yellowDays,
                  s.redDays,
                )),
                const SizedBox(height: 4),
                Text(l10n.weeklyReportXpWeek(s.weekXp)),
                const SizedBox(height: 4),
                Text(l10n.weeklyReportGoalsSummary(
                  s.goalsCompleted,
                  s.goalsTotal,
                )),
              ],
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _win,
            decoration: InputDecoration(
              labelText: l10n.weeklyNoteWinHint,
              alignLabelWithHint: true,
            ),
            textCapitalization: TextCapitalization.sentences,
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _focus,
            decoration: InputDecoration(
              labelText: l10n.weeklyNoteFocusHint,
              alignLabelWithHint: true,
            ),
            textCapitalization: TextCapitalization.sentences,
            maxLines: 3,
          ),
          const SizedBox(height: 24),
          FilledButton(
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
            child: Text(l10n.weeklyReportSave),
          ),
        ],
      ),
    );
  }

  Widget _statCard(BuildContext context, {required Widget child}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}
