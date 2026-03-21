-- 000022_products_add_unit_id.up.sql
-- Add unit_id to products (keep unit text for backward compatibility)

BEGIN;

ALTER TABLE products
  ADD COLUMN IF NOT EXISTS unit_id UUID REFERENCES units(id) ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS idx_products_unit_id ON products(unit_id);

COMMENT ON COLUMN products.unit_id IS 'Referensi master units (selain kolom unit teks legacy).';

COMMIT;

