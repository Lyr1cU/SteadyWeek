import 'package:intl/intl.dart';

/// Canonical local calendar day id (YYYY-MM-DD).
String dateKey(DateTime date) {
  final local = DateTime(date.year, date.month, date.day);
  return DateFormat('yyyy-MM-dd').format(local);
}

/// Parse [dateKey] as a **local** date at noon (avoids UTC shift bugs).
DateTime parseDateKeyLocal(String key) {
  final parts = key.split('-');
  if (parts.length != 3) {
    return DateTime.now();
  }
  return DateTime(
    int.parse(parts[0]),
    int.parse(parts[1]),
    int.parse(parts[2]),
    12,
  );
}

/// Bit for [DateTime.weekday] (Monday = 1 … Sunday = 7).
int weekdayBit(int weekday) {
  assert(weekday >= 1 && weekday <= 7);
  return 1 << (weekday - 1);
}

bool routineRunsOnWeekday(int weekdaysMask, int weekday) {
  return (weekdaysMask & weekdayBit(weekday)) != 0;
}
