-- 000059_rls_merchants.up.sql
-- Tenant isolation for merchants table

BEGIN;

ALTER TABLE merchants ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS merchants_by_merchant ON merchants;

CREATE POLICY merchants_by_merchant
ON merchants
FOR ALL
USING (
  id = app_current_merchant_id()
)
WITH CHECK (
  id = app_current_merchant_id()
);

COMMIT;

