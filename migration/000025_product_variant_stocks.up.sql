-- 000025_product_variant_stocks.up.sql
-- Stock per variant per outlet

BEGIN;

CREATE TABLE IF NOT EXISTS product_variant_stocks (
    id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    variant_id UUID NOT NULL REFERENCES product_variants(id) ON DELETE CASCADE,
    outlet_id  UUID NOT NULL REFERENCES outlets(id) ON DELETE CASCADE,
    quantity   INTEGER NOT NULL DEFAULT 0,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    deleted_at TIMESTAMPTZ,
    UNIQUE (variant_id, outlet_id)
);

CREATE INDEX IF NOT EXISTS idx_product_variant_stocks_variant_id ON product_variant_stocks(variant_id);
CREATE INDEX IF NOT EXISTS idx_product_variant_stocks_outlet_id ON product_variant_stocks(outlet_id);

COMMENT ON TABLE product_variant_stocks IS 'Stok per varian per outlet.';

COMMENT ON COLUMN product_variant_stocks.id IS 'Primary key stok varian.';
COMMENT ON COLUMN product_variant_stocks.variant_id IS 'Varian.';
COMMENT ON COLUMN product_variant_stocks.outlet_id IS 'Cabang.';
COMMENT ON COLUMN product_variant_stocks.quantity IS 'Jumlah stok.';
COMMENT ON COLUMN product_variant_stocks.updated_at IS 'Waktu pembaruan stok.';
COMMENT ON COLUMN product_variant_stocks.deleted_at IS 'Soft delete.';

COMMIT;

