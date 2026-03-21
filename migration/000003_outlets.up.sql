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

COMMENT ON TABLE outlets IS 'Cabang/toko/warung; termasuk mode harga (custom vs ikut pusat), readiness sync, dan onboarding.';

COMMENT ON COLUMN outlets.id IS 'Primary key outlet/cabang.';
COMMENT ON COLUMN outlets.owner_id IS 'User pemilik rekaman (legacy); otorisasi via RBAC.';
COMMENT ON COLUMN outlets.name IS 'Nama toko/cabang.';
COMMENT ON COLUMN outlets.address IS 'Alamat teks bebas.';
COMMENT ON COLUMN outlets.created_at IS 'Waktu pembuatan.';
COMMENT ON COLUMN outlets.updated_at IS 'Waktu pembaruan terakhir.';
COMMENT ON COLUMN outlets.deleted_at IS 'Soft delete: waktu penghapusan logis.';
COMMENT ON COLUMN outlets.is_deleted IS 'Flag soft delete.';
COMMENT ON COLUMN outlets.price_mode IS '0=CUSTOM harga per outlet; 1=INHERIT harga dari outlet pusat.';
COMMENT ON COLUMN outlets.is_price_central IS 'True jika outlet ini sumber harga pusat (maks satu per merchant).';
COMMENT ON COLUMN outlets.last_activity_at IS 'Terakhir aktivitas kasir/login terpantau.';
COMMENT ON COLUMN outlets.last_sync_at IS 'Terakhir sinkronisasi offline ke server berhasil.';
COMMENT ON COLUMN outlets.last_sync_status IS '0=tidak diketahui; 1=sukses; 2=gagal.';
COMMENT ON COLUMN outlets.last_sync_error IS 'Pesan error sync (disanitasi).';
COMMENT ON COLUMN outlets.last_device_id IS 'ID perangkat klien terakhir.';
COMMENT ON COLUMN outlets.last_app_version IS 'Versi aplikasi klien terakhir.';
COMMENT ON COLUMN outlets.onboarding_stage IS 'Tahap onboarding: 0=belum; 1=proses; 2=aktif.';
COMMENT ON COLUMN outlets.onboarding_completed_at IS 'Waktu onboarding selesai jika ada.';

COMMIT;

