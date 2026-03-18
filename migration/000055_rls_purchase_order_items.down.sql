-- 000055_rls_purchase_order_items.down.sql

BEGIN;

ALTER TABLE purchase_order_items DISABLE ROW LEVEL SECURITY;

COMMIT;

