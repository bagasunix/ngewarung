-- 000008_customers.up.sql
-- Customers (for tagihan + loyalty)

BEGIN;

CREATE TABLE IF NOT EXISTS customers (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    outlet_id           UUID NOT NULL REFERENCES outlets(id),
    phone               TEXT,
    name                TEXT,
    points_balance      BIGINT NOT NULL DEFAULT 0,
    last_transaction_at TIMESTAMPTZ,
    deleted_at          TIMESTAMPTZ,
    is_deleted          BOOLEAN NOT NULL DEFAULT FALSE,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (outlet_id, phone)
);

COMMENT ON TABLE customers IS 'Pelanggan per outlet: kontak, poin loyalitas, jejak transaksi terakhir.';

COMMENT ON COLUMN customers.id IS 'Primary key pelanggan.';
COMMENT ON COLUMN customers.outlet_id IS 'Cabang tempat pelanggan tercatat.';
COMMENT ON COLUMN customers.phone IS 'Nomor telepon (unik per outlet jika diisi).';
COMMENT ON COLUMN customers.name IS 'Nama pelanggan.';
COMMENT ON COLUMN customers.points_balance IS 'Saldo poin loyalitas.';
COMMENT ON COLUMN customers.last_transaction_at IS 'Waktu transaksi terakhir.';
COMMENT ON COLUMN customers.deleted_at IS 'Soft delete.';
COMMENT ON COLUMN customers.is_deleted IS 'Flag soft delete.';
COMMENT ON COLUMN customers.created_at IS 'Waktu pembuatan.';
COMMENT ON COLUMN customers.updated_at IS 'Waktu pembaruan terakhir.';

COMMIT;

