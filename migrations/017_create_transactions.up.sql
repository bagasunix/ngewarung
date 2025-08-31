-- Migration: create table transactions
CREATE TABLE transactions (
    id BIGSERIAL PRIMARY KEY,
    merchant_id BIGINT NOT NULL REFERENCES merchants(id) ON DELETE CASCADE,
    outlet_id BIGINT NOT NULL REFERENCES outlets(id) ON DELETE CASCADE,
    user_id BIGINT NOT NULL REFERENCES users(id), -- tidak dihapus biar historis tetap ada
    total NUMERIC(12,2) NOT NULL,
    payment_method SMALLINT NOT NULL, -- 1=cash, 2=card, 3=e-wallet
    transaction_status SMALLINT NOT NULL DEFAULT 1, -- 1=pending, 2=paid, 3=cancelled
    deleted_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now()
);
CREATE INDEX idx_transactions_merchant ON transactions(merchant_id);
CREATE INDEX idx_transactions_outlet ON transactions(outlet_id);
CREATE INDEX idx_transactions_user ON transactions(user_id);
CREATE INDEX idx_transactions_created_at ON transactions(created_at);
