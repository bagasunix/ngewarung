-- 000052_rls_product_modifier_items.up.sql
-- Tenant isolation for product_modifier_items (scoped by product -> outlet -> merchant)

BEGIN;

ALTER TABLE product_modifier_items ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS product_modifier_items_by_merchant ON product_modifier_items;

CREATE POLICY product_modifier_items_by_merchant
ON product_modifier_items
FOR ALL
USING (
  app_product_belongs_to_current_merchant(product_id)
)
WITH CHECK (
  app_product_belongs_to_current_merchant(product_id)
);

COMMIT;

