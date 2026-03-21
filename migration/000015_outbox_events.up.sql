-- 000015_outbox_events.up.sql
-- Outbox events table for event bus pattern

BEGIN;

CREATE TABLE IF NOT EXISTS outbox_events (
    id           BIGSERIAL PRIMARY KEY,
    aggregate_id UUID,
    event_type   TEXT NOT NULL,
    payload      JSONB NOT NULL,
    created_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
    published_at TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_outbox_events_published_at
    ON outbox_events(published_at) WHERE published_at IS NULL;

COMMENT ON TABLE outbox_events IS 'Outbox event bus (payload JSON). Komentar final setelah RLS/merchant_id di migrasi 000063.';

COMMENT ON COLUMN outbox_events.id IS 'Primary key bigserial.';
COMMENT ON COLUMN outbox_events.aggregate_id IS 'ID agregat domain terkait (opsional).';
COMMENT ON COLUMN outbox_events.event_type IS 'Nama tipe event.';
COMMENT ON COLUMN outbox_events.payload IS 'Muatan event (JSONB).';
COMMENT ON COLUMN outbox_events.created_at IS 'Waktu event ditulis ke outbox.';
COMMENT ON COLUMN outbox_events.published_at IS 'Waktu worker selesai publish (NULL jika belum).';

COMMIT;

