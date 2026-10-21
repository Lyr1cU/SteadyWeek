import Constants, { ExecutionEnvironment } from 'expo-constants';
import { Platform } from 'react-native';

let handlerInstalled = false;

function isNativeDevOrReleaseBuild(): boolean {
  if (Platform.OS === 'web') {
    return false;
  }
  return Constants.executionEnvironment !== ExecutionEnvironment.StoreClient;
}

/** Local notifications — dev / release builds only (not Expo Go on Android). */
export function localNotificationsAvailable(): boolean {
  return isNativeDevOrReleaseBuild();
}

/** @deprecated use localNotificationsAvailable */
export function closeDayRemindersAvailable(): boolean {
  return localNotificationsAvailable();
}

export async function loadNotificationsModule() {
  return import('expo-notifications');
}

export type NotificationsModule = Awaited<ReturnType<typeof loadNotificationsModule>>;

export async function ensureNotificationsReady(
  Notifications: NotificationsModule,
): Promise<boolean> {
  if (!handlerInstalled) {
    Notifications.setNotificationHandler({
      handleNotification: async () => ({
        shouldShowAlert: true,
        shouldPlaySound: true,
        shouldSetBadge: false,
        shouldShowBanner: true,
        shouldShowList: true,
      }),
    });
    handlerInstalled = true;
  }

  const { status: existing } = await Notifications.getPermissionsAsync();
  if (existing === 'granted') {
    return true;
  }
  const { status } = await Notifications.requestPermissionsAsync();
  return status === 'granted';
}

export async function ensureAndroidChannel(
  Notifications: NotificationsModule,
  channelId: string,
  name: string,
  description: string,
  importance: number,
) {
  if (Platform.OS !== 'android') {
    return;
  }
  const alarm = importance >= Notifications.AndroidImportance.MAX;
  await Notifications.setNotificationChannelAsync(channelId, {
    name,
    description,
    importance,
    lightColor: '#CAB8FF',
    lockscreenVisibility: Notifications.AndroidNotificationVisibility.PUBLIC,
    sound: 'default',
    enableVibrate: true,
    vibrationPattern: [0, 280, 180, 280],
    bypassDnd: alarm,
    audioAttributes: alarm
      ? {
          usage: Notifications.AndroidAudioUsage.ALARM,
          contentType: Notifications.AndroidAudioContentType.SONIFICATION,
        }
      : undefined,
  });
}
