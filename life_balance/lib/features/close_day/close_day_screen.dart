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

  @override
  void dispose() {
    _highlight.dispose();
    _reflection.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final date = parseDateKeyLocal(widget.dayKey);
    final reportAsync = ref.watch(dailyReportForDayProvider(widget.dayKey));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.closeDayTitle),
      ),
      body: reportAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (existing) {
          if (existing != null) {
            return _ClosedSummary(l10n: l10n, report: existing);
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  DateFormat.yMMMEd(
                    dateFormatLocaleForIntl(Localizations.localeOf(context)),
                  ).format(date),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.reportQualityTip,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _highlight,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: l10n.noteHighlightHint,
                    border: const OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _reflection,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: l10n.noteReflectionHint,
                    border: const OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.moodOptional,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    for (var i = 1; i <= 5; i++)
                      Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: ChoiceChip(
                          label: Text('$i'),
                          selected: _mood == i,
                          onSelected: (_) {
                            setState(() {
                              _mood = _mood == i ? null : i;
                            });
                          },
                        ),
                      ),
                    TextButton(
                      onPressed: () => setState(() => _mood = null),
                      child: Text(l10n.moodClear),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: _submitting ? null : () => _onSubmit(context, l10n),
                  child: Text(l10n.submitCloseDay),
                ),
              ],
            ),
          );
        },
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
                Text(
                  assistant,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        );
        context.pop();
      }
    } on DayAlreadyClosedException {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.dayAlreadyClosed)),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$e')),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }
}

class _ClosedSummary extends StatelessWidget {
  const _ClosedSummary({
    required this.l10n,
    required this.report,
  });

  final AppLocalizations l10n;
  final DailyReport report;

  @override
  Widget build(BuildContext context) {
    final tier = DayTier.fromStorage(report.dayTier);
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          l10n.daySummary,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Text(
          '${_tierTitle(l10n, tier)} · ${l10n.xpGained(report.xpAwarded)}',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        if (report.mood != null) ...[
          const SizedBox(height: 8),
          Text('${l10n.moodOptional}: ${report.mood}'),
        ],
        const SizedBox(height: 16),
        Text(report.noteHighlight),
        const SizedBox(height: 8),
        Text(report.noteReflection),
      ],
    );
  }
}
