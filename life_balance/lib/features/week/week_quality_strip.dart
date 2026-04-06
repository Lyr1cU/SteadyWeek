import 'package:flutter/material.dart';
import 'package:life_balance/core/date_key.dart';
import 'package:life_balance/domain/day_tier.dart';
import 'package:life_balance/l10n/app_localizations.dart';

/// One row per week: Mon–Sun chips colored by [DailyReports.dayTier] when closed.
class WeekQualityStrip extends StatelessWidget {
  const WeekQualityStrip({
    super.key,
    required this.monday,
    required this.byDayKey,
    required this.onDayTap,
  });

  final DateTime monday;
  final Map<String, DayTier?> byDayKey;
  final void Function(DateTime day) onDayTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final labels = [
      l10n.weekdayMonShort,
      l10n.weekdayTueShort,
      l10n.weekdayWedShort,
      l10n.weekdayThuShort,
      l10n.weekdayFriShort,
      l10n.weekdaySatShort,
      l10n.weekdaySunShort,
    ];
    final now = DateTime.now();
    final today =
        DateTime(now.year, now.month, now.day);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.weekQualityStripTitle,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 10),
        Row(
          children: List.generate(7, (i) {
            final day = monday.add(Duration(days: i));
            final key = dateKey(day);
            final tier = byDayKey[key];
            final isToday = day.year == today.year &&
                day.month == today.month &&
                day.day == today.day;
            final tooltip = tier == null
                ? '${labels[i]} ${day.day}: ${l10n.dayNotClosed}\n${l10n.weekGoToTodayForDay}'
                : '${labels[i]} ${day.day}: ${_tierLabel(l10n, tier)}\n${l10n.weekGoToTodayForDay}';

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Tooltip(
                  message: tooltip,
                  child: Material(
                    color: _tierFill(context, tier),
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => onDayTap(day),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isToday
                                ? Theme.of(context).colorScheme.primary
                                : (tier == null
                                    ? Theme.of(context)
                                        .colorScheme
                                        .outlineVariant
                                    : Colors.transparent),
                            width: isToday ? 2 : 1,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              labels[i],
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${day.day}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

String _tierLabel(AppLocalizations l10n, DayTier tier) {
  return switch (tier) {
    DayTier.green => l10n.tierGreen,
    DayTier.yellow => l10n.tierYellow,
    DayTier.red => l10n.tierRed,
  };
}

Color _tierFill(BuildContext context, DayTier? tier) {
  final dark = Theme.of(context).brightness == Brightness.dark;
  if (tier == null) {
    return Theme.of(context).colorScheme.surfaceContainerLow.withValues(
          alpha: dark ? 0.85 : 0.6,
        );
  }
  return switch (tier) {
    DayTier.green => dark
        ? const Color(0xFF1B3D28)
        : const Color(0xFFDFF5E4),
    DayTier.yellow => dark
        ? const Color(0xFF3D3518)
        : const Color(0xFFFFF4D4),
    DayTier.red => dark
        ? const Color(0xFF3D1A1A)
        : const Color(0xFFFFE4E4),
  };
}
