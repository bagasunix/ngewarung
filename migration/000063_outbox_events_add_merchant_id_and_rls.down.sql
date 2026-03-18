-- 000063_outbox_events_add_merchant_id_and_rls.down.sql

BEGIN;

ALTER TABLE outbox_events DISABLE ROW LEVEL SECURITY;

ALTER TABLE outbox_events
  DROP COLUMN IF EXISTS merchant_id;

-- Index may remain; dropping column drops dependent indexes in most cases.

COMMIT;

