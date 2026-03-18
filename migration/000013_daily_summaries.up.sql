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

COMMIT;

