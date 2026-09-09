import type { GoalsRepository } from '../ports';

/** Phase 4 — weekly goals CRUD. Empty until then. */
export function createSqliteGoalsRepository(): GoalsRepository {
  return {
    async listForWeek(_weekKey: string) {
      return [];
    },
  };
}
