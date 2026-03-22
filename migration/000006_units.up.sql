-- 000006_units.up.sql
-- Normalized unit master (enterprise maintainability)

BEGIN;

CREATE TABLE IF NOT EXISTS units (
    id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name       TEXT NOT NULL UNIQUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMENT ON TABLE units IS 'Master satuan (pcs, kg, dll.) untuk produk. Direferensi products.unit_id (FK fk_products_unit_id di 000007_products.up.sql).';

COMMENT ON COLUMN units.id IS 'Primary key satuan.';
COMMENT ON COLUMN units.name IS 'Nama satuan unik.';
COMMENT ON COLUMN units.created_at IS 'Waktu pembuatan.';
COMMENT ON COLUMN units.updated_at IS 'Waktu pembaruan terakhir.';

COMMIT;
