-- 000022_products_add_unit_id.down.sql

BEGIN;

ALTER TABLE products
  DROP COLUMN IF EXISTS unit_id;

COMMIT;

