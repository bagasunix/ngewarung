-- 000019_outlets_add_merchant_id.down.sql

BEGIN;

ALTER TABLE outlets
  DROP COLUMN IF EXISTS merchant_id;

DROP INDEX IF EXISTS uq_outlets_price_central_per_merchant;
DROP INDEX IF EXISTS idx_outlets_merchant_id;

COMMIT;

