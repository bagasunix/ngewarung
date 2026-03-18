-- 000044_rls_tagihan_payments.down.sql

BEGIN;

ALTER TABLE tagihan_payments DISABLE ROW LEVEL SECURITY;

COMMIT;

