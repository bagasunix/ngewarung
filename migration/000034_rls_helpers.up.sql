-- 000034_rls_helpers.up.sql
-- Helpers for tenant-aware RLS policies.
-- Backend must set: SET LOCAL app.merchant_id = '<uuid>';

BEGIN;

CREATE OR REPLACE FUNCTION app_current_merchant_id()
RETURNS UUID
LANGUAGE sql
STABLE
AS $$
  SELECT NULLIF(current_setting('app.merchant_id', true), '')::uuid;
$$;

CREATE OR REPLACE FUNCTION app_outlet_belongs_to_current_merchant(_outlet_id UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM outlets o
    WHERE o.id = _outlet_id
      AND o.merchant_id = app_current_merchant_id()
  );
$$;

CREATE OR REPLACE FUNCTION app_transaction_belongs_to_current_merchant(_transaction_id UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM transactions t
    JOIN outlets o ON o.id = t.outlet_id
    WHERE t.id = _transaction_id
      AND o.merchant_id = app_current_merchant_id()
  );
$$;

CREATE OR REPLACE FUNCTION app_transaction_item_belongs_to_current_merchant(_transaction_item_id UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM transaction_items ti
    JOIN transactions t ON t.id = ti.transaction_id
    JOIN outlets o ON o.id = t.outlet_id
    WHERE ti.id = _transaction_item_id
      AND o.merchant_id = app_current_merchant_id()
  );
$$;

COMMIT;

