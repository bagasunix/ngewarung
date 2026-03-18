-- 000051_rls_product_modifiers.up.sql
-- Tenant isolation for product_modifiers (scoped by merchant_id)

BEGIN;

ALTER TABLE product_modifiers ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS product_modifiers_by_merchant ON product_modifiers;

CREATE POLICY product_modifiers_by_merchant
ON product_modifiers
FOR ALL
USING (
  merchant_id = app_current_merchant_id()
)
WITH CHECK (
  merchant_id = app_current_merchant_id()
);

COMMIT;

