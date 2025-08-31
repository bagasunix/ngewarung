-- Migration: create table product_variants
CREATE TABLE product_variants (
    id BIGSERIAL PRIMARY KEY,
    product_id BIGINT NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,       -- contoh: Small, Medium, Large
    -- price NUMERIC(12,2) NOT NULL,
    sku VARCHAR(100) UNIQUE,
    deleted_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now(),
    CONSTRAINT unique_product_sku UNIQUE (product_id, sku)
);
CREATE INDEX idx_variants_product ON product_variants(product_id);
