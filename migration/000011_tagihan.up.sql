-- 000011_tagihan.up.sql
-- Tagihan (piutang) header

BEGIN;

CREATE TABLE IF NOT EXISTS tagihan (
    id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    outlet_id      UUID NOT NULL REFERENCES outlets(id),
    customer_id    UUID REFERENCES customers(id),
    customer_name  TEXT NOT NULL,
    customer_phone TEXT,
    amount         BIGINT NOT NULL,
    amount_paid    BIGINT NOT NULL DEFAULT 0,
    due_date       DATE NOT NULL,
    status         tagihan_status NOT NULL DEFAULT 'UNPAID',
    created_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_tagihan_outlet_status ON tagihan(outlet_id, status);
CREATE INDEX IF NOT EXISTS idx_tagihan_outlet_due_date ON tagihan(outlet_id, due_date);

COMMIT;

