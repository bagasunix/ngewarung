-- 000057_rls_transaction_item_modifiers.down.sql

BEGIN;

ALTER TABLE transaction_item_modifiers DISABLE ROW LEVEL SECURITY;

COMMIT;

