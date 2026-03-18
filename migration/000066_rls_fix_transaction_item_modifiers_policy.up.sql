-- 000066_rls_fix_transaction_item_modifiers_policy.up.sql
-- Fix potential recursion by removing helper usage from transaction_item_modifiers policy.

BEGIN;

DROP POLICY IF EXISTS transaction_item_modifiers_by_merchant ON transaction_item_modifiers;

CREATE POLICY transaction_item_modifiers_by_merchant
ON transaction_item_modifiers
FOR ALL
USING (
  EXISTS (
    SELECT 1
    FROM transaction_items ti
    JOIN transactions t ON t.id = ti.transaction_id
    JOIN outlets o ON o.id = t.outlet_id
    WHERE ti.id = transaction_item_modifiers.transaction_item_id
      AND o.merchant_id = app_current_merchant_id()
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1
    FROM transaction_items ti
    JOIN transactions t ON t.id = ti.transaction_id
    JOIN outlets o ON o.id = t.outlet_id
    WHERE ti.id = transaction_item_modifiers.transaction_item_id
      AND o.merchant_id = app_current_merchant_id()
  )
);

COMMIT;

