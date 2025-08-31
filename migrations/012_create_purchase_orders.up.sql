-- Migration: create table purchase_orders
CREATE TABLE purchase_orders (
    id BIGSERIAL PRIMARY KEY,
    merchant_id BIGINT NOT NULL REFERENCES merchants(id) ON DELETE CASCADE,
    supplier_id BIGINT NOT NULL REFERENCES suppliers(id) ON DELETE CASCADE,
    outlet_id BIGINT REFERENCES outlets(id) ON DELETE SET NULL,
    order_date TIMESTAMP DEFAULT now(),
    purchase_status SMALLINT DEFAULT 1 -- 1=pending, 2=received, 3=cancelled
);
CREATE INDEX idx_purchase_orders_supplier ON purchase_orders(supplier_id);
CREATE INDEX idx_purchase_orders_date ON purchase_orders(order_date);

