-- Migration: create table product_variant_prices
CREATE TABLE product_variant_prices (
    id BIGSERIAL PRIMARY KEY,
    variant_id BIGINT NOT NULL REFERENCES product_variants(id) ON DELETE CASCADE,
    outlet_id BIGINT NOT NULL REFERENCES outlets(id) ON DELETE CASCADE,
    price NUMERIC(12,2) NOT NULL,
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now(),
    deleted_at TIMESTAMP,
    CONSTRAINT unique_variant_outlet_price UNIQUE (variant_id, outlet_id)
);