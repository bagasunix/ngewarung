-- 000045_rls_daily_summaries.down.sql

BEGIN;

ALTER TABLE daily_summaries DISABLE ROW LEVEL SECURITY;

COMMIT;

