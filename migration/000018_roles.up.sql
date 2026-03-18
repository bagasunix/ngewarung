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

COMMIT;

