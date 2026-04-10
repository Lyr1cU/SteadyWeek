import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:life_balance/core/week_key.dart';
import 'package:life_balance/domain/life_sphere.dart';
import 'package:life_balance/logic/assistant_picker.dart';
import 'package:life_balance/l10n/app_localizations.dart';
import 'package:life_balance/providers.dart';
import 'package:life_balance/ui/assistant_buddy.dart';
import 'package:life_balance/ui/onboarding_typography.dart';
import 'package:life_balance/ui/sphere_ui.dart';
import 'package:life_balance/features/week/week_quality_strip.dart';

class WeekScreen extends ConsumerWidget {
  const WeekScreen({super.key});

  /// Горизонтальні відступи як у MainShell `Padding.fromLTRB(12, …)` навколо навбара.
  static const double _shellHorizontalPad = 12;

  /// Від дна екрана до низу асистента/FAB (підібрано ~116 + viewPadding).
  static double _fabBottomFromScreen(BuildContext context) {
    return MediaQuery.viewPaddingOf(context).bottom + 120;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lApp = AppLocalizations.of(context)!;
    final anchor = ref.watch(weekPageAnchorProvider);
    final thisMonday = mondayOfWeekContaining(DateTime.now());
    final isThisWeek = weekKeyFromDate(anchor) == weekKeyFromDate(thisMonday);
    final range = weekRangeDisplay(anchor, Localizations.localeOf(context));
    final monday = mondayOfWeekContaining(anchor);
    final asyncGoals = ref.watch(weeklyGoalsProvider);
    final asyncQuality = ref.watch(weekQualityStripProvider);
    final accent = OnboardingTypography.accentLavender;
    final brightness = Theme.of(context).brightness;
    final topInset = MediaQuery.paddingOf(context).top + kToolbarHeight;
    final fabBottom = _fabBottomFromScreen(context);
    final scrollBottomPad = fabBottom + 56;

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
          lApp.navWeek,
          style: OnboardingTypography.titleStyle(
            Colors.white,
          ).copyWith(fontSize: OnboardingTypography.welcome),
        ),
        actions: [
          IconButton(
            tooltip: lApp.weeklyReportOpen,
            onPressed: () =>
                context.push('/weekly-report?w=${weekKeyFromDate(anchor)}'),
            icon: const Icon(Icons.insights_outlined),
          ),
          if (!isThisWeek)
            TextButton(
              onPressed: () {
                ref.read(weekPageAnchorProvider.notifier).state = thisMonday;
              },
              style: TextButton.styleFrom(foregroundColor: accent),
              child: Text(lApp.thisWeek),
            ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(top: topInset),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                  child: Material(
                    elevation: 0,
                    color: OnboardingTypography.shellChromeSurface(brightness),
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
                            tooltip: lApp.previousWeek,
                            onPressed: () {
                              ref.read(weekPageAnchorProvider.notifier).state =
                                  anchor.subtract(const Duration(days: 7));
                            },
                            icon: const Icon(Icons.chevron_left),
                            color: OnboardingTypography.shellChromeNavIcon(
                              brightness,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              range,
                              textAlign: TextAlign.center,
                              style: OnboardingTypography.bodyStyle(
                                brightness == Brightness.dark
                                    ? Colors.white
                                    : const Color(0xFF2D2548),
                                alpha: 0.95,
                              ),
                            ),
                          ),
                          IconButton(
                            tooltip: lApp.nextWeek,
                            onPressed: () {
                              ref.read(weekPageAnchorProvider.notifier).state =
                                  anchor.add(const Duration(days: 7));
                            },
                            icon: const Icon(Icons.chevron_right),
                            color: OnboardingTypography.shellChromeNavIcon(
                              brightness,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
                          child: asyncQuality.when(
                            loading: () => const SizedBox(
                              height: 100,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFFB8A9F9),
                                ),
                              ),
                            ),
                            error: (e, _) => Text(
                              '$e',
                              style: OnboardingTypography.bodyStyle(
                                Colors.white,
                              ),
                            ),
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
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFFB8A9F9),
                            ),
                          ),
                        ),
                        error: (e, _) => SliverFillRemaining(
                          child: Center(
                            child: Text(
                              '$e',
                              style: OnboardingTypography.bodyStyle(
                                Colors.white,
                              ),
                            ),
                          ),
                        ),
                        data: (goals) {
                          if (goals.isEmpty) {
                            return SliverFillRemaining(
                              hasScrollBody: false,
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(
                                    24,
                                    24,
                                    24,
                                    scrollBottomPad + 16,
                                  ),
                                  child: Text(
                                    lApp.weekGoalsEmpty,
                                    textAlign: TextAlign.center,
                                    style: OnboardingTypography.bodyStyle(
                                      Colors.white,
                                      alpha: 0.7,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                          final goalsRepo = ref.read(goalsRepositoryProvider);
                          return SliverPadding(
                            padding: EdgeInsets.only(bottom: scrollBottomPad),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate((
                                context,
                                i,
                              ) {
                                final g = goals[i];
                                final sphere = LifeSphereStorage.parseOrWork(
                                  g.sphere,
                                );
                                final t = g.targetCount <= 0
                                    ? 1
                                    : g.targetCount;
                                final p = g.progressCount.clamp(0, t);
                                final done = p >= t || g.status == 1;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 5,
                                  ),
                                  child: _WeekGlassPanel(
                                    child: Padding(
                                      padding: const EdgeInsets.all(14),
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
                                                    ? accent
                                                    : Colors.white.withValues(
                                                        alpha: 0.88,
                                                      ),
                                                size: 22,
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Text(
                                                  g.title,
                                                  style:
                                                      OnboardingTypography.bodyStyle(
                                                        Colors.white,
                                                        alpha: 1,
                                                      ).copyWith(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                ),
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  Icons.delete_outline,
                                                  color: Colors.white
                                                      .withValues(alpha: 0.55),
                                                  size: 20,
                                                ),
                                                tooltip: lApp.delete,
                                                onPressed: () async {
                                                  final ok = await showDialog<bool>(
                                                    context: context,
                                                    builder: (ctx) => AlertDialog(
                                                      title: Text(lApp.delete),
                                                      content: Text(g.title),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                ctx,
                                                                false,
                                                              ),
                                                          child: Text(
                                                            MaterialLocalizations.of(
                                                              ctx,
                                                            ).cancelButtonLabel,
                                                          ),
                                                        ),
                                                        FilledButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                ctx,
                                                                true,
                                                              ),
                                                          child: Text(
                                                            lApp.delete,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                  if (ok == true &&
                                                      context.mounted) {
                                                    await goalsRepo.deleteGoal(
                                                      g.id,
                                                    );
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            sphereLabel(lApp, sphere),
                                            style:
                                                OnboardingTypography.bodyStyle(
                                                  Colors.white,
                                                  alpha: 0.6,
                                                ).copyWith(
                                                  fontSize:
                                                      OnboardingTypography
                                                          .body -
                                                      6,
                                                ),
                                          ),
                                          const SizedBox(height: 10),
                                          LinearProgressIndicator(
                                            value: t == 0 ? 0 : p / t,
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                            color: accent,
                                            backgroundColor: Colors.white
                                                .withValues(alpha: 0.15),
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Text(
                                                lApp.goalProgressLabel(p, t),
                                                style:
                                                    OnboardingTypography.bodyStyle(
                                                      Colors.white,
                                                      alpha: 0.7,
                                                    ).copyWith(
                                                      fontSize:
                                                          OnboardingTypography
                                                              .body -
                                                          6,
                                                    ),
                                              ),
                                              const Spacer(),
                                              if (!done)
                                                _WeekGlassButton(
                                                  label: lApp.addProgress,
                                                  onPressed: () async {
                                                    final willComplete =
                                                        p + 1 >= t;
                                                    await goalsRepo
                                                        .bumpProgress(g.id, 1);
                                                    if (!context.mounted) {
                                                      return;
                                                    }
                                                    if (willComplete) {
                                                      final voicePack = ref.read(
                                                        effectiveVoicePackIdProvider,
                                                      );
                                                      ScaffoldMessenger.of(
                                                        context,
                                                      ).showSnackBar(
                                                        SnackBar(
                                                          duration:
                                                              const Duration(
                                                                seconds: 5,
                                                              ),
                                                          content: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Text(
                                                                lApp.goalDone,
                                                              ),
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
                                                                  context,
                                                                ).textTheme.bodySmall,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                )
                                              else
                                                Text(
                                                  lApp.goalDone,
                                                  style:
                                                      OnboardingTypography.bodyStyle(
                                                        accent,
                                                        alpha: 1,
                                                      ).copyWith(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize:
                                                            OnboardingTypography
                                                                .body -
                                                            4,
                                                      ),
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }, childCount: goals.length),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              left: _shellHorizontalPad,
              bottom: fabBottom,
              child: const _WeekAssistantFloat(),
            ),
            Positioned(
              right: _shellHorizontalPad,
              bottom: fabBottom,
              child: FloatingActionButton.extended(
                backgroundColor: OnboardingTypography.accentLavender,
                foregroundColor: const Color(0xFF1E1B4B),
                onPressed: () => _openAddGoal(context, ref),
                icon: const Icon(Icons.add),
                label: Text(lApp.addWeeklyGoal),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeekAssistantFloat extends ConsumerWidget {
  const _WeekAssistantFloat();

  static const double _buddySize = 136;
  /// Як у [AssistantBuddy]: `faceSize = size * 0.72`, обличчя по центру квадрата — зсуваємо вліво, щоб лівий край кола збігався з лівим краєм колонки (і з навбаром при `Positioned(left: 12)`).
  static double get _buddyLeftAlignShift =>
      _buddySize * (1 - 0.72) / 2;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layers = ref.watch(equippedAssistantLayersProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
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
                AppLocalizations.of(context)!.assistantWeekBubble,
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
        Transform.translate(
          offset: Offset(-_buddyLeftAlignShift, 0),
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
        ),
      ],
    );
  }
}

class _WeekGlassPanel extends StatelessWidget {
  const _WeekGlassPanel({required this.child});

  final Widget child;
  static const double borderRadius = 18;

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

class _WeekGlassButton extends StatelessWidget {
  const _WeekGlassButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final accent = OnboardingTypography.accentLavender;
    return Material(
      color: accent.withValues(alpha: 0.18),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: accent.withValues(alpha: 0.45), width: 1),
          ),
          child: Text(
            label,
            style: OnboardingTypography.bodyStyle(accent, alpha: 1).copyWith(
              fontWeight: FontWeight.w600,
              fontSize: OnboardingTypography.body - 4,
            ),
          ),
        ),
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

/// Діалог «Додати тижневу ціль» у стилі скляної панелі з лавандовим контуром (макет Week).
class _WeekAddGoalFormDialog extends StatefulWidget {
  const _WeekAddGoalFormDialog({
    required this.l10n,
    required this.titleController,
    required this.targetController,
  });

  final AppLocalizations l10n;
  final TextEditingController titleController;
  final TextEditingController targetController;

  @override
  State<_WeekAddGoalFormDialog> createState() => _WeekAddGoalFormDialogState();
}

class _WeekAddGoalFormDialogState extends State<_WeekAddGoalFormDialog> {
  LifeSphere _sphere = LifeSphere.work;

  static const Color _saveFg = Color(0xFF1E1B4B);

  InputDecoration _inputDecoration({
    required Color accent,
    String? labelText,
    String? hintText,
  }) {
    final borderRadius = BorderRadius.circular(12);
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      hintStyle: OnboardingTypography.bodyStyle(Colors.white, alpha: 0.42),
      labelStyle: OnboardingTypography.bodyStyle(Colors.white, alpha: 0.68)
          .copyWith(fontSize: OnboardingTypography.body - 4),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.08),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(borderRadius: borderRadius),
      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.32)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: accent, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final accent = OnboardingTypography.accentLavender;
    final rim = Color.lerp(accent, Colors.white, 0.42)!.withValues(alpha: 0.62);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: rim, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: accent.withValues(alpha: 0.38),
                  blurRadius: 22,
                  spreadRadius: 0,
                ),
              ],
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.14),
                  Colors.black.withValues(alpha: 0.78),
                  accent.withValues(alpha: 0.09),
                ],
              ),
            ),
            padding: const EdgeInsets.fromLTRB(22, 20, 22, 18),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    widget.l10n.addWeeklyGoal,
                    textAlign: TextAlign.center,
                    style: OnboardingTypography.titleStyle(Colors.white).copyWith(
                      fontSize: OnboardingTypography.welcome,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                const SizedBox(height: 20),
                TextField(
                  controller: widget.titleController,
                  textCapitalization: TextCapitalization.sentences,
                  style: OnboardingTypography.bodyStyle(Colors.white, alpha: 0.96),
                  decoration: _inputDecoration(
                    accent: accent,
                    hintText: widget.l10n.weeklyGoalTitleHint,
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: widget.targetController,
                  keyboardType: TextInputType.number,
                  style: OnboardingTypography.bodyStyle(Colors.white, alpha: 0.96),
                  decoration: _inputDecoration(
                    accent: accent,
                    labelText: widget.l10n.targetTimes,
                  ),
                ),
                const SizedBox(height: 14),
                MenuAnchor(
                  style: MenuStyle(
                    backgroundColor: WidgetStateProperty.all(
                      const Color(0xFF252038).withValues(alpha: 0.97),
                    ),
                    surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
                    shadowColor: WidgetStateProperty.all(
                      accent.withValues(alpha: 0.42),
                    ),
                    elevation: WidgetStateProperty.all(14),
                    padding: WidgetStateProperty.all(
                      const EdgeInsets.symmetric(vertical: 6),
                    ),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: rim, width: 1.5),
                      ),
                    ),
                  ),
                  alignmentOffset: const Offset(0, 6),
                  menuChildren: [
                    for (final s in LifeSphere.values)
                      MenuItemButton(
                        onPressed: () => setState(() => _sphere = s),
                        style: MenuItemButton.styleFrom(
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                        ),
                        leadingIcon: Icon(sphereIcon(s), color: accent, size: 22),
                        child: Text(
                          sphereLabel(widget.l10n, s),
                          style: OnboardingTypography.bodyStyle(
                            Colors.white,
                            alpha: 0.95,
                          ),
                        ),
                      ),
                  ],
                  builder: (context, controller, _) {
                    return InputDecorator(
                      decoration: _inputDecoration(
                        accent: accent,
                        labelText: widget.l10n.sphereFieldLabel,
                      ).copyWith(
                        contentPadding: const EdgeInsetsDirectional.only(
                          start: 10,
                          end: 4,
                          top: 8,
                          bottom: 8,
                        ),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          if (controller.isOpen) {
                            controller.close();
                          } else {
                            controller.open();
                          }
                        },
                        child: Row(
                          children: [
                            Icon(sphereIcon(_sphere), color: accent, size: 22),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                sphereLabel(widget.l10n, _sphere),
                                style: OnboardingTypography.bodyStyle(
                                  Colors.white,
                                  alpha: 0.95,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(Icons.expand_more_rounded, color: accent),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        MaterialLocalizations.of(context).cancelButtonLabel,
                        style: OnboardingTypography.bodyStyle(
                          Colors.white,
                          alpha: 0.92,
                        ),
                      ),
                    ),
                    const Spacer(),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: accent,
                        foregroundColor: _saveFg,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      onPressed: () {
                        final title = widget.titleController.text.trim();
                        final t =
                            int.tryParse(widget.targetController.text.trim()) ??
                                1;
                        if (title.isEmpty) return;
                        Navigator.pop(
                          context,
                          _NewWeeklyGoalResult(
                            title: title,
                            sphere: _sphere,
                            targetCount: t < 1 ? 1 : t,
                          ),
                        );
                      },
                      child: Text(widget.l10n.save),
                    ),
                  ],
                ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> _openAddGoal(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context)!;
  final weekKey = ref.read(selectedWeekKeyProvider);
  final titleController = TextEditingController();
  final targetController = TextEditingController(text: '1');

  try {
    final result = await showDialog<_NewWeeklyGoalResult>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.52),
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
        child: _WeekAddGoalFormDialog(
          l10n: l10n,
          titleController: titleController,
          targetController: targetController,
        ),
      ),
    );

    if (result != null && context.mounted) {
      await ref
          .read(goalsRepositoryProvider)
          .addGoal(
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
