import 'dart:ui' show Locale;

import 'package:intl/intl.dart';

/// Anchor: Monday 00:00 local date, formatted `yyyy-MM-dd` (sortable week id).
DateTime mondayOfWeekContaining(DateTime date) {
  final d = DateTime(date.year, date.month, date.day);
  return d.subtract(Duration(days: d.weekday - DateTime.monday));
}

String weekKeyFromDate(DateTime date) {
  final monday = mondayOfWeekContaining(date);
  return DateFormat('yyyy-MM-dd').format(monday);
}

/// Short range label, e.g. "Apr 1 – Apr 7" / localized month names.
String weekRangeDisplay(DateTime anyDayInWeek, Locale locale) {
  final monday = mondayOfWeekContaining(anyDayInWeek);
  final sunday = monday.add(const Duration(days: 6));
  final lc = dateFormatLocaleForIntl(locale);
  final a = DateFormat.MMMd(lc).format(monday);
  final b = DateFormat.MMMd(lc).format(sunday);
  return '$a – $b';
}

/// intl [DateFormat] locale string, e.g. `uk`, `en`, `en_US`.
String dateFormatLocaleForIntl(Locale locale) {
  if (locale.countryCode != null && locale.countryCode!.isNotEmpty) {
    return '${locale.languageCode}_${locale.countryCode}';
  }
  return locale.languageCode;
}
