-- 000011_tagihan.up.sql
-- Tagihan (piutang) header

BEGIN;

CREATE TABLE IF NOT EXISTS tagihan (
    id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    outlet_id      UUID NOT NULL REFERENCES outlets(id),
    customer_id    UUID REFERENCES customers(id),
    customer_name  TEXT NOT NULL,
    customer_phone TEXT,
    amount         BIGINT NOT NULL,
    amount_paid    BIGINT NOT NULL DEFAULT 0,
    due_date       DATE NOT NULL,
    status         tagihan_status NOT NULL DEFAULT 'UNPAID',
    created_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_tagihan_outlet_status ON tagihan(outlet_id, status);
CREATE INDEX IF NOT EXISTS idx_tagihan_outlet_due_date ON tagihan(outlet_id, due_date);

COMMENT ON TABLE tagihan IS 'Piutang/tagihan: header hutang pelanggan, jatuh tempo, status.';

COMMENT ON COLUMN tagihan.id IS 'Primary key tagihan.';
COMMENT ON COLUMN tagihan.outlet_id IS 'Cabang penerbit piutang.';
COMMENT ON COLUMN tagihan.customer_id IS 'Pelanggan terhubung jika ada.';
COMMENT ON COLUMN tagihan.customer_name IS 'Nama pelanggan pada dokumen.';
COMMENT ON COLUMN tagihan.customer_phone IS 'Telepon pelanggan.';
COMMENT ON COLUMN tagihan.amount IS 'Nilai piutang total.';
COMMENT ON COLUMN tagihan.amount_paid IS 'Akumulasi sudah dibayar.';
COMMENT ON COLUMN tagihan.due_date IS 'Tanggal jatuh tempo.';
COMMENT ON COLUMN tagihan.status IS 'Status piutang (enum tagihan_status).';
COMMENT ON COLUMN tagihan.created_at IS 'Waktu pembuatan.';
COMMENT ON COLUMN tagihan.updated_at IS 'Waktu pembaruan terakhir.';

COMMIT;

