-- 000042_rls_expenses.down.sql

BEGIN;

ALTER TABLE expenses DISABLE ROW LEVEL SECURITY;

COMMIT;

