-- 000070_billing_plans_catalog.down.sql

BEGIN;

DROP TABLE IF EXISTS billing_plan_features;
DROP TABLE IF EXISTS billing_plan_prices;
DROP TABLE IF EXISTS billing_plans;

COMMIT;

