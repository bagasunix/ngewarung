-- 000058_rls_helpers_user_mgmt.down.sql

BEGIN;

DROP FUNCTION IF EXISTS app_user_belongs_to_current_merchant(UUID);
DROP FUNCTION IF EXISTS app_role_belongs_to_current_merchant(UUID);

COMMIT;

