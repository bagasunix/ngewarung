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

COMMIT;

