import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:life_balance/l10n/app_localizations.dart';
import 'package:life_balance/notifications/notification_service.dart';
import 'package:life_balance/providers/close_day_reminder_provider.dart';

/// Reschedules or cancels the daily close-day notification from prefs + [l10n].
Future<void> syncCloseDayReminderWithLocale(
  WidgetRef ref,
  BuildContext context,
) async {
  if (kIsWeb) return;
  final l10n = AppLocalizations.of(context);
  if (l10n == null) return;

  await NotificationService.instance.init();
  final s = ref.read(closeDayReminderProvider);
  if (!s.enabled) {
    await NotificationService.instance.cancelCloseDayReminder();
    return;
  }
  await NotificationService.instance.scheduleCloseDayReminder(
    hour: s.hour,
    minute: s.minute,
    title: l10n.notifCloseDayTitle,
    body: l10n.notifCloseDayBody,
  );
}
