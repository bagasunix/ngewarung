-- 000056_rls_product_history.up.sql
-- Tenant isolation for product_history (scoped by outlet -> merchant)

BEGIN;

ALTER TABLE product_history ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS product_history_by_merchant ON product_history;

CREATE POLICY product_history_by_merchant
ON product_history
FOR ALL
USING (
  app_outlet_belongs_to_current_merchant(outlet_id)
)
WITH CHECK (
  app_outlet_belongs_to_current_merchant(outlet_id)
);

COMMIT;

