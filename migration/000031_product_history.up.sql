-- 000031_product_history.up.sql
-- Stock movement audit ledger per variant & outlet

BEGIN;

CREATE TABLE IF NOT EXISTS product_history (
    id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    variant_id     UUID NOT NULL REFERENCES product_variants(id) ON DELETE CASCADE,
    outlet_id      UUID NOT NULL REFERENCES outlets(id) ON DELETE CASCADE,
    movement_type  SMALLINT NOT NULL, -- 1=purchase, 2=sale, 3=return, 4=adjustment
    quantity       INTEGER NOT NULL,
    reference_id   UUID, -- purchase_order_id or transaction_id
    note            TEXT,
    created_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_product_history_variant_outlet ON product_history(variant_id, outlet_id);
CREATE INDEX IF NOT EXISTS idx_product_history_movement_type ON product_history(movement_type);
CREATE INDEX IF NOT EXISTS idx_product_history_reference_id ON product_history(reference_id);
CREATE INDEX IF NOT EXISTS idx_product_history_created_at ON product_history(created_at);

COMMENT ON TABLE product_history IS 'Ledger pergerakan stok per varian per outlet (beli, jual, retur, koreksi).';

COMMENT ON COLUMN product_history.id IS 'Primary key jejak.';
COMMENT ON COLUMN product_history.variant_id IS 'Varian terdampak.';
COMMENT ON COLUMN product_history.outlet_id IS 'Cabang.';
COMMENT ON COLUMN product_history.movement_type IS '1=beli; 2=jual; 3=retur; 4=koreksi.';
COMMENT ON COLUMN product_history.quantity IS 'Delta qty (+/-).';
COMMENT ON COLUMN product_history.reference_id IS 'ID referensi PO atau transaksi.';
COMMENT ON COLUMN product_history.note IS 'Catatan.';
COMMENT ON COLUMN product_history.created_at IS 'Waktu pergerakan.';

COMMIT;

