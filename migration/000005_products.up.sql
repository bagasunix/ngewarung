-- 000005_products.up.sql
-- Products (catalog + stock + expiry)

BEGIN;

CREATE TABLE IF NOT EXISTS products (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    outlet_id   UUID NOT NULL REFERENCES outlets(id),
    category_id UUID REFERENCES categories(id),
    name        TEXT NOT NULL,
    sku         TEXT,
    price       BIGINT NOT NULL,
    unit        TEXT NOT NULL DEFAULT 'pcs',
    stock       INTEGER NOT NULL DEFAULT 0,
    expiry_date DATE,
    is_deleted  BOOLEAN NOT NULL DEFAULT FALSE,
    deleted_at  TIMESTAMPTZ,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_products_outlet_id ON products(outlet_id);
CREATE INDEX IF NOT EXISTS idx_products_category_id ON products(category_id);
CREATE INDEX IF NOT EXISTS idx_products_outlet_name ON products(outlet_id, name);

COMMENT ON TABLE products IS 'Master produk per outlet: katalog, stok agregat, harga dasar, kadaluarsa.';

COMMENT ON COLUMN products.id IS 'Primary key produk.';
COMMENT ON COLUMN products.outlet_id IS 'Cabang pemilik produk.';
COMMENT ON COLUMN products.category_id IS 'Kategori opsional.';
COMMENT ON COLUMN products.name IS 'Nama produk.';
COMMENT ON COLUMN products.sku IS 'Kode SKU opsional.';
COMMENT ON COLUMN products.price IS 'Harga dasar (satuan terkecil mata uang).';
COMMENT ON COLUMN products.unit IS 'Label satuan teks (legacy; selaras unit_id jika ada).';
COMMENT ON COLUMN products.stock IS 'Stok agregat level produk.';
COMMENT ON COLUMN products.expiry_date IS 'Tanggal kadaluarsa opsional.';
COMMENT ON COLUMN products.is_deleted IS 'Flag soft delete.';
COMMENT ON COLUMN products.deleted_at IS 'Waktu soft delete.';
COMMENT ON COLUMN products.created_at IS 'Waktu pembuatan.';
COMMENT ON COLUMN products.updated_at IS 'Waktu pembaruan terakhir.';

COMMIT;

