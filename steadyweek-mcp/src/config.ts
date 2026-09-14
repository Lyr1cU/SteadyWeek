export type SteadyWeekConfig = {
  apiUrl: string;
  email: string;
  password: string;
};

export function loadConfig(): SteadyWeekConfig {
  const apiUrl = (process.env.STEADYWEEK_API_URL ?? 'http://127.0.0.1:3000').replace(
    /\/$/,
    '',
  );
  const email = process.env.STEADYWEEK_EMAIL?.trim() ?? '';
  const password = process.env.STEADYWEEK_PASSWORD ?? '';

  if (!email || !password) {
    throw new Error(
      'Set STEADYWEEK_EMAIL and STEADYWEEK_PASSWORD for MCP (same account as the app).',
    );
  }

  return { apiUrl, email, password };
}
