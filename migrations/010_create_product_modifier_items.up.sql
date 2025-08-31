-- Migration: create table product_modifier_items
CREATE TABLE product_modifier_items (
    id BIGSERIAL PRIMARY KEY,
    product_id BIGINT NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    modifier_id BIGINT NOT NULL REFERENCES product_modifiers(id) ON DELETE CASCADE,
    CONSTRAINT unique_product_modifier UNIQUE (product_id, modifier_id)
);

