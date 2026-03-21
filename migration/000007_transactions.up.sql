-- 000007_transactions.up.sql
-- Sales transactions (header)

BEGIN;

CREATE TABLE IF NOT EXISTS transactions (
    id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    outlet_id    UUID NOT NULL REFERENCES outlets(id),
    cashier_id   UUID REFERENCES users(id),
    customer_id  UUID REFERENCES customers(id),
    total        BIGINT NOT NULL,
    discount     BIGINT NOT NULL DEFAULT 0,
    status       transaction_status NOT NULL DEFAULT 'COMPLETED',
    occurred_at  TIMESTAMPTZ NOT NULL,
    created_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_transactions_outlet_occurred_at
    ON transactions(outlet_id, occurred_at);

COMMENT ON TABLE transactions IS 'Header penjualan POS: outlet, kasir, pelanggan, total, status, waktu.';

COMMENT ON COLUMN transactions.id IS 'Primary key transaksi.';
COMMENT ON COLUMN transactions.outlet_id IS 'Cabang tempat transaksi terjadi.';
COMMENT ON COLUMN transactions.cashier_id IS 'User kasir yang melayani.';
COMMENT ON COLUMN transactions.customer_id IS 'Pelanggan opsional.';
COMMENT ON COLUMN transactions.total IS 'Total nilai transaksi (satuan terkecil).';
COMMENT ON COLUMN transactions.discount IS 'Diskon total header.';
COMMENT ON COLUMN transactions.status IS 'Status transaksi (enum transaction_status).';
COMMENT ON COLUMN transactions.occurred_at IS 'Waktu kejadian bisnis (bukan hanya created_at).';
COMMENT ON COLUMN transactions.created_at IS 'Waktu rekaman masuk sistem.';

COMMIT;

