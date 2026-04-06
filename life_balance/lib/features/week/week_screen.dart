import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:life_balance/core/week_key.dart';
import 'package:life_balance/domain/life_sphere.dart';
import 'package:life_balance/logic/assistant_picker.dart';
import 'package:life_balance/l10n/app_localizations.dart';
import 'package:life_balance/providers.dart';
import 'package:life_balance/ui/sphere_ui.dart';
import 'package:life_balance/features/week/week_quality_strip.dart';

class WeekScreen extends ConsumerWidget {
  const WeekScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lApp = AppLocalizations.of(context)!;
    final anchor = ref.watch(weekPageAnchorProvider);
    final thisMonday = mondayOfWeekContaining(DateTime.now());
    final isThisWeek = weekKeyFromDate(anchor) == weekKeyFromDate(thisMonday);
    final range =
        weekRangeDisplay(anchor, Localizations.localeOf(context));
    final monday = mondayOfWeekContaining(anchor);
    final asyncGoals = ref.watch(weeklyGoalsProvider);
    final asyncQuality = ref.watch(weekQualityStripProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(lApp.navWeek),
        actions: [
          IconButton(
            tooltip: lApp.weeklyReportOpen,
            onPressed: () => context.push(
              '/weekly-report?w=${weekKeyFromDate(anchor)}',
            ),
            icon: const Icon(Icons.insights_outlined),
          ),
          if (!isThisWeek)
            TextButton(
              onPressed: () {
                ref.read(weekPageAnchorProvider.notifier).state = thisMonday;
              },
              child: Text(lApp.thisWeek),
            ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    tooltip: lApp.previousWeek,
                    onPressed: () {
                      ref.read(weekPageAnchorProvider.notifier).state =
                          anchor.subtract(const Duration(days: 7));
                    },
                    icon: const Icon(Icons.chevron_left),
                  ),
                  Expanded(
                    child: Text(
                      range,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  IconButton(
                    tooltip: lApp.nextWeek,
                    onPressed: () {
                      ref.read(weekPageAnchorProvider.notifier).state =
                          anchor.add(const Duration(days: 7));
                    },
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: asyncQuality.when(
                      loading: () => const SizedBox(
                        height: 100,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      error: (e, _) => Text('$e'),
                      data: (byDay) => WeekQualityStrip(
                        monday: monday,
                        byDayKey: byDay,
                        onDayTap: (day) {
                          ref.read(todayDateProvider.notifier).state =
                              DateTime(day.year, day.month, day.day);
                          context.go('/today');
                        },
                      ),
                    ),
                  ),
                ),
                asyncGoals.when(
                  loading: () => const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (e, _) => SliverFillRemaining(
                    child: Center(child: Text('$e')),
                  ),
                  data: (goals) {
                    if (goals.isEmpty) {
                      return SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              lApp.weekGoalsEmpty,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    }
                    final goalsRepo = ref.read(goalsRepositoryProvider);
                    return SliverPadding(
                      padding: const EdgeInsets.only(bottom: 88),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, i) {
                            final g = goals[i];
                            final sphere =
                                LifeSphereStorage.parseOrWork(g.sphere);
                            final t =
                                g.targetCount <= 0 ? 1 : g.targetCount;
                            final p = g.progressCount.clamp(0, t);
                            final done = p >= t || g.status == 1;
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          done
                                              ? Icons.check_circle
                                              : sphereIcon(sphere),
                                          color: done
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                              : null,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            g.title,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete_outline,
                                          ),
                                          tooltip: lApp.delete,
                                          onPressed: () async {
                                            final ok =
                                                await showDialog<bool>(
                                              context: context,
                                              builder: (ctx) =>
                                                  AlertDialog(
                                                title: Text(lApp.delete),
                                                content: Text(g.title),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            ctx, false),
                                                    child: Text(
                                                      MaterialLocalizations.of(
                                                              ctx)
                                                          .cancelButtonLabel,
                                                    ),
                                                  ),
                                                  FilledButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            ctx, true),
                                                    child:
                                                        Text(lApp.delete),
                                                  ),
                                                ],
                                              ),
                                            );
                                            if (ok == true &&
                                                context.mounted) {
                                              await goalsRepo
                                                  .deleteGoal(g.id);
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                    Text(
                                      sphereLabel(lApp, sphere),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall,
                                    ),
                                    const SizedBox(height: 8),
                                    LinearProgressIndicator(
                                      value: t == 0 ? 0 : p / t,
                                      borderRadius:
                                          BorderRadius.circular(4),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Text(
                                          lApp.goalProgressLabel(p, t),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                        const Spacer(),
                                        if (!done)
                                          FilledButton.tonal(
                                            onPressed: () async {
                                              final willComplete =
                                                  p + 1 >= t;
                                              await goalsRepo.bumpProgress(
                                                g.id,
                                                1,
                                              );
                                              if (!context.mounted) return;
                                              if (willComplete) {
                                                final voicePack = ref.read(
                                                  effectiveVoicePackIdProvider,
                                                );
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    duration: const Duration(
                                                      seconds: 5,
                                                    ),
                                                    content: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(lApp.goalDone),
                                                        const SizedBox(
                                                          height: 6,
                                                        ),
                                                        Text(
                                                          assistantAfterWeeklyGoalDone(
                                                            lApp,
                                                            voicePackId:
                                                                voicePack,
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
                                              }
                                            },
                                            child: Text(lApp.addProgress),
                                          )
                                        else
                                          Text(
                                            lApp.goalDone,
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
                                  ],
                                ),
                              ),
                            );
                          },
                          childCount: goals.length,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddGoal(context, ref),
        icon: const Icon(Icons.add),
        label: Text(lApp.addWeeklyGoal),
      ),
    );
  }
}

