-- 000057_rls_transaction_item_modifiers.up.sql
-- Tenant isolation for transaction_item_modifiers (via transaction_item -> transactions -> outlets -> merchant)

BEGIN;

ALTER TABLE transaction_item_modifiers ENABLE ROW LEVEL SECURITY;

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

