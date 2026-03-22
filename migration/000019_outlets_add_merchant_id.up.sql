-- 000019_outlets_add_merchant_id.up.sql
-- Add merchant_id to outlets for proper multi-tenant B2B

BEGIN;

ALTER TABLE outlets
  ADD COLUMN IF NOT EXISTS merchant_id UUID REFERENCES merchants(id) ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS idx_outlets_merchant_id ON outlets(merchant_id);

-- Exactly one central price outlet per merchant (enforced when merchant_id is not null).
CREATE UNIQUE INDEX IF NOT EXISTS uq_outlets_price_central_per_merchant
ON outlets(merchant_id)
WHERE is_price_central = TRUE AND merchant_id IS NOT NULL;

COMMENT ON COLUMN outlets.merchant_id IS 'Tenant induk B2B; semua cabang mengait ke merchants.';

COMMIT;

