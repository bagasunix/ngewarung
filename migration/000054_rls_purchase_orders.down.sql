-- 000054_rls_purchase_orders.down.sql

BEGIN;

ALTER TABLE purchase_orders DISABLE ROW LEVEL SECURITY;

COMMIT;

