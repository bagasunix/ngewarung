-- 000014_tagihan_payments.up.sql
-- Tagihan payment records

BEGIN;

CREATE TABLE IF NOT EXISTS tagihan_payments (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tagihan_id  UUID NOT NULL REFERENCES tagihan(id) ON DELETE CASCADE,
    amount      BIGINT NOT NULL,
    paid_at     TIMESTAMPTZ NOT NULL,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (tagihan_id, amount, paid_at)
);

CREATE INDEX IF NOT EXISTS idx_tagihan_payments_tagihan_id ON tagihan_payments(tagihan_id);

COMMENT ON TABLE tagihan_payments IS 'Pembayaran/cicilan untuk tagihan piutang.';

COMMENT ON COLUMN tagihan_payments.id IS 'Primary key pembayaran piutang.';
COMMENT ON COLUMN tagihan_payments.tagihan_id IS 'Header tagihan yang dilunasi.';
COMMENT ON COLUMN tagihan_payments.amount IS 'Nilai cicilan ini.';
COMMENT ON COLUMN tagihan_payments.paid_at IS 'Waktu pembayaran diterima.';
COMMENT ON COLUMN tagihan_payments.created_at IS 'Waktu rekaman.';

COMMIT;

