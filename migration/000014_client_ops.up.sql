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

COMMENT ON TABLE client_ops IS 'Idempotensi operasi dari klien (offline sync): op_id unik per outlet.';

COMMENT ON COLUMN client_ops.op_id IS 'ID unik operasi dari klien (deduplikasi retry).';
COMMENT ON COLUMN client_ops.outlet_id IS 'Cabang konteks op.';
COMMENT ON COLUMN client_ops.op_type IS 'Jenis operasi (string).';
COMMENT ON COLUMN client_ops.result IS 'Hasil terapan di server (JSON).';
COMMENT ON COLUMN client_ops.first_seen_at IS 'Pertama kali op diterima.';

COMMIT;

