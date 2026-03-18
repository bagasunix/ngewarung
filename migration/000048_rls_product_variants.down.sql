-- 000048_rls_product_variants.down.sql

BEGIN;

ALTER TABLE product_variants DISABLE ROW LEVEL SECURITY;

COMMIT;

