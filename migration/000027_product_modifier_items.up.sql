-- 000027_product_modifier_items.up.sql
-- Map product -> modifier group (modifier availability for product)

BEGIN;

CREATE TABLE IF NOT EXISTS product_modifier_items (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id  UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    modifier_id UUID NOT NULL REFERENCES product_modifiers(id) ON DELETE CASCADE,
    UNIQUE (product_id, modifier_id)
);

COMMIT;

