-- 000044_rls_tagihan_payments.up.sql
-- Tenant isolation for tagihan_payments (via tagihan -> outlet -> merchant)

BEGIN;

ALTER TABLE tagihan_payments ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tagihan_payments_by_merchant ON tagihan_payments;

CREATE POLICY tagihan_payments_by_merchant
ON tagihan_payments
FOR ALL
USING (
  EXISTS (
    SELECT 1
    FROM tagihan t
    WHERE t.id = tagihan_payments.tagihan_id
      AND app_outlet_belongs_to_current_merchant(t.outlet_id)
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1
    FROM tagihan t
    WHERE t.id = tagihan_payments.tagihan_id
      AND app_outlet_belongs_to_current_merchant(t.outlet_id)
  )
);

COMMIT;

