import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:life_balance/core/date_key.dart'
    show dateKey, routineRunsOnWeekday;
import 'package:life_balance/core/schedule_format.dart';
import 'package:life_balance/core/week_key.dart';
import 'package:life_balance/data/drift/app_database.dart';
import 'package:life_balance/domain/life_sphere.dart';
import 'package:life_balance/logic/assistant_picker.dart';
import 'package:life_balance/data/routine_repository.dart';
import 'package:life_balance/l10n/app_localizations.dart';
import 'package:life_balance/providers.dart';
import 'package:life_balance/ui/assistant_buddy.dart';
import 'package:life_balance/ui/sphere_ui.dart';

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final date = ref.watch(todayDateProvider);
    final asyncRows = ref.watch(todayRoutineProvider);
    final asyncWeekGoals = ref.watch(todayWeekGoalsProvider);
    final dateLabel = DateFormat.yMMMEd(
      dateFormatLocaleForIntl(Localizations.localeOf(context)),
    ).format(date);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navToday),
        actions: [
          IconButton(
            icon: const Icon(Icons.nightlight_round),
            tooltip: l10n.closeDay,
            onPressed: () => context.push('/close-day?d=${dateKey(date)}'),
          ),
          IconButton(
            icon: const Icon(Icons.today_outlined),
            tooltip: l10n.jumpToToday,
            onPressed: () {
              final t = DateTime.now();
              ref.read(todayDateProvider.notifier).state =
                  DateTime(t.year, t.month, t.day);
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            elevation: 0,
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      ref.read(todayDateProvider.notifier).state =
                          date.subtract(const Duration(days: 1));
                    },
                    icon: const Icon(Icons.chevron_left),
                  ),
                  Expanded(
                    child: Text(
                      dateLabel,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      ref.read(todayDateProvider.notifier).state =
                          date.add(const Duration(days: 1));
                    },
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
              children: [
                Consumer(
                  builder: (context, ref, _) {
                    final layers = ref.watch(equippedAssistantLayersProvider);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () => context.push('/assistant'),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                AssistantBuddy(
                                  ownedLayerIds: layers.toSet(),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        l10n.assistantTodayCardTitle,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        l10n.assistantTodayCardHint,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurfaceVariant,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                asyncWeekGoals.when(
                  loading: () => const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: LinearProgressIndicator(),
                  ),
                  error: (e, _) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text('$e'),
                  ),
                  data: (goals) {
                    if (goals.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  l10n.todayWeeklyGoalsHeading,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  l10n.todayWeeklyGoalsEmpty,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 8),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: TextButton(
                                    onPressed: () {
                                      ref
                                              .read(
                                                weekPageAnchorProvider
                                                    .notifier,
                                              )
                                              .state =
                                          mondayOfWeekContaining(date);
                                      context.go('/week');
                                    },
                                    child: Text(l10n.todayWeeklyGoalsOpenWeek),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _TodayWeeklyGoalsCard(
                        date: date,
                        goals: goals,
                      ),
                    );
                  },
                ),
                ...asyncRows.when(
                  loading: () => [
                    if (!asyncWeekGoals.isLoading)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 32),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                  ],
                  error: (e, _) => [Center(child: Text('$e'))],
                  data: (rows) {
                    if (rows.isEmpty) {
                      return [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Center(
                            child: Text(
                              l10n.todayEmpty,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ];
                    }
                    final repo = ref.read(routineRepositoryProvider);
                    final theme = Theme.of(context);
                    return rows
                        .map(
                          (r) => _todayRoutineTile(
                            context: context,
                            l10n: l10n,
                            locale: Localizations.localeOf(context),
                            theme: theme,
                            repo: repo,
                            date: date,
                            r: r,
                          ),
                        )
                        .toList();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TodayWeeklyGoalsCard extends ConsumerWidget {
  const _TodayWeeklyGoalsCard({
    required this.date,
    required this.goals,
  });

  final DateTime date;
  final List<WeeklyGoal> goals;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final range = weekRangeDisplay(date, Localizations.localeOf(context));
    final goalsRepo = ref.read(goalsRepositoryProvider);
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 8, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.todayWeeklyGoalsHeading,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Text(
                        range,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ref.read(weekPageAnchorProvider.notifier).state =
                        mondayOfWeekContaining(date);
                    context.go('/week');
                  },
                  child: Text(l10n.todayWeeklyGoalsOpenWeek),
                ),
              ],
            ),
            const SizedBox(height: 4),
            ...goals.map(
              (g) {
                final t = g.targetCount <= 0 ? 1 : g.targetCount;
                final p = g.progressCount.clamp(0, t);
                return _CompactTodayGoalRow(
                  goal: g,
                  onBump: () async {
                    final willComplete = p + 1 >= t;
                    await goalsRepo.bumpProgress(g.id, 1);
                    if (!context.mounted) return;
                    if (willComplete) {
                      final voicePack =
                          ref.read(effectiveVoicePackIdProvider);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: const Duration(seconds: 5),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(l10n.goalDone),
                              const SizedBox(height: 6),
                              Text(
                                assistantAfterWeeklyGoalDone(
                                  l10n,
                                  voicePackId: voicePack,
                                ),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                  l10n: l10n,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _CompactTodayGoalRow extends StatelessWidget {
  const _CompactTodayGoalRow({
    required this.goal,
    required this.onBump,
    required this.l10n,
  });

  final WeeklyGoal goal;
  final VoidCallback onBump;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final sphere = LifeSphereStorage.parseOrWork(goal.sphere);
    final t = goal.targetCount <= 0 ? 1 : goal.targetCount;
    final p = goal.progressCount.clamp(0, t);
    final done = p >= t || goal.status == 1;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            done ? Icons.check_circle : sphereIcon(sphere),
            size: 22,
            color:
                done ? Theme.of(context).colorScheme.primary : null,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  goal.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: t == 0 ? 0 : p / t,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Text(
            l10n.goalProgressLabel(p, t),
            style: Theme.of(context).textTheme.labelSmall,
          ),
          if (!done)
            IconButton(
              padding: EdgeInsets.zero,
              constraints:
                  const BoxConstraints(minWidth: 40, minHeight: 40),
              tooltip: l10n.addProgress,
              onPressed: onBump,
              icon: const Icon(Icons.add_circle_outline, size: 24),
            ),
        ],
      ),
    );
  }
}

enum _RoutineDayMenu { skip, undoSkip }

Widget _todayRoutineTile({
  required BuildContext context,
  required AppLocalizations l10n,
  required Locale locale,
  required ThemeData theme,
  required RoutineRepository repo,
  required DateTime date,
  required TodayRoutineRow r,
}) {
  final sphere = LifeSphereStorage.parseOrWork(r.item.sphere);
  final timeLabel =
      formatScheduledTime(l10n, locale, r.item.scheduledMinuteOfDay);
  final tomorrow = date.add(const Duration(days: 1));
  final runsTomorrow =
      routineRunsOnWeekday(r.item.weekdays, tomorrow.weekday);

  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 76,
          child: Padding(
            padding: const EdgeInsets.only(top: 18),
            child: Text(
              timeLabel,
              textAlign: TextAlign.end,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Card(
            color: r.isSkipped
                ? theme.colorScheme.surfaceContainerLow
                : null,
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () {
                if (r.isSkipped) {
                  repo.setRoutineDayStatus(
                    routineItemId: r.item.id,
                    date: date,
                    status: 0,
                  );
                } else {
                  repo.setItemDone(
                    routineItemId: r.item.id,
                    date: date,
                    done: !r.isDone,
                  );
                }
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
                child: Row(
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        tristate: true,
                        value: r.isSkipped
                            ? null
                            : r.isDone,
                        onChanged: r.isSkipped
                            ? null
                            : (v) {
                                if (v == null) return;
                                repo.setItemDone(
                                  routineItemId: r.item.id,
                                  date: date,
                                  done: v,
                                );
                              },
                        title: Text(
                          r.item.title,
                          style: r.isSkipped
                              ? theme.textTheme.titleMedium?.copyWith(
                                  color: theme
                                      .colorScheme.onSurfaceVariant,
                                )
                              : null,
                        ),
                        subtitle: Text(
                          r.isSkipped
                              ? l10n.routineSkippedForToday
                              : sphereLabel(l10n, sphere),
                        ),
                        secondary: Icon(sphereIcon(sphere)),
                        controlAffinity:
                            ListTileControlAffinity.platform,
                        contentPadding: const EdgeInsets.only(
                          left: 8,
                          right: 4,
                        ),
                      ),
                    ),
                    if (!r.isDone || r.isSkipped)
                      Padding(
                        padding: const EdgeInsets.only(right: 4, top: 8),
                        child: PopupMenuButton<_RoutineDayMenu>(
                          icon: Icon(
                            Icons.more_vert,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          onSelected: (action) async {
                            switch (action) {
                              case _RoutineDayMenu.skip:
                                await repo.setRoutineDayStatus(
                                  routineItemId: r.item.id,
                                  date: date,
                                  status: 2,
                                );
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      runsTomorrow
                                          ? l10n
                                              .routineSkipSnackbarTomorrow
                                          : l10n.routineSkipSnackbar,
                                    ),
                                  ),
                                );
                              case _RoutineDayMenu.undoSkip:
                                await repo.setRoutineDayStatus(
                                  routineItemId: r.item.id,
                                  date: date,
                                  status: 0,
                                );
                            }
                          },
                          itemBuilder: (ctx) {
                            if (r.isSkipped) {
                              return [
                                PopupMenuItem(
                                  value: _RoutineDayMenu.undoSkip,
                                  child: Text(l10n.routineUndoSkip),
                                ),
                              ];
                            }
                            return [
                              PopupMenuItem(
                                value: _RoutineDayMenu.skip,
                                child: Text(l10n.routineSkipToday),
                              ),
                            ];
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
