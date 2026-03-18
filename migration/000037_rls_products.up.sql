-- 000037_rls_products.up.sql
-- Tenant isolation for products

BEGIN;

ALTER TABLE products ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS products_by_merchant ON products;

CREATE POLICY products_by_merchant
ON products
FOR ALL
USING (
  app_outlet_belongs_to_current_merchant(outlet_id)
)
WITH CHECK (
  app_outlet_belongs_to_current_merchant(outlet_id)
);

COMMIT;

