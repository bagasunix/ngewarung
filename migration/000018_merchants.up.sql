-- 000018_merchants.up.sql
-- Enterprise tenant: merchants

BEGIN;

CREATE TABLE IF NOT EXISTS merchants (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name        TEXT NOT NULL,
    email       TEXT UNIQUE,
    phone       TEXT,
    address     TEXT,
    merchant_status SMALLINT NOT NULL DEFAULT 1, -- 1=active, 2=suspended
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    deleted_at  TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_merchants_status ON merchants(merchant_status);

COMMENT ON TABLE merchants IS 'Tenant/induk bisnis (enterprise multi-tenant); status aktif/suspend.';

COMMENT ON COLUMN merchants.id IS 'Primary key tenant.';
COMMENT ON COLUMN merchants.name IS 'Nama bisnis.';
COMMENT ON COLUMN merchants.email IS 'Email kontak unik.';
COMMENT ON COLUMN merchants.phone IS 'Telepon kontak.';
COMMENT ON COLUMN merchants.address IS 'Alamat.';
COMMENT ON COLUMN merchants.merchant_status IS '1=aktif; 2=suspend.';
COMMENT ON COLUMN merchants.created_at IS 'Waktu pembuatan.';
COMMENT ON COLUMN merchants.updated_at IS 'Waktu pembaruan.';
COMMENT ON COLUMN merchants.deleted_at IS 'Soft delete opsional.';

COMMIT;

