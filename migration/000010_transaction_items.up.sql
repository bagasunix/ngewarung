-- 000010_transaction_items.up.sql
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

COMMENT ON TABLE transaction_items IS 'Baris item dalam transaksi: produk, qty, harga, subtotal.';

COMMENT ON COLUMN transaction_items.id IS 'Primary key baris item.';
COMMENT ON COLUMN transaction_items.transaction_id IS 'Header transaksi induk.';
COMMENT ON COLUMN transaction_items.product_id IS 'Produk yang dijual.';
COMMENT ON COLUMN transaction_items.quantity IS 'Jumlah unit.';
COMMENT ON COLUMN transaction_items.unit_price IS 'Harga satuan saat transaksi.';
COMMENT ON COLUMN transaction_items.subtotal IS 'Jumlah baris setelah diskon/pajak baris (nilai akhir).';

COMMIT;

