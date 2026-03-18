-- 000036_rls_categories.up.sql
-- Tenant isolation for product categories (scoped by outlet)

BEGIN;

ALTER TABLE categories ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS categories_by_merchant ON categories;

CREATE POLICY categories_by_merchant
ON categories
FOR ALL
USING (
  app_outlet_belongs_to_current_merchant(outlet_id)
)
WITH CHECK (
  app_outlet_belongs_to_current_merchant(outlet_id)
);

COMMIT;

