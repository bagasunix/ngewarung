-- 000042_rls_expenses.up.sql
-- Tenant isolation for expenses

BEGIN;

ALTER TABLE expenses ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS expenses_by_merchant ON expenses;

CREATE POLICY expenses_by_merchant
ON expenses
FOR ALL
USING (
  app_outlet_belongs_to_current_merchant(outlet_id)
)
WITH CHECK (
  app_outlet_belongs_to_current_merchant(outlet_id)
);

COMMIT;

