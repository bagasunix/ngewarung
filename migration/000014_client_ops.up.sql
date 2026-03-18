-- 000014_client_ops.up.sql
-- Client operations for offline sync idempotency

BEGIN;

CREATE TABLE IF NOT EXISTS client_ops (
    op_id        UUID PRIMARY KEY,
    outlet_id    UUID NOT NULL REFERENCES outlets(id),
    op_type      TEXT NOT NULL,
    result       JSONB NOT NULL,
    first_seen_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMIT;

