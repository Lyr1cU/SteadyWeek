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

    if (response.status === 204) {
      return undefined as T;
    }

    const text = await response.text();
    if (!text) {
      return undefined as T;
    }
    return JSON.parse(text) as T;
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

  listRoutineItems() {
    return this.request('/routine');
  }

  upsertRoutine(body: Record<string, unknown>) {
    return this.request('/routine/upsert', {
      method: 'POST',
      body: JSON.stringify(body),
    });
  }

  setDayItemStatus(body: { dayKey: string; routineItemId: string; status: string }) {
    return this.request('/day-state/status', {
      method: 'POST',
      body: JSON.stringify(body),
    });
  }

  listWeeklyGoals(weekKey: string) {
    return this.request(`/weekly-goals?weekKey=${encodeURIComponent(weekKey)}`);
  }

  upsertWeeklyGoal(body: Record<string, unknown>) {
    return this.request('/weekly-goals/upsert', {
      method: 'POST',
      body: JSON.stringify(body),
    });
  }

  getUserStats() {
    return this.request('/insights/user-stats');
  }

  getDailyReport(dayKey: string) {
    return this.request<Record<string, unknown> | null>(
      `/insights/daily-report?dayKey=${encodeURIComponent(dayKey)}`,
    ).then((row) => row ?? null);
  }

  getWeeklyReport(weekKey?: string) {
    const query = weekKey ? `?weekKey=${encodeURIComponent(weekKey)}` : '';
    return this.request(`/insights/weekly-report${query}`);
  }

  getCloudRevision() {
    return this.request<{ cloudUpdatedAt: string; serverTime: string }>('/sync/revision');
  }

  requestClientSyncNudge() {
    return this.request<{ ok: boolean; nudgeAt: string; serverTime: string }>('/sync/nudge', {
      method: 'POST',
      body: JSON.stringify({}),
    });
  }

  closeDay(body: {
    dayKey: string;
    noteHighlight: string;
    noteReflection: string;
    mood?: number | null;
  }) {
    return this.request('/close-day', {
      method: 'POST',
      body: JSON.stringify(body),
    });
  }
}
