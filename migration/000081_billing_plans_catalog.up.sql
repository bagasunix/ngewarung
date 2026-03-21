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

COMMENT ON TABLE billing_plans IS 'Katalog global paket langganan (FREE/PRO/ENTERPRISE); bukan data per tenant.';
COMMENT ON TABLE billing_plan_prices IS 'Harga per mata uang dan interval (bulanan/tahunan) untuk suatu billing_plans.';
COMMENT ON TABLE billing_plan_features IS 'Fitur dan limit per plan (feature_key, limit_value, is_enabled).';

COMMENT ON COLUMN billing_plans.id IS 'Primary key plan.';
COMMENT ON COLUMN billing_plans.code IS 'Kode unik paket (FREE, PRO, ...).';
COMMENT ON COLUMN billing_plans.name IS 'Nama tampilan.';
COMMENT ON COLUMN billing_plans.description IS 'Deskripsi pemasaran.';
COMMENT ON COLUMN billing_plans.is_active IS 'Plan masih dijual.';
COMMENT ON COLUMN billing_plans.trial_days IS 'Durasi trial dalam hari.';
COMMENT ON COLUMN billing_plans.sort_order IS 'Urutan tampilan.';
COMMENT ON COLUMN billing_plans.metadata_json IS 'Metadata tambahan.';
COMMENT ON COLUMN billing_plans.created_at IS 'Waktu pembuatan.';
COMMENT ON COLUMN billing_plans.updated_at IS 'Waktu pembaruan.';
COMMENT ON COLUMN billing_plans.deleted_at IS 'Soft delete.';

COMMENT ON COLUMN billing_plan_prices.id IS 'Primary key harga.';
COMMENT ON COLUMN billing_plan_prices.plan_id IS 'Plan terkait.';
COMMENT ON COLUMN billing_plan_prices.currency IS 'Kode ISO mata uang.';
COMMENT ON COLUMN billing_plan_prices.billing_interval IS '1=bulanan; 2=tahunan.';
COMMENT ON COLUMN billing_plan_prices.amount IS 'Harga (satuan terkecil).';
COMMENT ON COLUMN billing_plan_prices.is_active IS 'Versi harga masih berlaku.';
COMMENT ON COLUMN billing_plan_prices.effective_from IS 'Mulai berlaku.';
COMMENT ON COLUMN billing_plan_prices.effective_to IS 'Akhir berlaku (NULL=tanpa batas).';
COMMENT ON COLUMN billing_plan_prices.created_at IS 'Waktu pembuatan.';
COMMENT ON COLUMN billing_plan_prices.updated_at IS 'Waktu pembaruan.';
COMMENT ON COLUMN billing_plan_prices.deleted_at IS 'Soft delete.';

COMMENT ON COLUMN billing_plan_features.id IS 'Primary key fitur plan.';
COMMENT ON COLUMN billing_plan_features.plan_id IS 'Plan.';
COMMENT ON COLUMN billing_plan_features.feature_key IS 'Kunci fitur (mis. outlet_count).';
COMMENT ON COLUMN billing_plan_features.is_enabled IS 'Fitur aktif di plan.';
COMMENT ON COLUMN billing_plan_features.limit_value IS 'Batas numerik (NULL=tak terbatas/tidak dipakai).';
COMMENT ON COLUMN billing_plan_features.metadata_json IS 'Metadata.';
COMMENT ON COLUMN billing_plan_features.created_at IS 'Waktu pembuatan.';
COMMENT ON COLUMN billing_plan_features.updated_at IS 'Waktu pembaruan.';
COMMENT ON COLUMN billing_plan_features.deleted_at IS 'Soft delete.';

COMMIT;

