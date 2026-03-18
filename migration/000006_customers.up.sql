-- 000006_customers.up.sql
-- Customers (for tagihan + loyalty)

BEGIN;

CREATE TABLE IF NOT EXISTS customers (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    outlet_id           UUID NOT NULL REFERENCES outlets(id),
    phone               TEXT,
    name                TEXT,
    points_balance      BIGINT NOT NULL DEFAULT 0,
    last_transaction_at TIMESTAMPTZ,
    deleted_at          TIMESTAMPTZ,
    is_deleted          BOOLEAN NOT NULL DEFAULT FALSE,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (outlet_id, phone)
);

COMMIT;

