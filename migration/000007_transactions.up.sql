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

COMMIT;

