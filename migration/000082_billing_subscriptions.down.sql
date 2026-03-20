-- 000082_billing_subscriptions.down.sql

BEGIN;

DROP POLICY IF EXISTS merchant_feature_overrides_by_merchant ON merchant_feature_overrides;
ALTER TABLE merchant_feature_overrides DISABLE ROW LEVEL SECURITY;
DROP TABLE IF EXISTS merchant_feature_overrides;

DROP POLICY IF EXISTS merchant_subscriptions_by_merchant ON merchant_subscriptions;
ALTER TABLE merchant_subscriptions DISABLE ROW LEVEL SECURITY;
DROP TABLE IF EXISTS merchant_subscriptions;

COMMIT;

