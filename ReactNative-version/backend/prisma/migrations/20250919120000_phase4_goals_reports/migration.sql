-- Phase 4: weekly goals, daily reports, weekly reports

CREATE TABLE "weekly_goals" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "week_key" TEXT NOT NULL,
    "sphere" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "target_count" INTEGER NOT NULL DEFAULT 1,
    "progress_count" INTEGER NOT NULL DEFAULT 0,
    "status" TEXT NOT NULL DEFAULT 'active',
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),
    CONSTRAINT "weekly_goals_pkey" PRIMARY KEY ("id")
);

CREATE INDEX "weekly_goals_user_id_updated_at_idx" ON "weekly_goals"("user_id", "updated_at");

CREATE TABLE "daily_reports" (
    "user_id" TEXT NOT NULL,
    "day_key" TEXT NOT NULL,
    "mood" INTEGER,
    "note_highlight" TEXT NOT NULL DEFAULT '',
    "note_reflection" TEXT NOT NULL DEFAULT '',
    "day_tier" TEXT NOT NULL,
    "xp_awarded" INTEGER NOT NULL DEFAULT 0,
    "closed_at" TIMESTAMP(3) NOT NULL,
    "updated_at" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "daily_reports_pkey" PRIMARY KEY ("user_id","day_key")
);

CREATE INDEX "daily_reports_user_id_updated_at_idx" ON "daily_reports"("user_id", "updated_at");

CREATE TABLE "weekly_reports" (
    "user_id" TEXT NOT NULL,
    "week_key" TEXT NOT NULL,
    "note_win" TEXT NOT NULL DEFAULT '',
    "note_focus" TEXT NOT NULL DEFAULT '',
    "updated_at" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "weekly_reports_pkey" PRIMARY KEY ("user_id","week_key")
);

CREATE INDEX "weekly_reports_user_id_updated_at_idx" ON "weekly_reports"("user_id", "updated_at");

ALTER TABLE "weekly_goals" ADD CONSTRAINT "weekly_goals_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "daily_reports" ADD CONSTRAINT "daily_reports_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "weekly_reports" ADD CONSTRAINT "weekly_reports_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
