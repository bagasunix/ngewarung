-- 000018_roles.up.sql
-- Role-based governance (enterprise)

BEGIN;

CREATE TABLE IF NOT EXISTS roles (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    merchant_id UUID REFERENCES merchants(id) ON DELETE CASCADE, -- NULL = global role
    name        TEXT NOT NULL,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    deleted_at  TIMESTAMPTZ,
    is_deleted  BOOLEAN NOT NULL DEFAULT FALSE,
    UNIQUE (merchant_id, name)
);

COMMENT ON TABLE roles IS 'Peran RBAC per merchant (merchant_id NULL = peran global opsional).';

COMMENT ON COLUMN roles.id IS 'Primary key peran.';
COMMENT ON COLUMN roles.merchant_id IS 'Tenant pemilik peran; NULL jika peran global.';
COMMENT ON COLUMN roles.name IS 'Nama peran (unik per merchant).';
COMMENT ON COLUMN roles.created_at IS 'Waktu pembuatan.';
COMMENT ON COLUMN roles.updated_at IS 'Waktu pembaruan.';
COMMENT ON COLUMN roles.deleted_at IS 'Soft delete.';
COMMENT ON COLUMN roles.is_deleted IS 'Flag soft delete.';

COMMIT;

