-- 000005_products.up.sql
-- Products (catalog + stock + expiry)

BEGIN;

CREATE TABLE IF NOT EXISTS products (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    outlet_id   UUID NOT NULL REFERENCES outlets(id),
    category_id UUID REFERENCES categories(id),
    name        TEXT NOT NULL,
    sku         TEXT,
    price       BIGINT NOT NULL,
    unit        TEXT NOT NULL DEFAULT 'pcs',
    stock       INTEGER NOT NULL DEFAULT 0,
    expiry_date DATE,
    is_deleted  BOOLEAN NOT NULL DEFAULT FALSE,
    deleted_at  TIMESTAMPTZ,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_products_outlet_id ON products(outlet_id);
CREATE INDEX IF NOT EXISTS idx_products_category_id ON products(category_id);
CREATE INDEX IF NOT EXISTS idx_products_outlet_name ON products(outlet_id, name);

COMMIT;

