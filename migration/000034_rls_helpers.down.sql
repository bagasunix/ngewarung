-- 000034_rls_helpers.down.sql
-- Drop helper functions

BEGIN;

DROP FUNCTION IF EXISTS app_transaction_item_belongs_to_current_merchant(UUID);
DROP FUNCTION IF EXISTS app_transaction_belongs_to_current_merchant(UUID);
DROP FUNCTION IF EXISTS app_outlet_belongs_to_current_merchant(UUID);
DROP FUNCTION IF EXISTS app_current_merchant_id();

COMMIT;

