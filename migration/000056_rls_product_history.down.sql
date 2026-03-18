-- 000056_rls_product_history.down.sql

BEGIN;

ALTER TABLE product_history DISABLE ROW LEVEL SECURITY;

COMMIT;

