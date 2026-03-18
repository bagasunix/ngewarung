-- 000047_rls_helpers_extend.up.sql
-- Additional helper functions for enterprise RLS (variants/modifiers/PO).

BEGIN;

CREATE OR REPLACE FUNCTION app_product_belongs_to_current_merchant(_product_id UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM products p
    JOIN outlets o ON o.id = p.outlet_id
    WHERE p.id = _product_id
      AND o.merchant_id = app_current_merchant_id()
  );
$$;

CREATE OR REPLACE FUNCTION app_product_variant_belongs_to_current_merchant(_variant_id UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM product_variants v
    JOIN products p ON p.id = v.product_id
    JOIN outlets o ON o.id = p.outlet_id
    WHERE v.id = _variant_id
      AND o.merchant_id = app_current_merchant_id()
  );
$$;

CREATE OR REPLACE FUNCTION app_purchase_order_belongs_to_current_merchant(_purchase_order_id UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM purchase_orders po
    WHERE po.id = _purchase_order_id
      AND po.merchant_id = app_current_merchant_id()
  );
$$;

COMMIT;

