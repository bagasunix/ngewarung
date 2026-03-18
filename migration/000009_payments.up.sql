-- 000009_payments.up.sql
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

COMMIT;

