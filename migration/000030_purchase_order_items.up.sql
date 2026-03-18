-- 000030_purchase_order_items.up.sql
-- Purchase order items (variant + qty + price)

BEGIN;

CREATE TABLE IF NOT EXISTS purchase_order_items (
    id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    purchase_order_id UUID NOT NULL REFERENCES purchase_orders(id) ON DELETE CASCADE,
    variant_id         UUID NOT NULL REFERENCES product_variants(id) ON DELETE CASCADE,
    quantity           INTEGER NOT NULL,
    price              BIGINT NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_purchase_order_items_order_id ON purchase_order_items(purchase_order_id);
CREATE INDEX IF NOT EXISTS idx_purchase_order_items_variant_id ON purchase_order_items(variant_id);

COMMIT;

