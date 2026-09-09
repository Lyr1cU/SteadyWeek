import { API_BASE_URL } from '../../config/api';
import { getAccessToken } from '../auth/auth-store';

export class ApiError extends Error {
  constructor(
    message: string,
    readonly status: number,
  ) {
    super(message);
  }
}

function parseApiErrorMessage(body: string, status: number): string {
  if (!body) {
    return status === 401 ? 'Wrong email or password' : 'Request failed';
  }

  try {
    const parsed = JSON.parse(body) as {
      message?: string | string[];
      error?: string;
    };

    const rawMessage = Array.isArray(parsed.message)
      ? parsed.message.join(', ')
      : parsed.message;

    if (rawMessage) {
      if (rawMessage === 'Invalid credentials') {
        return 'Wrong email or password';
      }
      if (rawMessage === 'Email already registered') {
        return 'This email is already registered';
      }
      return rawMessage;
    }
  } catch {
    // Not JSON — fall through to raw body.
  }

  return body;
}

export async function apiFetch<T>(
  path: string,
  init: RequestInit & { auth?: boolean } = {},
): Promise<T> {
  const headers = new Headers(init.headers);
  headers.set('Content-Type', 'application/json');

  if (init.auth !== false) {
    const token = await getAccessToken();
    if (token) {
      headers.set('Authorization', `Bearer ${token}`);
    }
  }

  const response = await fetch(`${API_BASE_URL}${path}`, {
    ...init,
    headers,
  });

  if (!response.ok) {
    const text = await response.text();
    throw new ApiError(parseApiErrorMessage(text, response.status), response.status);
  }

  return (await response.json()) as T;
}

export type AuthResponse = {
  accessToken: string;
  user: { id: string; email: string };
};

export async function registerUser(email: string, password: string): Promise<AuthResponse> {
  return apiFetch<AuthResponse>('/auth/register', {
    method: 'POST',
    auth: false,
    body: JSON.stringify({ email, password }),
  });
}

export async function loginUser(email: string, password: string): Promise<AuthResponse> {
  return apiFetch<AuthResponse>('/auth/login', {
    method: 'POST',
    auth: false,
    body: JSON.stringify({ email, password }),
  });
}
