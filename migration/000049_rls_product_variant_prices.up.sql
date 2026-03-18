-- 000049_rls_product_variant_prices.up.sql
-- Tenant isolation for product_variant_prices

BEGIN;

ALTER TABLE product_variant_prices ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS product_variant_prices_by_merchant ON product_variant_prices;

CREATE POLICY product_variant_prices_by_merchant
ON product_variant_prices
FOR ALL
USING (
  app_outlet_belongs_to_current_merchant(outlet_id)
)
WITH CHECK (
  app_outlet_belongs_to_current_merchant(outlet_id)
);

COMMIT;

