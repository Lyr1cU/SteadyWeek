export class AssistantRateLimiter {
  private readonly requestLog = new Map<string, number[]>();

  assert(userId: string): boolean {
    const limit = Number(process.env.ASSISTANT_RATE_LIMIT_PER_MIN ?? 10);
    const windowMs = 60_000;
    const now = Date.now();
    const recent = (this.requestLog.get(userId) ?? []).filter((ts) => now - ts < windowMs);

    if (recent.length >= limit) {
      this.requestLog.set(userId, recent);
      return false;
    }

    recent.push(now);
    this.requestLog.set(userId, recent);
    return true;
  }
}
