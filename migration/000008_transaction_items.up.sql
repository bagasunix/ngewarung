-- 000008_transaction_items.up.sql
-- Transaction line items

BEGIN;

CREATE TABLE IF NOT EXISTS transaction_items (
    id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    transaction_id UUID NOT NULL REFERENCES transactions(id) ON DELETE CASCADE,
    product_id     UUID NOT NULL REFERENCES products(id),
    quantity       INTEGER NOT NULL,
    unit_price     BIGINT NOT NULL,
    subtotal       BIGINT NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_tx_items_tx_id ON transaction_items(transaction_id);
CREATE INDEX IF NOT EXISTS idx_tx_items_product_id ON transaction_items(product_id);

COMMIT;

