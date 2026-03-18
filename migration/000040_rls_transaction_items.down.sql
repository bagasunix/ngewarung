-- 000040_rls_transaction_items.down.sql

BEGIN;

ALTER TABLE transaction_items DISABLE ROW LEVEL SECURITY;

COMMIT;

