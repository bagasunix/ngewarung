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

COMMENT ON TABLE transaction_item_modifiers IS 'Modifier yang dipilih pada baris transaksi beserta harga.';

COMMENT ON COLUMN transaction_item_modifiers.id IS 'Primary key modifier terpilih.';
COMMENT ON COLUMN transaction_item_modifiers.transaction_item_id IS 'Baris transaksi.';
COMMENT ON COLUMN transaction_item_modifiers.modifier_id IS 'Definisi modifier.';
COMMENT ON COLUMN transaction_item_modifiers.price IS 'Harga modifier pada saat jual.';

COMMIT;

