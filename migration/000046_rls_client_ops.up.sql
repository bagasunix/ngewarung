-- 000046_rls_client_ops.up.sql
-- Tenant isolation for client_ops (offline sync idempotency)

BEGIN;

ALTER TABLE client_ops ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS client_ops_by_merchant ON client_ops;

CREATE POLICY client_ops_by_merchant
ON client_ops
FOR ALL
USING (
  app_outlet_belongs_to_current_merchant(outlet_id)
)
WITH CHECK (
  app_outlet_belongs_to_current_merchant(outlet_id)
);

COMMIT;

