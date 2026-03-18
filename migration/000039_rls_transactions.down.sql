-- 000039_rls_transactions.down.sql

BEGIN;

ALTER TABLE transactions DISABLE ROW LEVEL SECURITY;

COMMIT;

