-- 000064_rls_fix_product_variants_policy.up.sql
-- Fix potential recursion in RLS helper usage for product_variants policy.

BEGIN;

DROP POLICY IF EXISTS product_variants_by_merchant ON product_variants;

CREATE POLICY product_variants_by_merchant
ON product_variants
FOR ALL
USING (
  EXISTS (
    SELECT 1
    FROM products p
    JOIN outlets o ON o.id = p.outlet_id
    WHERE p.id = product_variants.product_id
      AND o.merchant_id = app_current_merchant_id()
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1
    FROM products p
    JOIN outlets o ON o.id = p.outlet_id
    WHERE p.id = product_variants.product_id
      AND o.merchant_id = app_current_merchant_id()
  )
);

COMMIT;

