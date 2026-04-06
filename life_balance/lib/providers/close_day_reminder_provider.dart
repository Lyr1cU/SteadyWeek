import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:life_balance/providers/theme_preference_provider.dart';

const kCloseDayReminderEnabledKey = 'close_day_reminder_enabled_v1';
const kCloseDayReminderMinutesKey = 'close_day_reminder_minutes_v1';

const int kDefaultCloseDayReminderMinutes = 21 * 60;

class CloseDayReminderState {
  const CloseDayReminderState({
    required this.enabled,
    required this.hour,
    required this.minute,
  });

  final bool enabled;
  final int hour;
  final int minute;
}

final closeDayReminderProvider =
    NotifierProvider<CloseDayReminderNotifier, CloseDayReminderState>(
  CloseDayReminderNotifier.new,
);

class CloseDayReminderNotifier extends Notifier<CloseDayReminderState> {
  @override
  CloseDayReminderState build() {
    final p = ref.read(sharedPreferencesProvider);
    final enabled = p.getBool(kCloseDayReminderEnabledKey) ?? true;
    final mins =
        p.getInt(kCloseDayReminderMinutesKey) ?? kDefaultCloseDayReminderMinutes;
    final clamped = mins.clamp(0, 23 * 60 + 59);
    return CloseDayReminderState(
      enabled: enabled,
      hour: clamped ~/ 60,
      minute: clamped % 60,
    );
  }

  Future<void> setEnabled(bool value) async {
    final p = ref.read(sharedPreferencesProvider);
    await p.setBool(kCloseDayReminderEnabledKey, value);
    state = CloseDayReminderState(
      enabled: value,
      hour: state.hour,
      minute: state.minute,
    );
  }

  Future<void> setTime({required int hour, required int minute}) async {
    final h = hour.clamp(0, 23);
    final m = minute.clamp(0, 59);
    final p = ref.read(sharedPreferencesProvider);
    await p.setInt(kCloseDayReminderMinutesKey, h * 60 + m);
    state = CloseDayReminderState(
      enabled: state.enabled,
      hour: h,
      minute: m,
    );
  }
}
