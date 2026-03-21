-- 000026_product_modifiers.up.sql
-- Modifier group (e.g. topping/add-on) with its own price

BEGIN;

CREATE TABLE IF NOT EXISTS product_modifiers (
    id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    merchant_id UUID NOT NULL REFERENCES merchants(id) ON DELETE CASCADE,
    name       TEXT NOT NULL,
    price      BIGINT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    deleted_at TIMESTAMPTZ,
    is_deleted BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE INDEX IF NOT EXISTS idx_product_modifiers_merchant_id ON product_modifiers(merchant_id);

COMMENT ON TABLE product_modifiers IS 'Grup modifier/add-on per tenant (topping, ekstra) dengan harga.';

COMMENT ON COLUMN product_modifiers.id IS 'Primary key modifier.';
COMMENT ON COLUMN product_modifiers.merchant_id IS 'Tenant pemilik definisi modifier.';
COMMENT ON COLUMN product_modifiers.name IS 'Nama grup modifier.';
COMMENT ON COLUMN product_modifiers.price IS 'Harga tambahan default.';
COMMENT ON COLUMN product_modifiers.created_at IS 'Waktu pembuatan.';
COMMENT ON COLUMN product_modifiers.updated_at IS 'Waktu pembaruan.';
COMMENT ON COLUMN product_modifiers.deleted_at IS 'Soft delete.';
COMMENT ON COLUMN product_modifiers.is_deleted IS 'Flag soft delete.';

COMMIT;

