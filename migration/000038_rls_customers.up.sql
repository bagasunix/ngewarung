-- 000038_rls_customers.up.sql
-- Tenant isolation for customers

BEGIN;

ALTER TABLE customers ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS customers_by_merchant ON customers;

CREATE POLICY customers_by_merchant
ON customers
FOR ALL
USING (
  app_outlet_belongs_to_current_merchant(outlet_id)
)
WITH CHECK (
  app_outlet_belongs_to_current_merchant(outlet_id)
);

COMMIT;

