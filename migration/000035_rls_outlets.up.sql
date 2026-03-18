-- 000035_rls_outlets.up.sql
-- Enable tenant isolation for outlets

BEGIN;

ALTER TABLE outlets ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS outlets_by_merchant ON outlets;

CREATE POLICY outlets_by_merchant
ON outlets
FOR ALL
USING (
  merchant_id = app_current_merchant_id()
)
WITH CHECK (
  merchant_id = app_current_merchant_id()
);

COMMIT;

