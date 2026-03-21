-- 000004_categories.up.sql
-- Categories per outlet

BEGIN;

CREATE TABLE IF NOT EXISTS categories (
    id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    outlet_id  UUID NOT NULL REFERENCES outlets(id),
    name       TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    deleted_at TIMESTAMPTZ,
    is_deleted BOOLEAN NOT NULL DEFAULT FALSE,
    UNIQUE (outlet_id, name)
);

COMMENT ON TABLE categories IS 'Kategori produk per outlet (soft delete).';

COMMENT ON COLUMN categories.id IS 'Primary key kategori.';
COMMENT ON COLUMN categories.outlet_id IS 'Cabang pemilik kategori.';
COMMENT ON COLUMN categories.name IS 'Nama kategori (unik per outlet).';
COMMENT ON COLUMN categories.created_at IS 'Waktu pembuatan.';
COMMENT ON COLUMN categories.updated_at IS 'Waktu pembaruan terakhir.';
COMMENT ON COLUMN categories.deleted_at IS 'Soft delete: waktu penghapusan logis.';
COMMENT ON COLUMN categories.is_deleted IS 'Flag soft delete.';

COMMIT;

