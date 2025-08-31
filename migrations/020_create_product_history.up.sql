-- Migration: create table product_history
CREATE TABLE product_history (
    id BIGSERIAL PRIMARY KEY,
    variant_id BIGINT NOT NULL REFERENCES product_variants(id) ON DELETE CASCADE,
    outlet_id BIGINT NOT NULL REFERENCES outlets(id) ON DELETE CASCADE,
    movement_type SMALLINT NOT NULL, -- 1=purchase, 2=sale, 3=return, 4=adjustment
    quantity INT NOT NULL,
    reference_id BIGINT, -- bisa transaksi_id / purchase_order_id
    note TEXT,
    created_at TIMESTAMP DEFAULT now()
);
-- Supaya cepat cari history per produk & outlet
CREATE INDEX idx_product_history_variant_outlet ON product_history (variant_id, outlet_id);

-- Supaya cepat filter berdasarkan jenis movement
CREATE INDEX idx_product_history_movement_type ON product_history (movement_type);

-- Supaya cepat tracking history dari transaksi/purchase order tertentu
CREATE INDEX idx_product_history_reference_id ON product_history (reference_id);

-- Supaya laporan stok bisa cepat diurutkan
CREATE INDEX idx_product_history_created_at ON product_history (created_at);