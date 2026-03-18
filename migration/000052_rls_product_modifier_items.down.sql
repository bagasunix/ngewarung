-- 000052_rls_product_modifier_items.down.sql

BEGIN;

ALTER TABLE product_modifier_items DISABLE ROW LEVEL SECURITY;

COMMIT;

