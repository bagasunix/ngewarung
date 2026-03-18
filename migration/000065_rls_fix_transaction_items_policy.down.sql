-- 000065_rls_fix_transaction_items_policy.down.sql

BEGIN;

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

