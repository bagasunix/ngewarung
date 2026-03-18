-- 000066_rls_fix_transaction_item_modifiers_policy.down.sql

BEGIN;

DROP POLICY IF EXISTS transaction_item_modifiers_by_merchant ON transaction_item_modifiers;

CREATE POLICY transaction_item_modifiers_by_merchant
ON transaction_item_modifiers
FOR ALL
USING (
  app_transaction_item_belongs_to_current_merchant(transaction_item_id)
)
WITH CHECK (
  app_transaction_item_belongs_to_current_merchant(transaction_item_id)
);

COMMIT;

