-- 000054_rls_purchase_orders.up.sql
-- Tenant isolation for purchase_orders (scoped by merchant_id)

BEGIN;

ALTER TABLE purchase_orders ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS purchase_orders_by_merchant ON purchase_orders;

CREATE POLICY purchase_orders_by_merchant
ON purchase_orders
FOR ALL
USING (
  merchant_id = app_current_merchant_id()
)
WITH CHECK (
  merchant_id = app_current_merchant_id()
);

COMMIT;

