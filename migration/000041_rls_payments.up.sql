-- 000041_rls_payments.up.sql
-- Tenant isolation for payments (via transactions -> outlets)

BEGIN;

ALTER TABLE payments ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS payments_by_merchant ON payments;

CREATE POLICY payments_by_merchant
ON payments
FOR ALL
USING (
  app_transaction_belongs_to_current_merchant(transaction_id)
)
WITH CHECK (
  app_transaction_belongs_to_current_merchant(transaction_id)
);

COMMIT;

