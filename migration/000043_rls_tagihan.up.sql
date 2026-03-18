-- 000043_rls_tagihan.up.sql
-- Tenant isolation for tagihan (piutang)

BEGIN;

ALTER TABLE tagihan ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tagihan_by_merchant ON tagihan;

CREATE POLICY tagihan_by_merchant
ON tagihan
FOR ALL
USING (
  app_outlet_belongs_to_current_merchant(outlet_id)
)
WITH CHECK (
  app_outlet_belongs_to_current_merchant(outlet_id)
);

COMMIT;

