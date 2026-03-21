-- 000027_product_modifier_items.up.sql
-- Map product -> modifier group (modifier availability for product)

BEGIN;

CREATE TABLE IF NOT EXISTS product_modifier_items (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id  UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    modifier_id UUID NOT NULL REFERENCES product_modifiers(id) ON DELETE CASCADE,
    UNIQUE (product_id, modifier_id)
);

COMMENT ON TABLE product_modifier_items IS 'Produk mana saja yang boleh memakai modifier tertentu.';

COMMENT ON COLUMN product_modifier_items.id IS 'Primary key mapping.';
COMMENT ON COLUMN product_modifier_items.product_id IS 'Produk.';
COMMENT ON COLUMN product_modifier_items.modifier_id IS 'Modifier yang tersedia untuk produk ini.';

COMMIT;

