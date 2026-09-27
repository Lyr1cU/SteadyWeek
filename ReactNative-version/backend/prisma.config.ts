import 'dotenv/config';
import { defineConfig } from 'prisma/config';

/** Placeholder for `prisma generate` on CI/Render before DATABASE_URL is injected. Migrations/runtime need the real Neon URL. */
const datasourceUrl =
  process.env.DATABASE_URL?.trim() ||
  'postgresql://build:build@127.0.0.1:5432/build?schema=public';

export default defineConfig({
  schema: 'prisma/schema.prisma',
  migrations: {
    path: 'prisma/migrations',
  },
  datasource: {
    url: datasourceUrl,
  },
});
