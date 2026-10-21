import { Platform } from 'react-native';
import type { RoutineItem } from '../domain/models';
import { strings } from '../l10n';
import { weekdayMaskFromIndex } from '../logic/weekdays';
import {
  canScheduleExactAlarms,
  canUseFullScreenIntent,
  openExactAlarmSettings,
  openFullScreenSettings,
} from '../../modules/steadyweek-alarms';
import {
  ensureAndroidChannel,
  ensureNotificationsReady,
  loadNotificationsModule,
  localNotificationsAvailable,
} from './local-notifications-core';
import { routineChannelId } from './reminder-channels';
import { getReminderPresentation, type ReminderPresentation } from './reminder-presentation';

const ROUTINE_ID_PREFIX = 'routine-';
const EXACT_ALARM_PROMPTED = 'exact_alarm_prompted';
const FULLSCREEN_PROMPTED = 'fullscreen_prompted';

/** Expo weekly trigger: 1 = Sunday … 7 = Saturday (see expo-notifications docs). */
function expoWeekdayFromMondayIndex(mondayBasedIndex: number): number {
  const jsDay = mondayBasedIndex === 6 ? 0 : mondayBasedIndex + 1;
  return jsDay + 1;
}

function routineNotificationId(itemId: string, weekdayIndex: number): string {
  return `${ROUTINE_ID_PREFIX}${itemId}-${weekdayIndex}`;
}

let reminderChain: Promise<void> = Promise.resolve();

async function prompted(key: string): Promise<boolean> {
  const SecureStore = await import('expo-secure-store');
  return (await SecureStore.getItemAsync(key)) === '1';
}

async function markPrompted(key: string): Promise<void> {
  const SecureStore = await import('expo-secure-store');
  await SecureStore.setItemAsync(key, '1');
}

/**
 * Exact alarms are install-granted via USE_EXACT_ALARM. If a device still
 * refuses them, ask once. Full-screen is a separate toggle the user must allow.
 */
export async function requestMissingAlarmAccess(
  presentation: ReminderPresentation,
  forceFullScreen: boolean,
): Promise<void> {
  if (Platform.OS !== 'android') {
    return;
  }
  if (!canScheduleExactAlarms() && !(await prompted(EXACT_ALARM_PROMPTED))) {
    await markPrompted(EXACT_ALARM_PROMPTED);
    openExactAlarmSettings();
    return;
  }
  if (presentation !== 'screen' || canUseFullScreenIntent()) {
    return;
  }
  if (forceFullScreen || !(await prompted(FULLSCREEN_PROMPTED))) {
    await markPrompted(FULLSCREEN_PROMPTED);
    openFullScreenSettings();
  }
}

async function cancelRoutineScheduledNotifications(
  Notifications: Awaited<ReturnType<typeof loadNotificationsModule>>,
) {
  const scheduled = await Notifications.getAllScheduledNotificationsAsync();
  await Promise.all(
    scheduled
      .filter((entry) => entry.identifier.startsWith(ROUTINE_ID_PREFIX))
      .map((entry) => Notifications.cancelScheduledNotificationAsync(entry.identifier)),
  );
}

/**
 * One writer at a time. A newer call waits until the current cancel-and-schedule
 * finishes, then replaces the alarms. Dropping out after cancel used to leave
 * a deleted item's alarm in place.
 */
export function syncRoutineReminders(items: RoutineItem[]): Promise<void> {
  if (!localNotificationsAvailable()) {
    return Promise.resolve();
  }

  const snapshot = items.slice();
  const job = reminderChain.then(() => writeRoutineReminders(snapshot));
  reminderChain = job.then(
    () => undefined,
    () => undefined,
  );
  return job;
}

async function writeRoutineReminders(items: RoutineItem[]): Promise<void> {
  const Notifications = await loadNotificationsModule();
  const granted = await ensureNotificationsReady(Notifications);
  if (!granted) {
    return;
  }

  const presentation = await getReminderPresentation();
  await requestMissingAlarmAccess(presentation, false);

  const channelId = routineChannelId(presentation);
  const fullScreen = presentation === 'screen';
  await ensureAndroidChannel(
    Notifications,
    channelId,
    fullScreen ? 'Routine alarms' : 'Routine reminders',
    fullScreen
      ? 'Turns the screen on at scheduled routine times'
      : 'Reminders at scheduled routine times',
    fullScreen ? Notifications.AndroidImportance.MAX : Notifications.AndroidImportance.HIGH,
  );

  await cancelRoutineScheduledNotifications(Notifications);

  const copy = strings().notifications;
  const androidChannelId = Platform.OS === 'android' ? channelId : undefined;

  for (const item of items) {
    const minuteOfDay = item.scheduledMinuteOfDay;
    if (minuteOfDay == null) {
      continue;
    }
    const hour = Math.floor(minuteOfDay / 60);
    const minute = minuteOfDay % 60;

    for (let weekdayIndex = 0; weekdayIndex < 7; weekdayIndex += 1) {
      if ((item.weekdays & weekdayMaskFromIndex(weekdayIndex)) === 0) {
        continue;
      }

      await Notifications.scheduleNotificationAsync({
        identifier: routineNotificationId(item.id, weekdayIndex),
        content: {
          title: copy.routineTitle,
          body: copy.routineBody(item.title),
          sound: true,
          priority: fullScreen
            ? Notifications.AndroidNotificationPriority.MAX
            : Notifications.AndroidNotificationPriority.HIGH,
          data: fullScreen ? { fullScreen: true } : undefined,
        },
        trigger: {
          type: Notifications.SchedulableTriggerInputTypes.WEEKLY,
          weekday: expoWeekdayFromMondayIndex(weekdayIndex),
          hour,
          minute,
          channelId: androidChannelId,
        },
      });
    }
  }
}
