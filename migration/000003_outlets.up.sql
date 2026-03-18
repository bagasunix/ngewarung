-- 000003_outlets.up.sql
-- Outlets (toko/warung)

BEGIN;

CREATE TABLE IF NOT EXISTS outlets (
    id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    owner_id   UUID NOT NULL REFERENCES users(id),
    name       TEXT NOT NULL,
    address    TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    deleted_at TIMESTAMPTZ,
    is_deleted BOOLEAN NOT NULL DEFAULT FALSE,
    -- Pricing behavior for this outlet:
    -- 0=CUSTOM (store per-outlet price in product_variant_prices),
    -- 1=INHERIT_FROM_CENTRAL (read prices from the central price outlet)
    price_mode SMALLINT NOT NULL DEFAULT 0,
    -- Exactly one outlet per merchant should be marked as central price source
    is_price_central BOOLEAN NOT NULL DEFAULT FALSE,

    -- ==========================
    -- Readiness / operational monitoring
    -- ==========================
    -- Last time this outlet was observed active (login, cashier usage, etc.)
    last_activity_at       TIMESTAMPTZ,
    -- Last successful sync from the mobile app (offline-first -> server)
    last_sync_at            TIMESTAMPTZ,
    -- 0=unknown, 1=success, 2=failed
    last_sync_status       SMALLINT NOT NULL DEFAULT 0,
    -- Last sync error message/code (sanitized)
    last_sync_error        TEXT,
    -- Client metadata for debugging / readiness
    last_device_id         TEXT,
    last_app_version       TEXT,

    -- Onboarding readiness tracking
    -- 0=not started, 1=in progress, 2=activated/ready, (expand as needed)
    onboarding_stage       SMALLINT NOT NULL DEFAULT 0,
    onboarding_completed_at TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_outlets_owner_id ON outlets(owner_id);
CREATE INDEX IF NOT EXISTS idx_outlets_price_mode ON outlets(price_mode);
CREATE INDEX IF NOT EXISTS idx_outlets_is_price_central ON outlets(is_price_central);

COMMIT;

