-- 000045_rls_daily_summaries.up.sql
-- Tenant isolation for daily summaries

BEGIN;

ALTER TABLE daily_summaries ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS daily_summaries_by_merchant ON daily_summaries;

CREATE POLICY daily_summaries_by_merchant
ON daily_summaries
FOR ALL
USING (
  app_outlet_belongs_to_current_merchant(outlet_id)
)
WITH CHECK (
  app_outlet_belongs_to_current_merchant(outlet_id)
);

COMMIT;

