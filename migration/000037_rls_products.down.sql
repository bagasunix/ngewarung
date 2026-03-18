-- 000037_rls_products.down.sql

BEGIN;

ALTER TABLE products DISABLE ROW LEVEL SECURITY;

COMMIT;

