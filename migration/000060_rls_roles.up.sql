-- 000060_rls_roles.up.sql
-- Tenant isolation for roles

BEGIN;

ALTER TABLE roles ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS roles_by_merchant ON roles;

CREATE POLICY roles_by_merchant
ON roles
FOR ALL
USING (
  merchant_id = app_current_merchant_id()
)
WITH CHECK (
  merchant_id = app_current_merchant_id()
);

COMMIT;

