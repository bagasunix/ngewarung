-- 000082_billing_subscriptions.up.sql
-- Merchant subscription + per-merchant feature overrides.

BEGIN;

CREATE TABLE IF NOT EXISTS merchant_subscriptions (
    id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    merchant_id           UUID NOT NULL REFERENCES merchants(id) ON DELETE CASCADE,
    plan_id               UUID NOT NULL REFERENCES billing_plans(id),
    plan_price_id         UUID REFERENCES billing_plan_prices(id),
    status                SMALLINT NOT NULL DEFAULT 1, -- 1=trialing, 2=active, 3=past_due, 4=cancelled, 5=expired
    auto_renew            BOOLEAN NOT NULL DEFAULT TRUE,
    started_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
    current_period_start  TIMESTAMPTZ NOT NULL DEFAULT now(),
    current_period_end    TIMESTAMPTZ NOT NULL,
    trial_start           TIMESTAMPTZ,
    trial_end             TIMESTAMPTZ,
    canceled_at           TIMESTAMPTZ,
    external_provider     TEXT, -- e.g. xendit, midtrans, stripe
    external_customer_id  TEXT,
    external_subscription_id TEXT,
    metadata_json         JSONB,
    created_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
    deleted_at            TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_merchant_subscriptions_merchant_id ON merchant_subscriptions(merchant_id);
CREATE INDEX IF NOT EXISTS idx_merchant_subscriptions_status ON merchant_subscriptions(status);
CREATE INDEX IF NOT EXISTS idx_merchant_subscriptions_period_end ON merchant_subscriptions(current_period_end);

-- Optional merchant-level override for plan features
CREATE TABLE IF NOT EXISTS merchant_feature_overrides (
    id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    merchant_id           UUID NOT NULL REFERENCES merchants(id) ON DELETE CASCADE,
    feature_key           TEXT NOT NULL,
    is_enabled_override   BOOLEAN,
    limit_override        BIGINT,
    reason                TEXT,
    metadata_json         JSONB,
    created_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
    deleted_at            TIMESTAMPTZ,
    UNIQUE (merchant_id, feature_key)
);

CREATE INDEX IF NOT EXISTS idx_merchant_feature_overrides_merchant_id ON merchant_feature_overrides(merchant_id);

COMMENT ON TABLE merchant_subscriptions IS 'Langganan aktif merchant ke billing_plans; periode, trial, ID provider pembayaran.';
COMMENT ON TABLE merchant_feature_overrides IS 'Override limit/fitur per merchant (promo/support) di atas plan.';

COMMENT ON COLUMN merchant_subscriptions.id IS 'Primary key langganan.';
COMMENT ON COLUMN merchant_subscriptions.merchant_id IS 'Tenant.';
COMMENT ON COLUMN merchant_subscriptions.plan_id IS 'Plan yang dipilih.';
COMMENT ON COLUMN merchant_subscriptions.plan_price_id IS 'Versi harga yang dipakai.';
COMMENT ON COLUMN merchant_subscriptions.status IS '1=trial; 2=aktif; 3=lewat jatuh tempo; 4=batal; 5=kadaluarsa.';
COMMENT ON COLUMN merchant_subscriptions.auto_renew IS 'Perpanjang otomatis.';
COMMENT ON COLUMN merchant_subscriptions.started_at IS 'Mulai langganan.';
COMMENT ON COLUMN merchant_subscriptions.current_period_start IS 'Awal periode berjalan.';
COMMENT ON COLUMN merchant_subscriptions.current_period_end IS 'Akhir periode berjalan.';
COMMENT ON COLUMN merchant_subscriptions.trial_start IS 'Mulai trial.';
COMMENT ON COLUMN merchant_subscriptions.trial_end IS 'Akhir trial.';
COMMENT ON COLUMN merchant_subscriptions.canceled_at IS 'Waktu pembatalan.';
COMMENT ON COLUMN merchant_subscriptions.external_provider IS 'Nama gateway (xendit, midtrans, ...).';
COMMENT ON COLUMN merchant_subscriptions.external_customer_id IS 'ID pelanggan di provider.';
COMMENT ON COLUMN merchant_subscriptions.external_subscription_id IS 'ID langganan di provider.';
COMMENT ON COLUMN merchant_subscriptions.metadata_json IS 'Metadata.';
COMMENT ON COLUMN merchant_subscriptions.created_at IS 'Waktu pembuatan.';
COMMENT ON COLUMN merchant_subscriptions.updated_at IS 'Waktu pembaruan.';
COMMENT ON COLUMN merchant_subscriptions.deleted_at IS 'Soft delete.';

COMMENT ON COLUMN merchant_feature_overrides.id IS 'Primary key override.';
COMMENT ON COLUMN merchant_feature_overrides.merchant_id IS 'Tenant.';
COMMENT ON COLUMN merchant_feature_overrides.feature_key IS 'Fitur yang dioverride.';
COMMENT ON COLUMN merchant_feature_overrides.is_enabled_override IS 'Override flag aktif/tidak.';
COMMENT ON COLUMN merchant_feature_overrides.limit_override IS 'Override batas numerik.';
COMMENT ON COLUMN merchant_feature_overrides.reason IS 'Alasan override.';
COMMENT ON COLUMN merchant_feature_overrides.metadata_json IS 'Metadata.';
COMMENT ON COLUMN merchant_feature_overrides.created_at IS 'Waktu pembuatan.';
COMMENT ON COLUMN merchant_feature_overrides.updated_at IS 'Waktu pembaruan.';
COMMENT ON COLUMN merchant_feature_overrides.deleted_at IS 'Soft delete.';

-- RLS: tenant scoped
ALTER TABLE merchant_subscriptions ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS merchant_subscriptions_by_merchant ON merchant_subscriptions;
CREATE POLICY merchant_subscriptions_by_merchant
ON merchant_subscriptions
FOR ALL
USING (merchant_id = app_current_merchant_id())
WITH CHECK (merchant_id = app_current_merchant_id());

ALTER TABLE merchant_feature_overrides ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS merchant_feature_overrides_by_merchant ON merchant_feature_overrides;
CREATE POLICY merchant_feature_overrides_by_merchant
ON merchant_feature_overrides
FOR ALL
USING (merchant_id = app_current_merchant_id())
WITH CHECK (merchant_id = app_current_merchant_id());

COMMIT;

