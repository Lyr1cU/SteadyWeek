import { createSqliteRepositories } from '../data/sqlite/create-sqlite-repos';
import type { AppRepositories } from '../data/ports';

/** Single place to swap sqlite → cloud-backed cache. Memory adapter is tests-only. */
export async function createAppRepositories(): Promise<AppRepositories> {
  return createSqliteRepositories();
}

export { createMemoryRepositories } from '../data/memory/create-memory-repos';
