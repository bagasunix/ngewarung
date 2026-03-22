-- 000068_rls_merchant_configs.up.sql
-- Tenant isolation for merchant_configs

BEGIN;

ALTER TABLE merchant_configs ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS merchant_configs_by_merchant ON merchant_configs;

CREATE POLICY merchant_configs_by_merchant
ON merchant_configs
FOR ALL
USING (
  merchant_id = app_current_merchant_id()
)
WITH CHECK (
  merchant_id = app_current_merchant_id()
);

COMMIT;

