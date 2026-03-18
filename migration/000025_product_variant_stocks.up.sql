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

COMMIT;

