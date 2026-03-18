-- 000046_rls_client_ops.down.sql

BEGIN;

ALTER TABLE client_ops DISABLE ROW LEVEL SECURITY;

COMMIT;

