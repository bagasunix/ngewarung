-- 000033_transaction_item_modifiers.up.sql
-- Selected modifiers/add-ons per transaction item

BEGIN;

CREATE TABLE IF NOT EXISTS transaction_item_modifiers (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    transaction_item_id UUID NOT NULL REFERENCES transaction_items(id) ON DELETE CASCADE,
    modifier_id         UUID NOT NULL REFERENCES product_modifiers(id) ON DELETE RESTRICT,
    price               BIGINT NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_transaction_item_modifiers_tx_item_id
  ON transaction_item_modifiers(transaction_item_id);

COMMIT;

