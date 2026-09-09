import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:life_balance/data/drift/local_db_backup.dart';
import 'package:life_balance/providers/close_day_reminder_provider.dart';
import 'package:life_balance/providers/theme_preference_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'cloud/supabase_bootstrap.dart';
import 'notifications/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('en');
  await initializeDateFormatting('en_US');
  await initializeDateFormatting('uk');
  await initializeDateFormatting('uk_UA');

  final prefs = await SharedPreferences.getInstance();

  if (!kIsWeb) {
    await applyPendingDbRestoreIfNeeded(prefs);
  }

  try {
    await initSupabaseIfConfigured();
  } catch (e, st) {
    debugPrint('Supabase init: $e\n$st');
  }

  if (!kIsWeb) {
    try {
      await NotificationService.instance.init();
      final reminderOn =
          prefs.getBool(kCloseDayReminderEnabledKey) ?? true;
      final mins = prefs.getInt(kCloseDayReminderMinutesKey) ??
          kDefaultCloseDayReminderMinutes;
      final clamped = mins.clamp(0, 23 * 60 + 59);
      if (reminderOn) {
        await NotificationService.instance.scheduleCloseDayReminder(
          hour: clamped ~/ 60,
          minute: clamped % 60,
        );
      }
    } catch (e, st) {
      debugPrint('NotificationService: $e\n$st');
    }
  }

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const LifeBalanceApp(),
    ),
  );
}
