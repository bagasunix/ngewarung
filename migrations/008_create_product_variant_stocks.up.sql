-- Migration: create table product_variant_stocks
CREATE TABLE product_variant_stocks (
    id BIGSERIAL PRIMARY KEY,
    variant_id BIGINT NOT NULL REFERENCES product_variants(id) ON DELETE CASCADE,
    outlet_id BIGINT NOT NULL REFERENCES outlets(id) ON DELETE CASCADE,
    quantity INT DEFAULT 0,
    updated_at TIMESTAMP DEFAULT now(),
    deleted_at TIMESTAMP,
    CONSTRAINT unique_variant_outlet_stock UNIQUE (variant_id, outlet_id)
);
