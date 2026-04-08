import 'dart:ui' show ImageFilter;

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
import 'package:life_balance/ui/onboarding_typography.dart';
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

    final topInset = MediaQuery.paddingOf(context).top + kToolbarHeight;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        actionsIconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          l10n.navToday,
          style: OnboardingTypography.titleStyle(
            Colors.white,
          ).copyWith(fontSize: OnboardingTypography.welcome),
        ),
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
              ref.read(todayDateProvider.notifier).state = DateTime(
                t.year,
                t.month,
                t.day,
              );
            },
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SafeArea(
            top: false,
            bottom: true,
            child: Padding(
              padding: EdgeInsets.only(top: topInset),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                    child: Material(
                      elevation: 0,
                      color: OnboardingTypography.shellChromeSurface(
                        Theme.of(context).brightness,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: OnboardingTypography.shellChromeBorderColor(),
                          width: 1,
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                ref.read(todayDateProvider.notifier).state =
                                    date.subtract(const Duration(days: 1));
                              },
                              icon: const Icon(Icons.chevron_left),
                              color: OnboardingTypography.shellChromeNavIcon(
                                Theme.of(context).brightness,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                dateLabel,
                                textAlign: TextAlign.center,
                                style: OnboardingTypography.bodyStyle(
                                  Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : const Color(0xFF2D2548),
                                  alpha: 0.95,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                ref.read(todayDateProvider.notifier).state =
                                    date.add(const Duration(days: 1));
                              },
                              icon: const Icon(Icons.chevron_right),
                              color: OnboardingTypography.shellChromeNavIcon(
                                Theme.of(context).brightness,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 164),
                      children: [
                        asyncWeekGoals.when(
                          loading: () => const Padding(
                            padding: EdgeInsets.only(bottom: 12),
                            child: LinearProgressIndicator(
                              color: Color(0xFFB8A9F9),
                            ),
                          ),
                          error: (e, _) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Text(
                              '$e',
                              style: OnboardingTypography.bodyStyle(
                                Colors.white,
                              ),
                            ),
                          ),
                          data: (goals) {
                            if (goals.isEmpty) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _TodayGlassPanel(
                                  borderRadius: 16,
                                  child: Padding(
                                    padding: const EdgeInsets.all(14),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                          l10n.todayWeeklyGoalsHeading,
                                          style:
                                              OnboardingTypography.titleStyle(
                                                Colors.white,
                                              ).copyWith(
                                                fontSize: OnboardingTypography
                                                    .welcome,
                                              ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          l10n.todayWeeklyGoalsEmpty,
                                          style: OnboardingTypography.bodyStyle(
                                            Colors.white,
                                          ),
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
                                            style: TextButton.styleFrom(
                                              foregroundColor:
                                                  OnboardingTypography
                                                      .accentLavender,
                                            ),
                                            child: Text(
                                              l10n.todayWeeklyGoalsOpenWeek,
                                              style:
                                                  OnboardingTypography.bodyStyle(
                                                    OnboardingTypography
                                                        .accentLavender,
                                                    alpha: 1,
                                                  ),
                                            ),
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
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                          ],
                          error: (e, _) => [Center(child: Text('$e'))],
                          data: (rows) {
                            if (rows.isEmpty) {
                              return [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 24,
                                  ),
                                  child: Center(
                                    child: Text(
                                      l10n.todayEmpty,
                                      textAlign: TextAlign.center,
                                      style: OnboardingTypography.bodyStyle(
                                        Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ];
                            }
                            final repo = ref.read(routineRepositoryProvider);
                            return rows
                                .map(
                                  (r) => _todayRoutineTile(
                                    context: context,
                                    l10n: l10n,
                                    locale: Localizations.localeOf(context),
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
            ),
          ),
          Positioned(
            right: 8,
            bottom: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 4, right: 4),
                child: const _TodayAssistantFloat(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TodayAssistantFloat extends ConsumerWidget {
  const _TodayAssistantFloat();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layers = ref.watch(equippedAssistantLayersProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 240),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Text(
                AppLocalizations.of(context)!.assistantTodayBubble,
                style: OnboardingTypography.bodyStyle(Colors.white, alpha: 0.95)
                    .copyWith(
                      fontSize: OnboardingTypography.body - 2,
                      height: 1.45,
                    ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => context.push('/assistant'),
            customBorder: const CircleBorder(),
            child: AssistantBuddy(ownedLayerIds: layers.toSet(), size: 136),
          ),
        ),
      ],
    );
  }
}

class _TodayGlassPanel extends StatelessWidget {
  const _TodayGlassPanel({required this.child, this.borderRadius = 18});

  final Widget child;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final accent = OnboardingTypography.accentLavender;
    final borderColor = Color.lerp(
      accent,
      Colors.white,
      0.55,
    )!.withValues(alpha: 0.42);
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: borderColor, width: 1),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.14),
                Colors.white.withValues(alpha: 0.05),
                accent.withValues(alpha: 0.06),
              ],
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _TodayWeeklyGoalsCard extends ConsumerWidget {
  const _TodayWeeklyGoalsCard({required this.date, required this.goals});

  final DateTime date;
  final List<WeeklyGoal> goals;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final range = weekRangeDisplay(date, Localizations.localeOf(context));
    final goalsRepo = ref.read(goalsRepositoryProvider);
    return _TodayGlassPanel(
      borderRadius: 16,
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
                        style: OnboardingTypography.titleStyle(
                          Colors.white,
                        ).copyWith(fontSize: OnboardingTypography.welcome),
                      ),
                      Text(
                        range,
                        style: OnboardingTypography.bodyStyle(
                          Colors.white,
                          alpha: 0.65,
                        ).copyWith(fontSize: OnboardingTypography.body - 4),
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
                  style: TextButton.styleFrom(
                    foregroundColor: OnboardingTypography.accentLavender,
                  ),
                  child: Text(
                    l10n.todayWeeklyGoalsOpenWeek,
                    style: OnboardingTypography.bodyStyle(
                      OnboardingTypography.accentLavender,
                      alpha: 1,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            ...goals.map((g) {
              final t = g.targetCount <= 0 ? 1 : g.targetCount;
              final p = g.progressCount.clamp(0, t);
              return _CompactTodayGoalRow(
                goal: g,
                onBump: () async {
                  final willComplete = p + 1 >= t;
                  await goalsRepo.bumpProgress(g.id, 1);
                  if (!context.mounted) return;
                  if (willComplete) {
                    final voicePack = ref.read(effectiveVoicePackIdProvider);
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
            }),
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
    final accent = OnboardingTypography.accentLavender;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            done ? Icons.check_circle : sphereIcon(sphere),
            size: 22,
            color: done ? accent : Colors.white.withValues(alpha: 0.9),
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
                  style: OnboardingTypography.bodyStyle(
                    Colors.white,
                    alpha: 1,
                  ).copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: t == 0 ? 0 : p / t,
                  borderRadius: BorderRadius.circular(4),
                  color: accent,
                  backgroundColor: Colors.white.withValues(alpha: 0.15),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Text(
            l10n.goalProgressLabel(p, t),
            style: OnboardingTypography.bodyStyle(
              Colors.white,
              alpha: 0.7,
            ).copyWith(fontSize: OnboardingTypography.body - 6),
          ),
          if (!done)
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              tooltip: l10n.addProgress,
              onPressed: onBump,
              icon: Icon(Icons.add_circle_outline, size: 24, color: accent),
            ),
        ],
      ),
    );
  }
}

/// Непрозора кнопка дії в меню «⋯» (skip / undo) у стилі хром-плашок додатка.
class _RoutinePopupMenuAction extends StatelessWidget {
  const _RoutinePopupMenuAction({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final accent = OnboardingTypography.accentLavender;
    const fill = Color(0xFF3D355F);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Color.lerp(
            accent,
            Colors.white,
            0.38,
          )!.withValues(alpha: 0.58),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.14),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: accent),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              label,
              style: OnboardingTypography.bodyStyle(Colors.white, alpha: 0.96)
                  .copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: OnboardingTypography.body - 2,
                  ),
            ),
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
  required RoutineRepository repo,
  required DateTime date,
  required TodayRoutineRow r,
}) {
  final sphere = LifeSphereStorage.parseOrWork(r.item.sphere);
  final timeLabel = formatScheduledTime(
    l10n,
    locale,
    r.item.scheduledMinuteOfDay,
  );
  final tomorrow = date.add(const Duration(days: 1));
  final runsTomorrow = routineRunsOnWeekday(r.item.weekdays, tomorrow.weekday);
  final accent = OnboardingTypography.accentLavender;
  final titleStyle = OnboardingTypography.bodyStyle(
    Colors.white,
    alpha: 1,
  ).copyWith(fontWeight: FontWeight.w600, fontSize: OnboardingTypography.body);
  final subtitleStyle = OnboardingTypography.bodyStyle(
    Colors.white,
    alpha: 0.65,
  ).copyWith(fontSize: OnboardingTypography.body - 6);

  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 92,
          child: Padding(
            padding: const EdgeInsets.only(top: 18),
            child: Text(
              timeLabel,
              textAlign: TextAlign.start,
              maxLines: 1,
              softWrap: false,
              style: OnboardingTypography.bodyStyle(accent, alpha: 1).copyWith(
                fontWeight: FontWeight.w600,
                fontSize: OnboardingTypography.body - 4,
              ),
            ),
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: _TodayGlassPanel(
            child: Theme(
              data: Theme.of(context).copyWith(
                checkboxTheme: CheckboxThemeData(
                  fillColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return accent;
                    }
                    if (states.contains(WidgetState.disabled)) {
                      return Colors.white.withValues(alpha: 0.12);
                    }
                    return Colors.white.withValues(alpha: 0.2);
                  }),
                  checkColor: WidgetStateProperty.all(const Color(0xFF1E1B4B)),
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.45)),
                ),
              ),
              child: Material(
                color: r.isSkipped
                    ? Colors.black.withValues(alpha: 0.25)
                    : Colors.transparent,
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
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 0,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: CheckboxListTile(
                            tristate: true,
                            value: r.isSkipped ? null : r.isDone,
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
                                  ? titleStyle.copyWith(
                                      color: Colors.white.withValues(
                                        alpha: 0.55,
                                      ),
                                    )
                                  : titleStyle,
                            ),
                            subtitle: Text(
                              r.isSkipped
                                  ? l10n.routineSkippedForToday
                                  : sphereLabel(l10n, sphere),
                              style: subtitleStyle,
                            ),
                            secondary: Icon(sphereIcon(sphere), color: accent),
                            controlAffinity: ListTileControlAffinity.platform,
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
                              elevation: 8,
                              color: const Color(0xFF201C38),
                              surfaceTintColor: Colors.transparent,
                              shadowColor: Colors.black.withValues(alpha: 0.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              menuPadding: const EdgeInsets.all(10),
                              constraints: const BoxConstraints(minWidth: 220),
                              icon: Icon(
                                Icons.more_vert,
                                color: Colors.white.withValues(alpha: 0.65),
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
                                              ? l10n.routineSkipSnackbarTomorrow
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
                                    PopupMenuItem<_RoutineDayMenu>(
                                      padding: EdgeInsets.zero,
                                      value: _RoutineDayMenu.undoSkip,
                                      child: _RoutinePopupMenuAction(
                                        label: l10n.routineUndoSkip,
                                        icon: Icons.undo_rounded,
                                      ),
                                    ),
                                  ];
                                }
                                return [
                                  PopupMenuItem<_RoutineDayMenu>(
                                    padding: EdgeInsets.zero,
                                    value: _RoutineDayMenu.skip,
                                    child: _RoutinePopupMenuAction(
                                      label: l10n.routineSkipToday,
                                      icon: Icons.event_busy_rounded,
                                    ),
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
          ),
        ),
      ],
    ),
  );
}
