import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:life_balance/core/date_key.dart';
import 'package:life_balance/core/schedule_format.dart';
import 'package:life_balance/data/drift/app_database.dart';
import 'package:life_balance/domain/life_sphere.dart';
import 'package:life_balance/l10n/app_localizations.dart';
import 'package:life_balance/providers.dart';
import 'package:life_balance/ui/assistant_buddy.dart';
import 'package:life_balance/ui/sphere_ui.dart';
import 'package:life_balance/ui/chrome_surfaces.dart';
import 'package:life_balance/ui/onboarding_typography.dart';
import 'package:life_balance/features/routine/routine_time_picker.dart';

class RoutineScreen extends ConsumerWidget {
  const RoutineScreen({super.key});

  /// Як у [WeekScreen]: відступи навбара в MainShell.
  static const double _shellHorizontalPad = 12;

  static double _fabBottomFromScreen(BuildContext context) {
    return MediaQuery.viewPaddingOf(context).bottom + 120;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final asyncTemplates = ref.watch(routineTemplatesProvider);
    final brightness = Theme.of(context).brightness;
    final tc = OnboardingTypography.textColor(brightness);
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
        foregroundColor: tc,
        iconTheme: IconThemeData(color: tc),
        actionsIconTheme: IconThemeData(color: tc),
        title: Text(
          l10n.navRoutine,
          style: OnboardingTypography.titleStyle(tc).copyWith(
            fontWeight: FontWeight.w700,
            fontSize: OnboardingTypography.welcome,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: topInset),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: asyncTemplates.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      '$e',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: tc),
                    ),
                  ),
                ),
                data: (items) {
                  if (items.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(24, 0, 24, scrollBottomPad),
                        child: Text(
                          l10n.todayEmpty,
                          textAlign: TextAlign.center,
                          style: OnboardingTypography.bodyStyle(
                            tc,
                            alpha: 0.65,
                          ),
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: EdgeInsets.fromLTRB(12, 12, 12, scrollBottomPad),
                    itemCount: items.length,
                    itemBuilder: (context, i) {
                      final item = items[i];
                      final sphere = LifeSphereStorage.parseOrWork(item.sphere);
                      return _RoutineGlassCard(
                        item: item,
                        sphere: sphere,
                        l10n: l10n,
                        onEdit: () =>
                            _openRoutineFormDialog(context, ref, existing: item),
                        onDelete: () async {
                          final ok = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text(l10n.delete),
                              content: Text(item.title),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: Text(
                                    MaterialLocalizations.of(ctx)
                                        .cancelButtonLabel,
                                  ),
                                ),
                                FilledButton(
                                  style: FilledButton.styleFrom(
                                    backgroundColor:
                                        Colors.red.withValues(alpha: 0.8),
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: () => Navigator.pop(ctx, true),
                                  child: Text(l10n.delete),
                                ),
                              ],
                            ),
                          );
                          if (ok == true && context.mounted) {
                            await ref
                                .read(routineRepositoryProvider)
                                .deleteRoutineItem(item.id);
                          }
                        },
                      );
                    },
                  );
                },
              ),
            ),
            Positioned(
              left: _shellHorizontalPad,
              bottom: fabBottom,
              child: const _RoutineAssistantFloat(),
            ),
            Positioned(
              right: _shellHorizontalPad,
              bottom: fabBottom,
              child: FloatingActionButton.extended(
                backgroundColor: OnboardingTypography.accentLavender,
                foregroundColor: const Color(0xFF1E1B4B),
                onPressed: () => _openRoutineFormDialog(context, ref),
                icon: const Icon(Icons.add),
                label: Text(l10n.addRoutineItem),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoutineAssistantFloat extends ConsumerWidget {
  const _RoutineAssistantFloat();

  static const double _buddySize = 136;

  static double get _buddyLeftAlignShift => _buddySize * (1 - 0.72) / 2;

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
                AppLocalizations.of(context)!.assistantRoutineBubble,
                style: OnboardingTypography.bodyStyle(
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

class _RoutineGlassCard extends StatelessWidget {
  const _RoutineGlassCard({
    required this.item,
    required this.sphere,
    required this.l10n,
    required this.onEdit,
    required this.onDelete,
  });

  final RoutineItem item;
  final LifeSphere sphere;
  final AppLocalizations l10n;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final accent = OnboardingTypography.accentLavender;
    final brightness = Theme.of(context).brightness;
    final tc = OnboardingTypography.textColor(brightness);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ChromeCard(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
          child: Row(
            children: [
              Icon(sphereIcon(sphere), color: accent, size: 28),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: OnboardingTypography.bodyStyle(
                        tc,
                        alpha: 1,
                      ).copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${formatScheduledTime(l10n, Localizations.localeOf(context), item.scheduledMinuteOfDay)} · '
                      '${sphereLabel(l10n, sphere)} · '
                      '${_weekdaySummary(context, item.weekdays)}',
                      style: OnboardingTypography.bodyStyle(
                        tc,
                        alpha: 0.65,
                      ).copyWith(fontSize: OnboardingTypography.body - 6),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.edit_outlined,
                      color: tc.withValues(alpha: 0.55),
                    ),
                    tooltip: l10n.editRoutineItem,
                    onPressed: onEdit,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      color: tc.withValues(alpha: 0.55),
                    ),
                    tooltip: l10n.delete,
                    onPressed: onDelete,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _weekdaySummary(BuildContext context, int mask) {
    final labels = [
      l10n.weekdayMonShort,
      l10n.weekdayTueShort,
      l10n.weekdayWedShort,
      l10n.weekdayThuShort,
      l10n.weekdayFriShort,
      l10n.weekdaySatShort,
      l10n.weekdaySunShort,
    ];
    final parts = <String>[];
    for (var i = 1; i <= 7; i++) {
      if (routineRunsOnWeekday(mask, i)) {
        parts.add(labels[i - 1]);
      }
    }
    return parts.join(', ');
  }
}

class _RoutineFormResult {
  const _RoutineFormResult({
    required this.title,
    required this.sphere,
    required this.weekdaysMask,
    this.scheduledMinuteOfDay,
  });

  final String title;
  final LifeSphere sphere;
  final int weekdaysMask;
  final int? scheduledMinuteOfDay;
}

class _RoutineFormDialog extends StatefulWidget {
  const _RoutineFormDialog({
    required this.l10n,
    required this.titleController,
    this.existing,
  });

  final AppLocalizations l10n;
  final TextEditingController titleController;
  final RoutineItem? existing;

  @override
  State<_RoutineFormDialog> createState() => _RoutineFormDialogState();
}

class _RoutineFormDialogState extends State<_RoutineFormDialog> {
  late LifeSphere _sphere;
  late int _weekdaysMask;
  TimeOfDay? _pickedTime;

  static const Color _saveFg = Color(0xFF1E1B4B);

  @override
  void initState() {
    super.initState();
    _sphere = widget.existing != null
        ? LifeSphereStorage.parseOrWork(widget.existing!.sphere)
        : LifeSphere.work;
    _weekdaysMask = widget.existing?.weekdays ?? 0x7f;
    if (widget.existing?.scheduledMinuteOfDay != null) {
      final m = widget.existing!.scheduledMinuteOfDay!;
      _pickedTime = TimeOfDay(hour: m ~/ 60, minute: m % 60);
    }
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
    final accent = OnboardingTypography.accentLavender;
    final brightness = Theme.of(context).brightness;
    final textColor = OnboardingTypography.textColor(brightness);
    final isDark = brightness == Brightness.dark;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: ChromeCard(
        borderRadius: 22,
        lightElevation: 12,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 20, 22, 18),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.existing == null
                      ? widget.l10n.addRoutineItem
                      : widget.l10n.editRoutineItem,
                  textAlign: TextAlign.center,
                  style: OnboardingTypography.titleStyle(textColor).copyWith(
                    fontSize: OnboardingTypography.welcome,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: widget.titleController,
                  textCapitalization: TextCapitalization.sentences,
                  style: OnboardingTypography.bodyStyle(textColor, alpha: 0.96),
                  decoration: _inputDecoration(
                    accent: accent,
                    brightness: brightness,
                    hintText: widget.l10n.routineTitleHint,
                  ),
                ),
                const SizedBox(height: 14),
                MenuAnchor(
                  style: menuStyleFor(context, accent: accent),
                  alignmentOffset: const Offset(0, 6),
                  menuChildren: [
                    for (final s in LifeSphere.values)
                      MenuItemButton(
                        onPressed: () => setState(() => _sphere = s),
                        style: MenuItemButton.styleFrom(
                          foregroundColor: textColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                        ),
                        leadingIcon: Icon(sphereIcon(s), color: accent, size: 22),
                        child: Text(
                          sphereLabel(widget.l10n, s),
                          style: OnboardingTypography.bodyStyle(
                            textColor,
                            alpha: 0.95,
                          ),
                        ),
                      ),
                  ],
                  builder: (context, controller, _) {
                    return InputDecorator(
                      decoration: _inputDecoration(
                        accent: accent,
                        brightness: brightness,
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
                                  textColor,
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
                const SizedBox(height: 16),
                Text(
                  widget.l10n.activeDays,
                  style: OnboardingTypography.bodyStyle(
                    textColor,
                    alpha: isDark ? 0.68 : 0.72,
                  ).copyWith(
                    fontSize: OnboardingTypography.body - 4,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: List.generate(7, (index) {
                    final weekday = index + 1;
                    final selected = routineRunsOnWeekday(_weekdaysMask, weekday);
                    final short = [
                      widget.l10n.weekdayMonShort,
                      widget.l10n.weekdayTueShort,
                      widget.l10n.weekdayWedShort,
                      widget.l10n.weekdayThuShort,
                      widget.l10n.weekdayFriShort,
                      widget.l10n.weekdaySatShort,
                      widget.l10n.weekdaySunShort,
                    ][index];
                    return FilterChip(
                      label: Text(short),
                      selected: selected,
                      onSelected: (on) {
                        setState(() {
                          if (on) {
                            _weekdaysMask |= weekdayBit(weekday);
                          } else {
                            _weekdaysMask &= ~weekdayBit(weekday);
                          }
                        });
                      },
                      backgroundColor: isDark
                          ? Colors.white.withValues(alpha: 0.08)
                          : const Color(0xFFF5F3FA),
                      selectedColor: accent,
                      checkmarkColor: _saveFg,
                      labelStyle: OnboardingTypography.bodyStyle(
                        selected ? _saveFg : textColor,
                        alpha: selected ? 1 : (isDark ? 0.8 : 0.85),
                      ).copyWith(
                        fontSize: OnboardingTypography.body - 4,
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: selected
                              ? Colors.transparent
                              : (isDark
                                  ? Colors.white.withValues(alpha: 0.2)
                                  : const Color(0xFFE2DBF5)),
                        ),
                      ),
                      showCheckmark: false,
                    );
                  }),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.l10n.scheduleTimeOptional,
                  style: OnboardingTypography.bodyStyle(
                    textColor,
                    alpha: isDark ? 0.68 : 0.72,
                  ).copyWith(
                    fontSize: OnboardingTypography.body - 4,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: textColor,
                          side: BorderSide(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.32)
                                : const Color(0xFFE2DBF5),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: Icon(Icons.access_time, size: 20, color: accent),
                        label: Text(
                          _pickedTime == null
                              ? widget.l10n.scheduleSetTime
                              : _pickedTime!.format(context),
                          style: OnboardingTypography.bodyStyle(
                            textColor,
                            alpha: 0.9,
                          ),
                        ),
                        onPressed: () async {
                          final t = await showRoutineTimePicker(
                            context,
                            l10n: widget.l10n,
                            initialTime: _pickedTime ??
                                const TimeOfDay(hour: 9, minute: 0),
                          );
                          if (t != null) {
                            setState(() => _pickedTime = t);
                          }
                        },
                      ),
                    ),
                    if (_pickedTime != null) ...[
                      const SizedBox(width: 8),
                      IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: isDark
                              ? Colors.white.withValues(alpha: 0.08)
                              : const Color(0xFFF5F3FA),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => setState(() => _pickedTime = null),
                        icon: Icon(
                          Icons.close,
                          color: isDark
                              ? Colors.white70
                              : OnboardingTypography.textMutedColor(
                                  Brightness.light,
                                ),
                        ),
                        tooltip: widget.l10n.scheduleNoTime,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        MaterialLocalizations.of(context).cancelButtonLabel,
                        style: OnboardingTypography.bodyStyle(
                          textColor,
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
                        if (title.isEmpty || _weekdaysMask == 0) return;
                        final minutes = _pickedTime == null
                            ? null
                            : _pickedTime!.hour * 60 + _pickedTime!.minute;
                        Navigator.pop(
                          context,
                          _RoutineFormResult(
                            title: title,
                            sphere: _sphere,
                            weekdaysMask: _weekdaysMask,
                            scheduledMinuteOfDay: minutes,
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
    );
  }
}

Future<void> _openRoutineFormDialog(
  BuildContext context,
  WidgetRef ref, {
  RoutineItem? existing,
}) async {
  final l10n = AppLocalizations.of(context)!;
  final titleController = TextEditingController(text: existing?.title ?? '');
  try {
    final result = await showDialog<_RoutineFormResult>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.52),
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
        child: _RoutineFormDialog(
          l10n: l10n,
          titleController: titleController,
          existing: existing,
        ),
      ),
    );

    if (result != null && context.mounted) {
      final repo = ref.read(routineRepositoryProvider);
      if (existing == null) {
        await repo.addRoutineItem(
          title: result.title,
          sphere: result.sphere.id,
          weekdaysMask: result.weekdaysMask,
          scheduledMinuteOfDay: result.scheduledMinuteOfDay,
        );
      } else {
        await repo.updateRoutineItem(
          id: existing.id,
          title: result.title,
          sphere: result.sphere.id,
          weekdaysMask: result.weekdaysMask,
          scheduledMinuteOfDay: result.scheduledMinuteOfDay,
        );
      }
    }
  } finally {
    titleController.dispose();
  }
}
