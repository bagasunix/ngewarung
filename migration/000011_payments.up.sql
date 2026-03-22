-- 000011_payments.up.sql
-- Payments per transaction (cash / QRIS)

BEGIN;

CREATE TABLE IF NOT EXISTS payments (
    id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    transaction_id UUID NOT NULL REFERENCES transactions(id) ON DELETE CASCADE,
    method         payment_method NOT NULL,
    amount         BIGINT NOT NULL,
    external_ref   TEXT,
    created_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_payments_tx_id ON payments(transaction_id);

COMMENT ON TABLE payments IS 'Pembayaran per transaksi (tunai, QRIS, dll.) dengan referensi eksternal opsional.';

COMMENT ON COLUMN payments.id IS 'Primary key pembayaran.';
COMMENT ON COLUMN payments.transaction_id IS 'Transaksi yang dibayar.';
COMMENT ON COLUMN payments.method IS 'Metode bayar (enum payment_method).';
COMMENT ON COLUMN payments.amount IS 'Nilai dibayar (satuan terkecil).';
COMMENT ON COLUMN payments.external_ref IS 'Referensi gateway/pembayaran pihak ketiga.';
COMMENT ON COLUMN payments.created_at IS 'Waktu catat pembayaran.';

COMMIT;

