-- 000049_rls_product_variant_prices.down.sql

BEGIN;

ALTER TABLE product_variant_prices DISABLE ROW LEVEL SECURITY;

COMMIT;

