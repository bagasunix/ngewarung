-- 000028_suppliers.up.sql
-- Supplier master for purchase orders

BEGIN;

CREATE TABLE IF NOT EXISTS suppliers (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    merchant_id     UUID NOT NULL REFERENCES merchants(id) ON DELETE CASCADE,
    name            TEXT NOT NULL,
    contact_person  TEXT,
    phone           TEXT,
    address         TEXT,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    deleted_at      TIMESTAMPTZ,
    is_deleted      BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE INDEX IF NOT EXISTS idx_suppliers_merchant_id ON suppliers(merchant_id);

COMMENT ON TABLE suppliers IS 'Master pemasok per tenant untuk PO/restock.';

COMMENT ON COLUMN suppliers.id IS 'Primary key pemasok.';
COMMENT ON COLUMN suppliers.merchant_id IS 'Tenant.';
COMMENT ON COLUMN suppliers.name IS 'Nama pemasok.';
COMMENT ON COLUMN suppliers.contact_person IS 'Kontak orang.';
COMMENT ON COLUMN suppliers.phone IS 'Telepon.';
COMMENT ON COLUMN suppliers.address IS 'Alamat.';
COMMENT ON COLUMN suppliers.created_at IS 'Waktu pembuatan.';
COMMENT ON COLUMN suppliers.updated_at IS 'Waktu pembaruan.';
COMMENT ON COLUMN suppliers.deleted_at IS 'Soft delete.';
COMMENT ON COLUMN suppliers.is_deleted IS 'Flag soft delete.';

COMMIT;

