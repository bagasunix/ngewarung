-- 000021_units.up.sql
-- Normalized unit master (enterprise maintainability)

BEGIN;

CREATE TABLE IF NOT EXISTS units (
    id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name       TEXT NOT NULL UNIQUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMIT;

