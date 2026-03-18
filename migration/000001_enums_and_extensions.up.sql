-- 000001_enums_and_extensions.up.sql
-- Create required extensions and enum types

BEGIN;

-- UUID / crypto support
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- ENUMS
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'transaction_status') THEN
    CREATE TYPE transaction_status AS ENUM ('COMPLETED', 'CANCELED');
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'payment_method') THEN
    CREATE TYPE payment_method AS ENUM ('cash', 'qris');
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'tagihan_status') THEN
    CREATE TYPE tagihan_status AS ENUM ('UNPAID', 'PARTIAL', 'PAID');
  END IF;
END$$;

COMMIT;

