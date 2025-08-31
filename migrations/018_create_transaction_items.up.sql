-- Migration: create table transaction_items
CREATE TABLE transaction_items (
    id BIGSERIAL PRIMARY KEY,
    transaction_id BIGINT NOT NULL REFERENCES transactions(id) ON DELETE CASCADE,
    product_id BIGINT NOT NULL REFERENCES products(id) ON DELETE SET NULL,
    variant_id BIGINT REFERENCES product_variants(id) ON DELETE SET NULL,
    qty INT NOT NULL,
    amount_bruto NUMERIC(12,2) NOT NULL, -- harga sebelum diskon
    discount_type SMALLINT, -- '1' = persen, '2' = amount/rupiah, 0 = tidak ada diskon
    discount_value NUMERIC(12,2) NOT NULL DEFAULT 0,
    discount_amount NUMERIC(12,2) NOT NULL, -- nominal diskon yang sudah dihitung
    tax_percent NUMERIC(5,2) NOT NULL,     -- persen pajak, cukup 5,2
    tax_amount NUMERIC(12,2) NOT NULL, -- nominal pajak
    subtotal NUMERIC(12,2) NOT NULL, -- (price * qty) - discount_amount + tax_amount
    created_at TIMESTAMP DEFAULT now()
);