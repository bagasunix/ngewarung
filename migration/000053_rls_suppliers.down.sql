-- 000053_rls_suppliers.down.sql

BEGIN;

ALTER TABLE suppliers DISABLE ROW LEVEL SECURITY;

COMMIT;

