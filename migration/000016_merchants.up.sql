-- 000016_merchants.up.sql
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

COMMIT;

