-- 000067_merchant_configs.up.sql
-- Tenant configuration key-value store (per merchant)
-- Intended for managing JWT signing keys, 3rd-party secrets, and other integration params.

BEGIN;

CREATE TABLE IF NOT EXISTS merchant_configs (
    id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    merchant_id      UUID NOT NULL REFERENCES merchants(id) ON DELETE CASCADE,
    config_key       TEXT NOT NULL,
    -- For non-secret config, store JSON (preferred).
    value_json       JSONB,
    -- For secret config, store ciphertext bytes (encrypt/sign at application layer).
    value_encrypted  BYTEA,
    -- Optional: simple string config.
    value_text       TEXT,
    is_deleted       BOOLEAN NOT NULL DEFAULT FALSE,
    deleted_at       TIMESTAMPTZ,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT merchant_configs_value_kind_consistency CHECK (
        -- At least one value field should be set (or allow all null for deletion marker; app should handle this)
        (value_json IS NOT NULL)::int +
        (value_encrypted IS NOT NULL)::int +
        (value_text IS NOT NULL)::int >= 0
    )
);

-- One active config key per merchant (soft delete friendly)
CREATE UNIQUE INDEX IF NOT EXISTS uq_merchant_configs_active
ON merchant_configs(merchant_id, config_key)
WHERE is_deleted = FALSE;

CREATE INDEX IF NOT EXISTS idx_merchant_configs_merchant_id ON merchant_configs(merchant_id);
CREATE INDEX IF NOT EXISTS idx_merchant_configs_config_key ON merchant_configs(config_key);

COMMENT ON TABLE merchant_configs IS 'Konfigurasi key-value per tenant (secret/JSON/text): integrasi, JWT, webhook.';

COMMENT ON COLUMN merchant_configs.id IS 'Primary key baris config.';
COMMENT ON COLUMN merchant_configs.merchant_id IS 'Tenant pemilik.';
COMMENT ON COLUMN merchant_configs.config_key IS 'Kunci unik namespaced (lihat konvensi di dokumentasi RLS).';
COMMENT ON COLUMN merchant_configs.value_json IS 'Nilai non-rahasia (JSONB).';
COMMENT ON COLUMN merchant_configs.value_encrypted IS 'Nilai rahasia terenkripsi di aplikasi (BYTEA).';
COMMENT ON COLUMN merchant_configs.value_text IS 'Nilai string sederhana.';
COMMENT ON COLUMN merchant_configs.is_deleted IS 'Flag soft delete.';
COMMENT ON COLUMN merchant_configs.deleted_at IS 'Waktu soft delete.';
COMMENT ON COLUMN merchant_configs.created_at IS 'Waktu pembuatan.';
COMMENT ON COLUMN merchant_configs.updated_at IS 'Waktu pembaruan.';

COMMIT;

