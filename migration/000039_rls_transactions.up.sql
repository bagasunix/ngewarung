-- 000039_rls_transactions.up.sql
-- Tenant isolation for transactions

BEGIN;

ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS transactions_by_merchant ON transactions;

CREATE POLICY transactions_by_merchant
ON transactions
FOR ALL
USING (
  app_outlet_belongs_to_current_merchant(outlet_id)
)
WITH CHECK (
  app_outlet_belongs_to_current_merchant(outlet_id)
);

COMMIT;

