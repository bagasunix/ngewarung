-- 000023_product_variants.up.sql
-- Variants per product (sizes/packaging/etc.)

BEGIN;

CREATE TABLE IF NOT EXISTS product_variants (
    id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    name       TEXT NOT NULL,
    sku        TEXT,
    deleted_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_product_variants_product_id ON product_variants(product_id);

COMMENT ON TABLE product_variants IS 'Varian SKU per produk (ukuran/kemasan); harga per outlet di product_variant_prices.';

COMMENT ON COLUMN product_variants.id IS 'Primary key varian.';
COMMENT ON COLUMN product_variants.product_id IS 'Produk induk.';
COMMENT ON COLUMN product_variants.name IS 'Nama varian (mis. 250ml).';
COMMENT ON COLUMN product_variants.sku IS 'SKU varian opsional.';
COMMENT ON COLUMN product_variants.deleted_at IS 'Soft delete.';
COMMENT ON COLUMN product_variants.created_at IS 'Waktu pembuatan.';
COMMENT ON COLUMN product_variants.updated_at IS 'Waktu pembaruan.';

COMMIT;

