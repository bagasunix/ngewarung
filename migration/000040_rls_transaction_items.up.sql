-- 000040_rls_transaction_items.up.sql
-- Tenant isolation for transaction_items (via transactions -> outlets)

BEGIN;

ALTER TABLE transaction_items ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS transaction_items_by_merchant ON transaction_items;

CREATE POLICY transaction_items_by_merchant
ON transaction_items
FOR ALL
USING (
  app_transaction_item_belongs_to_current_merchant(id)
)
WITH CHECK (
  app_transaction_item_belongs_to_current_merchant(id)
);

COMMIT;

