import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:life_balance/l10n/app_localizations.dart';
import 'package:life_balance/ui/onboarding_typography.dart';

/// Діалог вибору часу: темний — скло; світлий — біла панель і темний текст.
Future<TimeOfDay?> showRoutineTimePicker(
  BuildContext context, {
  required AppLocalizations l10n,
  required TimeOfDay initialTime,
}) {
  final accent = OnboardingTypography.accentLavender;
  const saveFg = Color(0xFF1E1B4B);
  final base = Theme.of(context);
  final isDark = Theme.of(context).brightness == Brightness.dark;

  if (!isDark) {
    final rim = OnboardingTypography.shellChromeBorderColor(Brightness.light);
    final text = OnboardingTypography.textColor(Brightness.light);
    final mutedBorder = const Color(0xFFE2DBF5);
    final dialogShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(28),
      side: BorderSide(color: rim, width: 1.5),
    );

    return showTimePicker(
      context: context,
      initialTime: initialTime,
      initialEntryMode: TimePickerEntryMode.dial,
      helpText: l10n.routineSelectTime,
      barrierColor: Colors.black.withValues(alpha: 0.52),
      builder: (ctx, child) {
        return Theme(
          data: base.copyWith(
            colorScheme: base.colorScheme.copyWith(
              primary: accent,
              onPrimary: saveFg,
              onSurface: text,
              surface: Colors.white,
              surfaceContainerHigh: const Color(0xFFF5F3FA),
              surfaceContainerHighest: const Color(0xFFEDE8F7),
            ),
            dialogTheme: DialogThemeData(
              backgroundColor: Colors.white,
              elevation: 8,
              shadowColor: const Color(0xFF453A7A).withValues(alpha: 0.12),
              surfaceTintColor: Colors.transparent,
              shape: dialogShape,
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.white,
              elevation: 0,
              shape: dialogShape,
              helpTextStyle: OnboardingTypography.titleStyle(text).copyWith(
                fontSize: OnboardingTypography.body,
                fontWeight: FontWeight.w600,
              ),
              hourMinuteTextColor: WidgetStateColor.resolveWith((_) => text),
              hourMinuteTextStyle: OnboardingTypography.titleStyle(text)
                  .copyWith(
                    fontSize: 50,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.5,
                  ),
              hourMinuteColor: WidgetStateColor.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return accent.withValues(alpha: 0.22);
                }
                return const Color(0xFFF5F3FA);
              }),
              hourMinuteShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: mutedBorder, width: 1),
              ),
              timeSelectorSeparatorColor:
                  WidgetStatePropertyAll(text.withValues(alpha: 0.45)),
              timeSelectorSeparatorTextStyle: WidgetStatePropertyAll(
                OnboardingTypography.titleStyle(text).copyWith(
                  fontSize: 50,
                  fontWeight: FontWeight.w300,
                ),
              ),
              dayPeriodColor: WidgetStateColor.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return accent;
                }
                return Colors.transparent;
              }),
              dayPeriodTextColor: WidgetStateColor.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return saveFg;
                }
                return text.withValues(alpha: 0.78);
              }),
              dayPeriodTextStyle: OnboardingTypography.bodyStyle(
                text,
                alpha: 1,
              ).copyWith(
                fontWeight: FontWeight.w600,
                fontSize: OnboardingTypography.body - 4,
              ),
              dayPeriodShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              dayPeriodBorderSide: BorderSide(color: mutedBorder),
              dialBackgroundColor: const Color(0xFFF5F3FA),
              dialHandColor: accent,
              dialTextColor: WidgetStateColor.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return saveFg;
                }
                return text.withValues(alpha: 0.88);
              }),
              dialTextStyle: OnboardingTypography.bodyStyle(
                text,
                alpha: 1,
              ).copyWith(fontSize: OnboardingTypography.body - 2),
              entryModeIconColor: text.withValues(alpha: 0.92),
              cancelButtonStyle: TextButton.styleFrom(
                foregroundColor: text.withValues(alpha: 0.92),
              ),
              confirmButtonStyle: ButtonStyle(
                foregroundColor: WidgetStatePropertyAll(saveFg),
                backgroundColor: WidgetStatePropertyAll(accent),
                padding: const WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                ),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
  }

  final rim = Color.lerp(accent, Colors.white, 0.42)!.withValues(alpha: 0.62);
  final dialogShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(28),
    side: BorderSide(color: rim, width: 1.5),
  );

  return showTimePicker(
    context: context,
    initialTime: initialTime,
    initialEntryMode: TimePickerEntryMode.dial,
    helpText: l10n.routineSelectTime,
    barrierColor: Colors.black.withValues(alpha: 0.52),
    builder: (ctx, child) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Theme(
            data: base.copyWith(
              colorScheme: base.colorScheme.copyWith(
                primary: accent,
                onPrimary: saveFg,
                onSurface: Colors.white,
                surface: Colors.transparent,
                surfaceContainerHigh: Colors.white.withValues(alpha: 0.12),
                surfaceContainerHighest: Colors.white.withValues(alpha: 0.1),
              ),
              dialogTheme: DialogThemeData(
                backgroundColor: Colors.transparent,
                elevation: 0,
                surfaceTintColor: Colors.transparent,
                shape: dialogShape,
              ),
              timePickerTheme: TimePickerThemeData(
                backgroundColor: Colors.white.withValues(alpha: 0.08),
                elevation: 0,
                shape: dialogShape,
                helpTextStyle: OnboardingTypography.titleStyle(Colors.white)
                    .copyWith(
                      fontSize: OnboardingTypography.body,
                      fontWeight: FontWeight.w600,
                    ),
                hourMinuteTextColor:
                    WidgetStateColor.resolveWith((_) => Colors.white),
                hourMinuteTextStyle:
                    OnboardingTypography.titleStyle(Colors.white).copyWith(
                      fontSize: 50,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.5,
                    ),
                hourMinuteColor: WidgetStateColor.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return accent.withValues(alpha: 0.32);
                  }
                  return Colors.white.withValues(alpha: 0.08);
                }),
                hourMinuteShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: Colors.white.withValues(alpha: 0.28),
                    width: 1,
                  ),
                ),
                timeSelectorSeparatorColor: const WidgetStatePropertyAll(
                  Colors.white54,
                ),
                timeSelectorSeparatorTextStyle: WidgetStatePropertyAll(
                  OnboardingTypography.titleStyle(Colors.white).copyWith(
                    fontSize: 50,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                dayPeriodColor: WidgetStateColor.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return accent;
                  }
                  return Colors.transparent;
                }),
                dayPeriodTextColor: WidgetStateColor.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return saveFg;
                  }
                  return Colors.white.withValues(alpha: 0.78);
                }),
                dayPeriodTextStyle: OnboardingTypography.bodyStyle(
                  Colors.white,
                  alpha: 1,
                ).copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: OnboardingTypography.body - 4,
                ),
                dayPeriodShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                dayPeriodBorderSide: BorderSide(
                  color: Colors.white.withValues(alpha: 0.28),
                ),
                dialBackgroundColor: Colors.white.withValues(alpha: 0.1),
                dialHandColor: accent,
                dialTextColor: WidgetStateColor.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return Colors.white;
                  }
                  return Colors.white.withValues(alpha: 0.88);
                }),
                dialTextStyle: OnboardingTypography.bodyStyle(
                  Colors.white,
                  alpha: 1,
                ).copyWith(fontSize: OnboardingTypography.body - 2),
                entryModeIconColor: Colors.white.withValues(alpha: 0.92),
                cancelButtonStyle: TextButton.styleFrom(
                  foregroundColor: Colors.white.withValues(alpha: 0.92),
                ),
                confirmButtonStyle: ButtonStyle(
                  foregroundColor: WidgetStatePropertyAll(saveFg),
                  backgroundColor: WidgetStatePropertyAll(accent),
                  padding: const WidgetStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                  ),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              ),
            ),
            child: child!,
          ),
        ),
      );
    },
  );
}
