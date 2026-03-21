-- 000063_outbox_events_add_merchant_id_and_rls.up.sql
-- Make outbox_events tenant-aware via merchant_id and enable RLS.

BEGIN;

ALTER TABLE outbox_events
  ADD COLUMN IF NOT EXISTS merchant_id UUID;

CREATE INDEX IF NOT EXISTS idx_outbox_events_merchant_id
  ON outbox_events(merchant_id);

COMMENT ON TABLE outbox_events IS 'Outbox untuk event bus: payload JSON, merchant_id untuk RLS tenant, published_at saat selesai dipublikasikan.';

COMMENT ON COLUMN outbox_events.merchant_id IS 'Tenant untuk isolasi RLS; NULL untuk event legacy sebelum kolom ini ada.';

-- Enable RLS for outbox_events.
ALTER TABLE outbox_events ENABLE ROW LEVEL SECURITY;

-- Policy notes:
-- - For new events we expect merchant_id to be set by the app/backend
-- - For backward compatibility: allow reads for already-published events
--   even if merchant_id is NULL, so workers can finish older queues.
DROP POLICY IF EXISTS outbox_events_by_merchant ON outbox_events;

CREATE POLICY outbox_events_by_merchant
ON outbox_events
FOR ALL
USING (
  merchant_id = app_current_merchant_id()
  OR published_at IS NOT NULL
)
WITH CHECK (
  merchant_id = app_current_merchant_id()
  OR merchant_id IS NULL
);

COMMIT;