class _NewWeeklyGoalResult {
  const _NewWeeklyGoalResult({
    required this.title,
    required this.sphere,
    required this.targetCount,
  });

  final String title;
  final LifeSphere sphere;
  final int targetCount;
}

Future<void> _openAddGoal(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context)!;
  final weekKey = ref.read(selectedWeekKeyProvider);
  final titleController = TextEditingController();
  final targetController = TextEditingController(text: '1');

  try {
    final result = await showDialog<_NewWeeklyGoalResult>(
      context: context,
      builder: (ctx) {
        var sphere = LifeSphere.work;
        return StatefulBuilder(
          builder: (ctx, setState) {
            return AlertDialog(
              title: Text(l10n.addWeeklyGoal),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: l10n.weeklyGoalTitleHint,
                      ),
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: targetController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: l10n.targetTimes,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.sphereFieldLabel,
                      style: Theme.of(ctx).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 4),
                    DropdownButton<LifeSphere>(
                      isExpanded: true,
                      value: sphere,
                      items: LifeSphere.values
                          .map(
                            (s) => DropdownMenuItem(
                              value: s,
                              child: Text(sphereLabel(l10n, s)),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        if (v != null) setState(() => sphere = v);
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(
                    MaterialLocalizations.of(ctx).cancelButtonLabel,
                  ),
                ),
                FilledButton(
                  onPressed: () {
                    final title = titleController.text.trim();
                    final t = int.tryParse(targetController.text.trim()) ?? 1;
                    if (title.isEmpty) return;
                    Navigator.pop(
                      ctx,
                      _NewWeeklyGoalResult(
                        title: title,
                        sphere: sphere,
                        targetCount: t < 1 ? 1 : t,
                      ),
                    );
                  },
                  child: Text(l10n.save),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null && context.mounted) {
      await ref.read(goalsRepositoryProvider).addGoal(
            weekKey: weekKey,
            sphere: result.sphere.id,
            title: result.title,
            targetCount: result.targetCount,
          );
    }
  } finally {
    titleController.dispose();
    targetController.dispose();
  }
}
