-- 000078_rls_merchant_configs.down.sql

BEGIN;

ALTER TABLE merchant_configs DISABLE ROW LEVEL SECURITY;

COMMIT;

