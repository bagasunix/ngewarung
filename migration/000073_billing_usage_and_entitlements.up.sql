-- 000073_billing_usage_and_entitlements.up.sql
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

COMMENT ON TABLE billing_usage_daily IS 'Agregat pemakaian harian per fitur (metering) untuk limit/overage.';
COMMENT ON TABLE merchant_entitlements IS 'Cache hak fitur efektif per merchant (gate API cepat) dari plan + override.';

COMMENT ON COLUMN billing_usage_daily.id IS 'Primary key agregat.';
COMMENT ON COLUMN billing_usage_daily.merchant_id IS 'Tenant.';
COMMENT ON COLUMN billing_usage_daily.outlet_id IS 'Cabang jika usage per outlet.';
COMMENT ON COLUMN billing_usage_daily.feature_key IS 'Kunci fitur yang diukur.';
COMMENT ON COLUMN billing_usage_daily.usage_date IS 'Tanggal agregat.';
COMMENT ON COLUMN billing_usage_daily.used_count IS 'Jumlah terpakai.';
COMMENT ON COLUMN billing_usage_daily.limit_snapshot IS 'Salinan limit saat agregat.';
COMMENT ON COLUMN billing_usage_daily.overage_count IS 'Kelebihan di luar limit.';
COMMENT ON COLUMN billing_usage_daily.metadata_json IS 'Metadata.';
COMMENT ON COLUMN billing_usage_daily.created_at IS 'Waktu pembuatan.';
COMMENT ON COLUMN billing_usage_daily.updated_at IS 'Waktu pembaruan.';
COMMENT ON COLUMN billing_usage_daily.deleted_at IS 'Soft delete.';

COMMENT ON COLUMN merchant_entitlements.id IS 'Primary key entitlement.';
COMMENT ON COLUMN merchant_entitlements.merchant_id IS 'Tenant.';
COMMENT ON COLUMN merchant_entitlements.feature_key IS 'Fitur.';
COMMENT ON COLUMN merchant_entitlements.is_enabled IS 'Fitur diizinkan.';
COMMENT ON COLUMN merchant_entitlements.limit_value IS 'Batas (NULL=tak terbatas).';
COMMENT ON COLUMN merchant_entitlements.source IS 'Sumber: plan, override, manual.';
COMMENT ON COLUMN merchant_entitlements.effective_from IS 'Mulai berlaku.';
COMMENT ON COLUMN merchant_entitlements.effective_to IS 'Akhir berlaku.';
COMMENT ON COLUMN merchant_entitlements.metadata_json IS 'Metadata.';
COMMENT ON COLUMN merchant_entitlements.created_at IS 'Waktu pembuatan.';
COMMENT ON COLUMN merchant_entitlements.updated_at IS 'Waktu pembaruan.';
COMMENT ON COLUMN merchant_entitlements.deleted_at IS 'Soft delete.';

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

