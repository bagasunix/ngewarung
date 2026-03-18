-- 000064_rls_fix_product_variants_policy.down.sql

BEGIN;

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

