-- 000032_transaction_items_add_finance_columns.down.sql

BEGIN;

ALTER TABLE transaction_items
  DROP COLUMN IF EXISTS variant_id,
  DROP COLUMN IF EXISTS amount_bruto,
  DROP COLUMN IF EXISTS discount_type,
  DROP COLUMN IF EXISTS discount_value,
  DROP COLUMN IF EXISTS discount_amount,
  DROP COLUMN IF EXISTS tax_percent,
  DROP COLUMN IF EXISTS tax_amount;

DROP INDEX IF EXISTS idx_transaction_items_variant_id;

COMMIT;

