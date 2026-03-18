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

COMMIT;

