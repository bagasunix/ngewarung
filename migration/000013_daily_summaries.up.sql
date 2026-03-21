-- 000013_daily_summaries.up.sql
-- Pre-aggregated daily summaries per outlet

BEGIN;

CREATE TABLE IF NOT EXISTS daily_summaries (
    outlet_id         UUID NOT NULL REFERENCES outlets(id),
    date              DATE NOT NULL,
    total_sales       BIGINT NOT NULL DEFAULT 0,
    total_expenses    BIGINT NOT NULL DEFAULT 0,
    transaction_count INT NOT NULL DEFAULT 0,
    PRIMARY KEY (outlet_id, date)
);

COMMENT ON TABLE daily_summaries IS 'Agregat ringkas harian per outlet: penjualan, pengeluaran, jumlah transaksi.';

COMMENT ON COLUMN daily_summaries.outlet_id IS 'Cabang (bagian primary key).';
COMMENT ON COLUMN daily_summaries.date IS 'Tanggal laporan (bagian primary key).';
COMMENT ON COLUMN daily_summaries.total_sales IS 'Total penjualan harian.';
COMMENT ON COLUMN daily_summaries.total_expenses IS 'Total pengeluaran harian.';
COMMENT ON COLUMN daily_summaries.transaction_count IS 'Jumlah transaksi penjualan.';

COMMIT;

