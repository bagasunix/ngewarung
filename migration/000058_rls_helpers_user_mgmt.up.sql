-- 000058_rls_helpers_user_mgmt.up.sql
-- Helpers for governance/audit RLS scoping

BEGIN;

CREATE OR REPLACE FUNCTION app_role_belongs_to_current_merchant(_role_id UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM roles r
    WHERE r.id = _role_id
      AND r.merchant_id = app_current_merchant_id()
  );
$$;

CREATE OR REPLACE FUNCTION app_user_belongs_to_current_merchant(_user_id UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM user_role_assignments ura
    JOIN roles r ON r.id = ura.role_id
    WHERE ura.user_id = _user_id
      AND r.merchant_id = app_current_merchant_id()
  );
$$;

COMMIT;

