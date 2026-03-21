-- 000024_product_variant_prices.up.sql
-- Price per variant per outlet

BEGIN;

CREATE TABLE IF NOT EXISTS product_variant_prices (
    id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    variant_id UUID NOT NULL REFERENCES product_variants(id) ON DELETE CASCADE,
    outlet_id  UUID NOT NULL REFERENCES outlets(id) ON DELETE CASCADE,
    price      BIGINT NOT NULL, -- rupiah, smallest unit
    deleted_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (variant_id, outlet_id)
);

COMMENT ON TABLE product_variant_prices IS 'Harga jual per varian per outlet (satuan terkecil mata uang); mendukung cabang custom vs ikut pusat.';

COMMENT ON COLUMN product_variant_prices.id IS 'Primary key baris harga.';
COMMENT ON COLUMN product_variant_prices.variant_id IS 'Varian produk.';
COMMENT ON COLUMN product_variant_prices.outlet_id IS 'Cabang yang berlaku harga ini.';
COMMENT ON COLUMN product_variant_prices.price IS 'Harga jual (satuan terkecil mata uang).';
COMMENT ON COLUMN product_variant_prices.deleted_at IS 'Soft delete.';
COMMENT ON COLUMN product_variant_prices.created_at IS 'Waktu pembuatan.';
COMMENT ON COLUMN product_variant_prices.updated_at IS 'Waktu pembaruan.';

COMMIT;

