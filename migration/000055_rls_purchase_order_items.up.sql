-- 000055_rls_purchase_order_items.up.sql
-- Tenant isolation for purchase_order_items (scoped by purchase_order -> merchant)

BEGIN;

ALTER TABLE purchase_order_items ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS purchase_order_items_by_merchant ON purchase_order_items;

CREATE POLICY purchase_order_items_by_merchant
ON purchase_order_items
FOR ALL
USING (
  app_purchase_order_belongs_to_current_merchant(purchase_order_id)
)
WITH CHECK (
  app_purchase_order_belongs_to_current_merchant(purchase_order_id)
);

COMMIT;

