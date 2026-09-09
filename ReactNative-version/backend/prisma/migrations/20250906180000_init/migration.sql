-- CreateSchema
CREATE TABLE "users" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "password_hash" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

CREATE TABLE "routine_items" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "sphere" TEXT NOT NULL,
    "weekdays" INTEGER NOT NULL,
    "sort_order" INTEGER NOT NULL,
    "effort" TEXT NOT NULL,
    "is_optional" BOOLEAN NOT NULL DEFAULT false,
    "scheduled_minute_of_day" INTEGER,
    "created_at" TIMESTAMP(3) NOT NULL,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),
    CONSTRAINT "routine_items_pkey" PRIMARY KEY ("id")
);

CREATE INDEX "routine_items_user_id_updated_at_idx" ON "routine_items"("user_id", "updated_at");

CREATE TABLE "day_item_status" (
    "user_id" TEXT NOT NULL,
    "day_key" TEXT NOT NULL,
    "routine_item_id" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "updated_at" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "day_item_status_pkey" PRIMARY KEY ("user_id","day_key","routine_item_id")
);

CREATE INDEX "day_item_status_user_id_updated_at_idx" ON "day_item_status"("user_id", "updated_at");

CREATE TABLE "app_settings" (
    "user_id" TEXT NOT NULL,
    "key" TEXT NOT NULL,
    "value" TEXT NOT NULL,
    "updated_at" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "app_settings_pkey" PRIMARY KEY ("user_id","key")
);

CREATE INDEX "app_settings_user_id_updated_at_idx" ON "app_settings"("user_id", "updated_at");

CREATE TABLE "user_stats" (
    "user_id" TEXT NOT NULL,
    "total_xp" INTEGER NOT NULL DEFAULT 0,
    "current_streak" INTEGER NOT NULL DEFAULT 0,
    "best_streak" INTEGER NOT NULL DEFAULT 0,
    "last_green_day_key" TEXT,
    "updated_at" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "user_stats_pkey" PRIMARY KEY ("user_id")
);

ALTER TABLE "routine_items" ADD CONSTRAINT "routine_items_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "day_item_status" ADD CONSTRAINT "day_item_status_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "app_settings" ADD CONSTRAINT "app_settings_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "user_stats" ADD CONSTRAINT "user_stats_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
