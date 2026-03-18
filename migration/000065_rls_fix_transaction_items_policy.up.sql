-- 000065_rls_fix_transaction_items_policy.up.sql
-- Fix potential recursion in RLS helper usage for transaction_items policy.

BEGIN;

DROP POLICY IF EXISTS transaction_items_by_merchant ON transaction_items;

CREATE POLICY transaction_items_by_merchant
ON transaction_items
FOR ALL
USING (
  EXISTS (
    SELECT 1
    FROM transactions t
    JOIN outlets o ON o.id = t.outlet_id
    WHERE t.id = transaction_items.transaction_id
      AND o.merchant_id = app_current_merchant_id()
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1
    FROM transactions t
    JOIN outlets o ON o.id = t.outlet_id
    WHERE t.id = transaction_items.transaction_id
      AND o.merchant_id = app_current_merchant_id()
  )
);

COMMIT;

