-- 000010_expenses.up.sql
-- Business expenses

BEGIN;

CREATE TABLE IF NOT EXISTS expenses (
    id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    outlet_id  UUID NOT NULL REFERENCES outlets(id),
    amount     BIGINT NOT NULL,
    note       TEXT,
    date       DATE NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_expenses_outlet_date ON expenses(outlet_id, date);

COMMIT;

