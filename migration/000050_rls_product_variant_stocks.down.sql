-- 000050_rls_product_variant_stocks.down.sql

BEGIN;

ALTER TABLE product_variant_stocks DISABLE ROW LEVEL SECURITY;

COMMIT;

