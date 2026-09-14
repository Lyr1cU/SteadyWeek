import type { SteadyWeekConfig } from './config.js';

type AuthResponse = {
  accessToken: string;
};

export class SteadyWeekApi {
  private token: string | null = null;

  constructor(private readonly config: SteadyWeekConfig) {}

  async ensureAuth(): Promise<void> {
    if (this.token) {
      return;
    }

    const response = await fetch(`${this.config.apiUrl}/auth/login`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        email: this.config.email,
        password: this.config.password,
      }),
    });

    if (!response.ok) {
      const text = await response.text();
      throw new Error(`Login failed (${response.status}): ${text.slice(0, 200)}`);
    }

    const payload = (await response.json()) as AuthResponse;
    if (typeof payload.accessToken !== 'string' || payload.accessToken.length === 0) {
      throw new Error('Login failed: missing accessToken');
    }
    this.token = payload.accessToken;
  }

  private async request<T>(path: string, init: RequestInit = {}, retried = false): Promise<T> {
    await this.ensureAuth();
    const headers = new Headers(init.headers);
    headers.set('Authorization', `Bearer ${this.token}`);
    headers.set('Content-Type', 'application/json');

    const response = await fetch(`${this.config.apiUrl}${path}`, {
      ...init,
      headers,
    });

    if (response.status === 401) {
      if (retried) {
        throw new Error(`API ${path} failed (401 after re-login)`);
      }
      this.token = null;
      await this.ensureAuth();
      return this.request(path, init, true);
    }

    if (!response.ok) {
      const text = await response.text();
      throw new Error(`API ${path} failed (${response.status}): ${text.slice(0, 300)}`);
    }

    return (await response.json()) as T;
  }

  getDay(dayKey: string) {
    return this.request(`/schedule/day?dayKey=${encodeURIComponent(dayKey)}`);
  }

  getWeek(startDayKey?: string) {
    const query = startDayKey
      ? `?startDayKey=${encodeURIComponent(startDayKey)}`
      : '';
    return this.request(`/schedule/week${query}`);
  }

  upsertRoutine(body: Record<string, unknown>) {
    return this.request('/routine/upsert', {
      method: 'POST',
      body: JSON.stringify(body),
    });
  }
}
