import * as SecureStore from 'expo-secure-store';
import { Platform } from 'react-native';

const TOKEN_KEY = 'steadyweek_access_token';
const EMAIL_KEY = 'steadyweek_user_email';
const USER_ID_KEY = 'steadyweek_user_id';

/** Browser has no Expo SecureStore native module. */
function readItem(key: string): Promise<string | null> {
  if (Platform.OS === 'web') {
    return Promise.resolve(globalThis.localStorage?.getItem(key) ?? null);
  }
  return SecureStore.getItemAsync(key);
}

function writeItem(key: string, value: string): Promise<void> {
  if (Platform.OS === 'web') {
    globalThis.localStorage?.setItem(key, value);
    return Promise.resolve();
  }
  return SecureStore.setItemAsync(key, value);
}

function removeItem(key: string): Promise<void> {
  if (Platform.OS === 'web') {
    globalThis.localStorage?.removeItem(key);
    return Promise.resolve();
  }
  return SecureStore.deleteItemAsync(key);
}

export async function getAccessToken(): Promise<string | null> {
  return readItem(TOKEN_KEY);
}

export async function getUserEmail(): Promise<string | null> {
  return readItem(EMAIL_KEY);
}

export async function getUserId(): Promise<string | null> {
  return readItem(USER_ID_KEY);
}

export async function saveAuthSession(
  accessToken: string,
  email: string,
  userId: string,
): Promise<void> {
  await writeItem(TOKEN_KEY, accessToken);
  await writeItem(EMAIL_KEY, email);
  await writeItem(USER_ID_KEY, userId);
}

export async function clearAuthSession(): Promise<void> {
  await removeItem(TOKEN_KEY);
  await removeItem(EMAIL_KEY);
  await removeItem(USER_ID_KEY);
}

export async function isLoggedIn(): Promise<boolean> {
  const token = await getAccessToken();
  return token != null && token.length > 0;
}
