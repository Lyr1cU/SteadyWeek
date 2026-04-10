import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:life_balance/core/date_key.dart';
import 'package:life_balance/domain/day_tier.dart';
import 'package:life_balance/l10n/app_localizations.dart';
import 'package:life_balance/ui/onboarding_typography.dart';

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

  static const double _chipRadius = 12;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final accent = OnboardingTypography.accentLavender;
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
    final today = DateTime(now.year, now.month, now.day);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.weekQualityStripTitle,
          style: OnboardingTypography.titleStyle(Colors.white).copyWith(
            fontSize: OnboardingTypography.welcome,
            fontWeight: FontWeight.w700,
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(_chipRadius),
                    child: Stack(
                      fit: StackFit.passthrough,
                      children: [
                        Positioned.fill(
                          child: ColoredBox(color: _tierFillDark(tier)),
                        ),
                        Positioned.fill(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white.withValues(alpha: 0.14),
                                    Colors.white.withValues(alpha: 0.05),
                                    accent.withValues(alpha: 0.07),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius:
                                BorderRadius.circular(_chipRadius),
                            onTap: () => onDayTap(day),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(_chipRadius),
                                border: Border.all(
                                  color: isToday
                                      ? accent
                                      : (tier == null
                                          ? Color.lerp(
                                              accent,
                                              Colors.white,
                                              0.5,
                                            )!.withValues(alpha: 0.35)
                                          : Color.lerp(
                                              accent,
                                              Colors.white,
                                              0.55,
                                            )!.withValues(alpha: 0.28)),
                                  width: isToday ? 2 : 1,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 9,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    labels[i],
                                    style: OnboardingTypography.bodyStyle(
                                      Colors.white,
                                      alpha: 0.78,
                                    ).copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize:
                                          OnboardingTypography.body - 8,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${day.day}',
                                    style: OnboardingTypography.bodyStyle(
                                      Colors.white,
                                      alpha: 1,
                                    ).copyWith(
                                      fontWeight: FontWeight.w700,
                                      fontSize:
                                          OnboardingTypography.body - 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
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

Color _tierFillDark(DayTier? tier) {
  if (tier == null) {
    return Colors.white.withValues(alpha: 0.08);
  }
  return switch (tier) {
    DayTier.green => const Color(0xFF1B3D28),
    DayTier.yellow => const Color(0xFF3D3518),
    DayTier.red => const Color(0xFF3D1A1A),
  };
}
