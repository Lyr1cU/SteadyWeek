import * as SecureStore from 'expo-secure-store';

const TOKEN_KEY = 'steadyweek_access_token';
const EMAIL_KEY = 'steadyweek_user_email';
const USER_ID_KEY = 'steadyweek_user_id';

export async function getAccessToken(): Promise<string | null> {
  return SecureStore.getItemAsync(TOKEN_KEY);
}

export async function getUserEmail(): Promise<string | null> {
  return SecureStore.getItemAsync(EMAIL_KEY);
}

export async function getUserId(): Promise<string | null> {
  return SecureStore.getItemAsync(USER_ID_KEY);
}

export async function saveAuthSession(
  accessToken: string,
  email: string,
  userId: string,
): Promise<void> {
  await SecureStore.setItemAsync(TOKEN_KEY, accessToken);
  await SecureStore.setItemAsync(EMAIL_KEY, email);
  await SecureStore.setItemAsync(USER_ID_KEY, userId);
}

export async function clearAuthSession(): Promise<void> {
  await SecureStore.deleteItemAsync(TOKEN_KEY);
  await SecureStore.deleteItemAsync(EMAIL_KEY);
  await SecureStore.deleteItemAsync(USER_ID_KEY);
}

export async function isLoggedIn(): Promise<boolean> {
  const token = await getAccessToken();
  return token != null && token.length > 0;
}
