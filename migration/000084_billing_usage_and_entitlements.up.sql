-- 000084_billing_usage_and_entitlements.up.sql
-- Usage metering and cached entitlements for fast authorization checks.

BEGIN;

CREATE TABLE IF NOT EXISTS billing_usage_daily (
    id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    merchant_id           UUID NOT NULL REFERENCES merchants(id) ON DELETE CASCADE,
    outlet_id             UUID REFERENCES outlets(id) ON DELETE SET NULL,
    feature_key           TEXT NOT NULL,   -- e.g. outlet_count, wa_message_sent
    usage_date            DATE NOT NULL,
    used_count            BIGINT NOT NULL DEFAULT 0,
    limit_snapshot        BIGINT,
    overage_count         BIGINT NOT NULL DEFAULT 0,
    metadata_json         JSONB,
    created_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
    deleted_at            TIMESTAMPTZ,
    UNIQUE (merchant_id, outlet_id, feature_key, usage_date)
);

CREATE INDEX IF NOT EXISTS idx_billing_usage_daily_merchant_date
  ON billing_usage_daily(merchant_id, usage_date);
CREATE INDEX IF NOT EXISTS idx_billing_usage_daily_feature
  ON billing_usage_daily(feature_key);

-- Cached effective entitlements after plan + override resolution
CREATE TABLE IF NOT EXISTS merchant_entitlements (
    id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    merchant_id           UUID NOT NULL REFERENCES merchants(id) ON DELETE CASCADE,
    feature_key           TEXT NOT NULL,
    is_enabled            BOOLEAN NOT NULL DEFAULT FALSE,
    limit_value           BIGINT,
    source                TEXT NOT NULL DEFAULT 'plan', -- plan / override / manual
    effective_from        TIMESTAMPTZ NOT NULL DEFAULT now(),
    effective_to          TIMESTAMPTZ,
    metadata_json         JSONB,
    created_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
    deleted_at            TIMESTAMPTZ,
    UNIQUE (merchant_id, feature_key, effective_from)
);

CREATE INDEX IF NOT EXISTS idx_merchant_entitlements_merchant_feature
  ON merchant_entitlements(merchant_id, feature_key);
CREATE INDEX IF NOT EXISTS idx_merchant_entitlements_effective
  ON merchant_entitlements(effective_from, effective_to);

-- RLS: tenant scoped
ALTER TABLE billing_usage_daily ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS billing_usage_daily_by_merchant ON billing_usage_daily;
CREATE POLICY billing_usage_daily_by_merchant
ON billing_usage_daily
FOR ALL
USING (merchant_id = app_current_merchant_id())
WITH CHECK (merchant_id = app_current_merchant_id());

ALTER TABLE merchant_entitlements ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS merchant_entitlements_by_merchant ON merchant_entitlements;
CREATE POLICY merchant_entitlements_by_merchant
ON merchant_entitlements
FOR ALL
USING (merchant_id = app_current_merchant_id())
WITH CHECK (merchant_id = app_current_merchant_id());

COMMIT;

