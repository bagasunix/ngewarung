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

COMMIT;

