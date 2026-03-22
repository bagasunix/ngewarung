-- 000073_billing_usage_and_entitlements.down.sql

BEGIN;

DROP POLICY IF EXISTS merchant_entitlements_by_merchant ON merchant_entitlements;
ALTER TABLE merchant_entitlements DISABLE ROW LEVEL SECURITY;
DROP TABLE IF EXISTS merchant_entitlements;

DROP POLICY IF EXISTS billing_usage_daily_by_merchant ON billing_usage_daily;
ALTER TABLE billing_usage_daily DISABLE ROW LEVEL SECURITY;
DROP TABLE IF EXISTS billing_usage_daily;

COMMIT;

