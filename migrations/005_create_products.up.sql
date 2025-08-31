-- Migration: create table products
CREATE TABLE products (
    id BIGSERIAL PRIMARY KEY,
    merchant_id BIGINT NOT NULL REFERENCES merchants(id) ON DELETE CASCADE,
    -- outlet_id BIGINT REFERENCES outlets(id) ON DELETE CASCADE, -- NULL = produk global
    category_id BIGINT REFERENCES product_categories(id) ON DELETE SET NULL,
    unit_id BIGINT REFERENCES units(id) ON DELETE SET NULL,
    name VARCHAR(200) NOT NULL,
    sku VARCHAR(100) UNIQUE,
    barcode VARCHAR(100) UNIQUE,
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    deleted_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now(), 
    CONSTRAINT unique_merchant_sku UNIQUE (merchant_id, sku)
);
CREATE INDEX idx_products_sku ON products(sku);
CREATE INDEX idx_products_barcode ON products(barcode);
CREATE INDEX idx_products_merchant ON products(merchant_id);