import type { ReportsRepository } from '../ports';

/** Phase 4 — daily reports after close-day. Empty until then. */
export function createSqliteReportsRepository(): ReportsRepository {
  return {
    async getDaily(_dayKey: string) {
      return null;
    },
  };
}
