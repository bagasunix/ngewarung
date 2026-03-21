-- 000029_purchase_orders.up.sql
-- Purchase order header (restocking workflow)

BEGIN;

CREATE TABLE IF NOT EXISTS purchase_orders (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    merchant_id     UUID NOT NULL REFERENCES merchants(id) ON DELETE CASCADE,
    supplier_id     UUID NOT NULL REFERENCES suppliers(id) ON DELETE CASCADE,
    outlet_id       UUID REFERENCES outlets(id) ON DELETE SET NULL,
    order_date      TIMESTAMPTZ NOT NULL DEFAULT now(),
    purchase_status SMALLINT NOT NULL DEFAULT 1, -- 1=pending, 2=received, 3=cancelled
    deleted_at      TIMESTAMPTZ,
    is_deleted      BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE INDEX IF NOT EXISTS idx_purchase_orders_supplier_id ON purchase_orders(supplier_id);
CREATE INDEX IF NOT EXISTS idx_purchase_orders_order_date ON purchase_orders(order_date);
CREATE INDEX IF NOT EXISTS idx_purchase_orders_merchant_id ON purchase_orders(merchant_id);

COMMENT ON TABLE purchase_orders IS 'Header purchase order (restock) ke pemasok; opsional outlet tujuan.';

COMMENT ON COLUMN purchase_orders.id IS 'Primary key PO.';
COMMENT ON COLUMN purchase_orders.merchant_id IS 'Tenant pemilik PO.';
COMMENT ON COLUMN purchase_orders.supplier_id IS 'Pemasok.';
COMMENT ON COLUMN purchase_orders.outlet_id IS 'Cabang tujuan pengiriman/stok jika diisi.';
COMMENT ON COLUMN purchase_orders.order_date IS 'Tanggal/waktu pesan.';
COMMENT ON COLUMN purchase_orders.purchase_status IS '1=pending; 2=diterima; 3=batal.';
COMMENT ON COLUMN purchase_orders.deleted_at IS 'Soft delete.';
COMMENT ON COLUMN purchase_orders.is_deleted IS 'Flag soft delete.';

COMMIT;

