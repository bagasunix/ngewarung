-- 000048_rls_product_variants.up.sql
-- Tenant isolation for product_variants (scoped by variant -> product -> outlet -> merchant)

BEGIN;

ALTER TABLE product_variants ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS product_variants_by_merchant ON product_variants;

CREATE POLICY product_variants_by_merchant
ON product_variants
FOR ALL
USING (
  app_product_variant_belongs_to_current_merchant(id)
)
WITH CHECK (
  app_product_variant_belongs_to_current_merchant(id)
);

COMMIT;

