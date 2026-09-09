/** API base URL. Override with EXPO_PUBLIC_API_URL in .env */
export const API_BASE_URL =
  process.env.EXPO_PUBLIC_API_URL?.replace(/\/$/, '') ?? 'http://localhost:3000';
