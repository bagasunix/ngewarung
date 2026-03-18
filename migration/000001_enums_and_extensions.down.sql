-- 000001_enums_and_extensions.down.sql
-- Drop enum types (extensions usually kept)

BEGIN;

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_type WHERE typname = 'tagihan_status') THEN
    DROP TYPE tagihan_status;
  END IF;

  IF EXISTS (SELECT 1 FROM pg_type WHERE typname = 'payment_method') THEN
    DROP TYPE payment_method;
  END IF;

  IF EXISTS (SELECT 1 FROM pg_type WHERE typname = 'transaction_status') THEN
    DROP TYPE transaction_status;
  END IF;
END$$;

COMMIT;

