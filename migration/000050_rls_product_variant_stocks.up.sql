-- 000050_rls_product_variant_stocks.up.sql
-- Tenant isolation for product_variant_stocks

BEGIN;

ALTER TABLE product_variant_stocks ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS product_variant_stocks_by_merchant ON product_variant_stocks;

CREATE POLICY product_variant_stocks_by_merchant
ON product_variant_stocks
FOR ALL
USING (
  app_outlet_belongs_to_current_merchant(outlet_id)
)
WITH CHECK (
  app_outlet_belongs_to_current_merchant(outlet_id)
);

COMMIT;

