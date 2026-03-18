-- 000051_rls_product_modifiers.down.sql

BEGIN;

ALTER TABLE product_modifiers DISABLE ROW LEVEL SECURITY;

COMMIT;

