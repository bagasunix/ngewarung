-- 000081_billing_plans_catalog.up.sql
-- Global billing catalog: plans, plan prices, plan features.

BEGIN;

-- Global plan catalog (not tenant-scoped)
CREATE TABLE IF NOT EXISTS billing_plans (
    id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code              TEXT NOT NULL UNIQUE, -- e.g. FREE, PRO, ENTERPRISE
    name              TEXT NOT NULL,
    description       TEXT,
    is_active         BOOLEAN NOT NULL DEFAULT TRUE,
    trial_days        INT NOT NULL DEFAULT 0,
    sort_order        INT NOT NULL DEFAULT 0,
    metadata_json     JSONB,
    created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
    deleted_at        TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_billing_plans_active ON billing_plans(is_active);

-- Price versions for each plan (global)
CREATE TABLE IF NOT EXISTS billing_plan_prices (
    id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    plan_id           UUID NOT NULL REFERENCES billing_plans(id) ON DELETE CASCADE,
    currency          VARCHAR(3) NOT NULL DEFAULT 'IDR',
    billing_interval  SMALLINT NOT NULL, -- 1=monthly, 2=yearly
    amount            BIGINT NOT NULL,    -- smallest unit
    is_active         BOOLEAN NOT NULL DEFAULT TRUE,
    effective_from    TIMESTAMPTZ NOT NULL DEFAULT now(),
    effective_to      TIMESTAMPTZ,
    created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
    deleted_at        TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_billing_plan_prices_plan_id ON billing_plan_prices(plan_id);
CREATE INDEX IF NOT EXISTS idx_billing_plan_prices_active ON billing_plan_prices(is_active);

-- Features and limits bundled in a plan
CREATE TABLE IF NOT EXISTS billing_plan_features (
    id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    plan_id           UUID NOT NULL REFERENCES billing_plans(id) ON DELETE CASCADE,
    feature_key       TEXT NOT NULL,      -- e.g. multi_outlet, wa_automation, audit_log_export
    is_enabled        BOOLEAN NOT NULL DEFAULT TRUE,
    limit_value       BIGINT,             -- nullable for unlimited / not applicable
    metadata_json     JSONB,
    created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
    deleted_at        TIMESTAMPTZ,
    UNIQUE (plan_id, feature_key)
);

CREATE INDEX IF NOT EXISTS idx_billing_plan_features_plan_id ON billing_plan_features(plan_id);
CREATE INDEX IF NOT EXISTS idx_billing_plan_features_key ON billing_plan_features(feature_key);

COMMIT;

