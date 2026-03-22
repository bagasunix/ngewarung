-- 000012_expenses.up.sql
-- Business expenses

BEGIN;

CREATE TABLE IF NOT EXISTS expenses (
    id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    outlet_id  UUID NOT NULL REFERENCES outlets(id),
    amount     BIGINT NOT NULL,
    note       TEXT,
    date       DATE NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_expenses_outlet_date ON expenses(outlet_id, date);

COMMENT ON TABLE expenses IS 'Pengeluaran usaha per outlet per tanggal.';

COMMENT ON COLUMN expenses.id IS 'Primary key pengeluaran.';
COMMENT ON COLUMN expenses.outlet_id IS 'Cabang yang menanggung biaya.';
COMMENT ON COLUMN expenses.amount IS 'Jumlah (satuan terkecil).';
COMMENT ON COLUMN expenses.note IS 'Keterangan beban.';
COMMENT ON COLUMN expenses.date IS 'Tanggal beban.';
COMMENT ON COLUMN expenses.created_at IS 'Waktu rekaman.';

COMMIT;

