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
import 'package:life_balance/ui/chrome_surfaces.dart';
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
        foregroundColor: OnboardingTypography.textColor(
          Theme.of(context).brightness,
        ),
        iconTheme: IconThemeData(
          color: OnboardingTypography.textColor(Theme.of(context).brightness),
        ),
        actionsIconTheme: IconThemeData(
          color: OnboardingTypography.textColor(Theme.of(context).brightness),
        ),
        title: Text(
          l10n.navToday,
          style: OnboardingTypography.titleStyle(
            OnboardingTypography.textColor(Theme.of(context).brightness),
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
                      elevation:
                          Theme.of(context).brightness == Brightness.light
                          ? 4
                          : 0,
                      shadowColor:
                          Theme.of(context).brightness == Brightness.light
                          ? const Color(0xFF453A7A).withValues(alpha: 0.12)
                          : Colors.transparent,
                      surfaceTintColor: Colors.transparent,
                      color: OnboardingTypography.shellChromeSurface(
                        Theme.of(context).brightness,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: OnboardingTypography.shellChromeBorderColor(
                            Theme.of(context).brightness,
                          ),
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
                                OnboardingTypography.textColor(
                                  Theme.of(context).brightness,
                                ),
                              ),
                            ),
                          ),
                          data: (goals) {
                            if (goals.isEmpty) {
                              final textColor = OnboardingTypography.textColor(
                                Theme.of(context).brightness,
                              );
                              final linkColor =
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? OnboardingTypography.accentLavender
                                  : const Color(0xFF6B5DB8);
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: ChromeCard(
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
                                                textColor,
                                              ).copyWith(
                                                fontSize: OnboardingTypography
                                                    .welcome,
                                              ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          l10n.todayWeeklyGoalsEmpty,
                                          style: OnboardingTypography.bodyStyle(
                                            textColor,
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
                                              foregroundColor: linkColor,
                                            ),
                                            child: Text(
                                              l10n.todayWeeklyGoalsOpenWeek,
                                              style:
                                                  OnboardingTypography.bodyStyle(
                                                    linkColor,
                                                    alpha: 1,
                                                  ).copyWith(
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
                          error: (e, _) => [
                            Center(
                              child: Text(
                                '$e',
                                style: OnboardingTypography.bodyStyle(
                                  OnboardingTypography.textColor(
                                    Theme.of(context).brightness,
                                  ),
                                ),
                              ),
                            ),
                          ],
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
                                        OnboardingTypography.textColor(
                                          Theme.of(context).brightness,
                                        ),
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
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black.withValues(alpha: 0.55)
                  : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withValues(alpha: 0.22)
                    : OnboardingTypography.shellChromeBorderColor(
                        Brightness.light,
                      ),
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
                AppLocalizations.of(context)!.assistantTodayBubble,
                style:
                    OnboardingTypography.bodyStyle(
                      OnboardingTypography.textColor(
                        Theme.of(context).brightness,
                      ),
                      alpha: 0.95,
                    ).copyWith(
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

class _TodayWeeklyGoalsCard extends ConsumerWidget {
  const _TodayWeeklyGoalsCard({required this.date, required this.goals});

  final DateTime date;
  final List<WeeklyGoal> goals;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final range = weekRangeDisplay(date, Localizations.localeOf(context));
    final goalsRepo = ref.read(goalsRepositoryProvider);
    final textColor = OnboardingTypography.textColor(
      Theme.of(context).brightness,
    );

    return ChromeCard(
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
                          textColor,
                        ).copyWith(fontSize: OnboardingTypography.welcome),
                      ),
                      Text(
                        range,
                        style: OnboardingTypography.bodyStyle(
                          textColor,
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
                      Theme.of(context).brightness == Brightness.dark
                          ? OnboardingTypography.accentLavender
                          : const Color(0xFF6B5DB8),
                      alpha: 1,
                    ).copyWith(fontWeight: FontWeight.w600),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark
        ? OnboardingTypography.accentLavender
        : const Color(0xFF6B5DB8);
    final textColor = OnboardingTypography.textColor(
      Theme.of(context).brightness,
    );

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            done ? Icons.check_circle : sphereIcon(sphere),
            size: 22,
            color: done ? accent : textColor.withValues(alpha: 0.7),
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
                    textColor,
                    alpha: 1,
                  ).copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: t == 0 ? 0 : p / t,
                  borderRadius: BorderRadius.circular(4),
                  color: accent,
                  backgroundColor: textColor.withValues(alpha: 0.15),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Text(
            l10n.goalProgressLabel(p, t),
            style: OnboardingTypography.bodyStyle(
              textColor,
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
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final accent = isDark
      ? OnboardingTypography.accentLavender
      : const Color(0xFF6B5DB8);
  final textColor = OnboardingTypography.textColor(
    Theme.of(context).brightness,
  );

  final titleStyle = OnboardingTypography.bodyStyle(
    textColor,
    alpha: 1,
  ).copyWith(fontWeight: FontWeight.w600, fontSize: OnboardingTypography.body);
  final subtitleStyle = OnboardingTypography.bodyStyle(
    textColor,
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
              style:
                  OnboardingTypography.bodyStyle(
                    isDark ? OnboardingTypography.accentLavender : textColor,
                    alpha: 1,
                  ).copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: OnboardingTypography.body - 4,
                  ),
            ),
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: ChromeCard(
            child: Theme(
              data: Theme.of(context).copyWith(
                checkboxTheme: CheckboxThemeData(
                  fillColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return accent;
                    }
                    if (states.contains(WidgetState.disabled)) {
                      return isDark
                          ? Colors.white.withValues(alpha: 0.12)
                          : const Color(0xFF1E1B4B).withValues(alpha: 0.12);
                    }
                    return isDark
                        ? Colors.white.withValues(alpha: 0.2)
                        : const Color(0xFF1E1B4B).withValues(alpha: 0.2);
                  }),
                  checkColor: WidgetStateProperty.all(
                    isDark ? const Color(0xFF1E1B4B) : Colors.white,
                  ),
                  side: BorderSide(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.45)
                        : const Color(0xFF1E1B4B).withValues(alpha: 0.45),
                  ),
                ),
              ),
              child: Material(
                color: r.isSkipped
                    ? (isDark
                          ? Colors.black.withValues(alpha: 0.25)
                          : Colors.white.withValues(alpha: 0.4))
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
                                      color: textColor.withValues(alpha: 0.55),
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
                            child: MenuAnchor(
                              style: menuStyleFor(context, accent: accent),
                              alignmentOffset: const Offset(0, 6),
                              menuChildren: [
                                if (r.isSkipped)
                                  MenuItemButton(
                                    onPressed: () async {
                                      await repo.setRoutineDayStatus(
                                        routineItemId: r.item.id,
                                        date: date,
                                        status: 0,
                                      );
                                    },
                                    style: MenuItemButton.styleFrom(
                                      foregroundColor: textColor,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 12,
                                      ),
                                    ),
                                    leadingIcon: Icon(
                                      Icons.undo_rounded,
                                      color: accent,
                                      size: 22,
                                    ),
                                    child: Text(
                                      l10n.routineUndoSkip,
                                      style: OnboardingTypography.bodyStyle(
                                        textColor,
                                        alpha: 0.95,
                                      ),
                                    ),
                                  )
                                else
                                  MenuItemButton(
                                    onPressed: () async {
                                      await repo.setRoutineDayStatus(
                                        routineItemId: r.item.id,
                                        date: date,
                                        status: 2,
                                      );
                                      if (!context.mounted) return;
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            runsTomorrow
                                                ? l10n.routineSkipSnackbarTomorrow
                                                : l10n.routineSkipSnackbar,
                                          ),
                                        ),
                                      );
                                    },
                                    style: MenuItemButton.styleFrom(
                                      foregroundColor: textColor,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 12,
                                      ),
                                    ),
                                    leadingIcon: Icon(
                                      Icons.event_busy_rounded,
                                      color: accent,
                                      size: 22,
                                    ),
                                    child: Text(
                                      l10n.routineSkipToday,
                                      style: OnboardingTypography.bodyStyle(
                                        textColor,
                                        alpha: 0.95,
                                      ),
                                    ),
                                  ),
                              ],
                              builder: (context, controller, _) {
                                return IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(
                                    minWidth: 40,
                                    minHeight: 40,
                                  ),
                                  icon: Icon(
                                    Icons.more_vert,
                                    color: textColor.withValues(alpha: 0.65),
                                  ),
                                  onPressed: () {
                                    if (controller.isOpen) {
                                      controller.close();
                                    } else {
                                      controller.open();
                                    }
                                  },
                                );
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
