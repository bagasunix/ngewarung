-- 000061_rls_user_role_assignments.up.sql
-- Tenant isolation for user_role_assignments

BEGIN;

ALTER TABLE user_role_assignments ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS user_role_assignments_by_merchant ON user_role_assignments;

CREATE POLICY user_role_assignments_by_merchant
ON user_role_assignments
FOR ALL
USING (
  app_role_belongs_to_current_merchant(role_id)
)
WITH CHECK (
  app_role_belongs_to_current_merchant(role_id)
);

COMMIT;

