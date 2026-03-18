-- 000036_rls_categories.down.sql

BEGIN;

ALTER TABLE categories DISABLE ROW LEVEL SECURITY;

COMMIT;

