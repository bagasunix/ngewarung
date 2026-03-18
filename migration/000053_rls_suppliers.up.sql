-- 000053_rls_suppliers.up.sql
-- Tenant isolation for suppliers (scoped by merchant_id)

BEGIN;

ALTER TABLE suppliers ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS suppliers_by_merchant ON suppliers;

CREATE POLICY suppliers_by_merchant
ON suppliers
FOR ALL
USING (
  merchant_id = app_current_merchant_id()
)
WITH CHECK (
  merchant_id = app_current_merchant_id()
);

COMMIT;

