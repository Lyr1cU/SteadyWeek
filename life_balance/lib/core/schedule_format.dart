import 'dart:ui' show Locale;

import 'package:intl/intl.dart';
import 'package:life_balance/core/week_key.dart';
import 'package:life_balance/l10n/app_localizations.dart';

/// [scheduledMinuteOfDay] is minutes from midnight (0–1439), or null if flexible.
String formatScheduledTime(
  AppLocalizations l10n,
  Locale locale,
  int? scheduledMinuteOfDay,
) {
  if (scheduledMinuteOfDay == null) {
    return l10n.scheduleFlexible;
  }
  final h = scheduledMinuteOfDay ~/ 60;
  final m = scheduledMinuteOfDay % 60;
  return DateFormat.jm(dateFormatLocaleForIntl(locale))
      .format(DateTime(2000, 1, 1, h, m));
}

int compareRoutineSchedule(
  int? minuteA,
  int orderA,
  int? minuteB,
  int orderB,
) {
  if (minuteA != null && minuteB != null && minuteA != minuteB) {
    return minuteA.compareTo(minuteB);
  }
  if (minuteA == null && minuteB != null) return 1;
  if (minuteA != null && minuteB == null) return -1;
  return orderA.compareTo(orderB);
}
