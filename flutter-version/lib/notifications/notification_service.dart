import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:life_balance/core/date_key.dart';
import 'package:life_balance/data/drift/app_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// Local notifications (system shade). No-op on web.
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  static const _closeDayChannelId = 'close_day_v2';
  static const _closeDayNotifId = 1001;

  static const _routineChannelId = 'routine_reminders_v2';
  static const _routineIdsKey = 'routine_scheduled_notif_ids_v1';
  static const _routineNotifBase = 6000;

  static int _routineNotifId(int itemId, int weekday) =>
      _routineNotifBase + itemId * 10 + weekday;

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> init() async {
    if (kIsWeb || _initialized) return;

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwin = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: darwin);
    await _plugin.initialize(settings);

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      final androidImpl = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      await androidImpl?.requestNotificationsPermission();
      // Opens app-specific alarm screen on Android 12+ (plugin handles API quirks).
      await androidImpl?.requestExactAlarmsPermission();
    }

    tzdata.initializeTimeZones();
    try {
      final name = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(name));
    } catch (e) {
      debugPrint('FlutterTimezone.getLocalTimezone failed: $e');
      try {
        tz.setLocalLocation(tz.getLocation('Europe/Kyiv'));
      } catch (_) {
        try {
          tz.setLocalLocation(tz.getLocation('Europe/Kiev'));
        } catch (_) {
          tz.setLocalLocation(tz.UTC);
          debugPrint('Timezone fallback is UTC — scheduled times may be wrong!');
        }
      }
    }

    _initialized = true;
  }

  /// Repeats every day at [hour]:[minute] local time.
  Future<void> scheduleCloseDayReminder({
    int hour = 21,
    int minute = 0,
    String title = 'Life Balance',
    String body = 'Take a minute to close your day and check in.',
  }) async {
    if (kIsWeb) return;
    await init();

    final android = AndroidNotificationDetails(
      _closeDayChannelId,
      'Daily check-in',
      channelDescription: 'Reminder to close your day',
      importance: Importance.high,
      priority: Priority.high,
    );
    const darwin = DarwinNotificationDetails();
    final details = NotificationDetails(android: android, iOS: darwin);

    await _plugin.cancel(_closeDayNotifId);
    final when = _nextInstanceOf(hour, minute);
    debugPrint(
      'scheduleCloseDayReminder: local=${tz.local.name} first=$when '
      '(device now: ${DateTime.now()})',
    );

    try {
      await _plugin.zonedSchedule(
        _closeDayNotifId,
        title,
        body,
        when,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (e, st) {
      debugPrint('Close-day exact schedule failed, trying inexact: $e\n$st');
      await _plugin.zonedSchedule(
        _closeDayNotifId,
        title,
        body,
        when,
        details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  /// Debug / QA: proves channel + permission; does not test the alarm scheduler.
  Future<void> showDebugTestNow() async {
    if (kIsWeb) return;
    await init();
    const android = AndroidNotificationDetails(
      'debug_test_v1',
      'Debug',
      channelDescription: 'Debug-only test',
      importance: Importance.max,
      priority: Priority.max,
    );
    const darwin = DarwinNotificationDetails();
    await _plugin.show(
      9998,
      'Life Balance',
      'Test notification — channel works.',
      const NotificationDetails(android: android, iOS: darwin),
    );
  }

  Future<void> cancelCloseDayReminder() async {
    if (kIsWeb) return;
    await _plugin.cancel(_closeDayNotifId);
  }

  /// Weekly alarms for each [RoutineItem] with a fixed time, on active weekdays.
  Future<void> syncRoutineReminders({
    required List<RoutineItem> items,
    required String notificationTitle,
    required String Function(String itemTitle) bodyForItem,
  }) async {
    if (kIsWeb) return;
    await init();

    final prefs = await SharedPreferences.getInstance();
    await _cancelRoutineIdsFromPrefs(prefs);

    final android = AndroidNotificationDetails(
      _routineChannelId,
      'Routine reminders',
      channelDescription: 'Reminders at scheduled routine times',
      importance: Importance.high,
      priority: Priority.high,
    );
    const darwin = DarwinNotificationDetails();
    final details = NotificationDetails(android: android, iOS: darwin);

    final newIds = <int>[];
    for (final item in items) {
      final minsTotal = item.scheduledMinuteOfDay;
      if (minsTotal == null) continue;
      final h = minsTotal ~/ 60;
      final m = minsTotal % 60;
      for (var wd = DateTime.monday; wd <= DateTime.sunday; wd++) {
        if (!routineRunsOnWeekday(item.weekdays, wd)) continue;
        final id = _routineNotifId(item.id, wd);
        newIds.add(id);
        final scheduled = _nextInstanceWeekday(wd, h, m);
        try {
          await _plugin.zonedSchedule(
            id,
            notificationTitle,
            bodyForItem(item.title),
            scheduled,
            details,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
          );
        } catch (e, st) {
          debugPrint('Routine notif $id: $e\n$st');
        }
      }
    }

    await prefs.setString(
      _routineIdsKey,
      newIds.isEmpty ? '' : newIds.join(','),
    );
  }

  Future<void> _cancelRoutineIdsFromPrefs(SharedPreferences prefs) async {
    final raw = prefs.getString(_routineIdsKey);
    if (raw == null || raw.isEmpty) return;
    for (final part in raw.split(',')) {
      final id = int.tryParse(part.trim());
      if (id != null) {
        await _plugin.cancel(id);
      }
    }
  }

  tz.TZDateTime _nextInstanceOf(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (!scheduled.isAfter(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  tz.TZDateTime _nextInstanceWeekday(int weekday, int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    while (scheduled.weekday != weekday || !scheduled.isAfter(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
