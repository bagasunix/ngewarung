-- Migration: create table transaction_item_modifiers
CREATE TABLE transaction_item_modifiers (
    id BIGSERIAL PRIMARY KEY,
    transaction_item_id BIGINT NOT NULL REFERENCES transaction_items(id) ON DELETE CASCADE,
    modifier_id BIGINT NOT NULL REFERENCES product_modifiers(id) ON DELETE SET NULL,
    price NUMERIC(12,2) NOT NULL
);
