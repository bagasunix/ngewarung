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

COMMIT;

