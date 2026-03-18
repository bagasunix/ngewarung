-- 000062_rls_user_logins.up.sql
-- Tenant isolation for user_logins (audit)

BEGIN;

ALTER TABLE user_logins ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS user_logins_by_merchant ON user_logins;

CREATE POLICY user_logins_by_merchant
ON user_logins
FOR ALL
USING (
  app_user_belongs_to_current_merchant(user_id)
)
WITH CHECK (
  app_user_belongs_to_current_merchant(user_id)
);

COMMIT;

