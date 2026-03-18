-- 000041_rls_payments.down.sql

BEGIN;

ALTER TABLE payments DISABLE ROW LEVEL SECURITY;

COMMIT;

