-- 000047_rls_helpers_extend.down.sql

BEGIN;

DROP FUNCTION IF EXISTS app_purchase_order_belongs_to_current_merchant(UUID);
DROP FUNCTION IF EXISTS app_product_variant_belongs_to_current_merchant(UUID);
DROP FUNCTION IF EXISTS app_product_belongs_to_current_merchant(UUID);

COMMIT;

