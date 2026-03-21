-- 000032_transaction_items_add_finance_columns.up.sql
-- Extend transaction_items to support variant + finance detail (discount/tax) like enterprise POS

BEGIN;

ALTER TABLE transaction_items
  ADD COLUMN IF NOT EXISTS variant_id UUID REFERENCES product_variants(id) ON DELETE SET NULL,
  ADD COLUMN IF NOT EXISTS amount_bruto BIGINT,
  ADD COLUMN IF NOT EXISTS discount_type SMALLINT,
  ADD COLUMN IF NOT EXISTS discount_value BIGINT,
  ADD COLUMN IF NOT EXISTS discount_amount BIGINT,
  ADD COLUMN IF NOT EXISTS tax_percent NUMERIC(5,2),
  ADD COLUMN IF NOT EXISTS tax_amount BIGINT;

-- Keep subtotal as existing field (already stores final amount for item)

CREATE INDEX IF NOT EXISTS idx_transaction_items_variant_id ON transaction_items(variant_id);

COMMENT ON COLUMN transaction_items.variant_id IS 'Varian SKU jika penjualan per varian.';
COMMENT ON COLUMN transaction_items.amount_bruto IS 'Nilai kotor baris sebelum diskon/pajak.';
COMMENT ON COLUMN transaction_items.discount_type IS 'Jenis diskon baris (kode aplikasi).';
COMMENT ON COLUMN transaction_items.discount_value IS 'Nilai parameter diskon (persen/nominal sesuai type).';
COMMENT ON COLUMN transaction_items.discount_amount IS 'Nominal diskon terhitung.';
COMMENT ON COLUMN transaction_items.tax_percent IS 'Persen pajak baris.';
COMMENT ON COLUMN transaction_items.tax_amount IS 'Nominal pajak baris.';

COMMIT;

