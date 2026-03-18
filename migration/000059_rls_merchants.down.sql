-- 000059_rls_merchants.down.sql

BEGIN;

ALTER TABLE merchants DISABLE ROW LEVEL SECURITY;

COMMIT;

