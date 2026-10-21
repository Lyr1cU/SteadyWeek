import * as SecureStore from 'expo-secure-store';
import { Platform } from 'react-native';

const KEY = 'reminder_presentation';

/** Shade stays in the notification tray. Screen wakes the lock screen. */
export type ReminderPresentation = 'shade' | 'screen';

export async function getReminderPresentation(): Promise<ReminderPresentation> {
  if (Platform.OS === 'web') {
    return 'shade';
  }
  try {
    const value = await SecureStore.getItemAsync(KEY);
    return value === 'screen' ? 'screen' : 'shade';
  } catch {
    return 'shade';
  }
}

export async function setReminderPresentation(value: ReminderPresentation): Promise<void> {
  if (Platform.OS === 'web') {
    return;
  }
  await SecureStore.setItemAsync(KEY, value);
}
