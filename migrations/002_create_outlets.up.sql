-- Migration: create table outlets
CREATE TABLE outlets (
    id BIGSERIAL PRIMARY KEY,
    merchant_id BIGINT NOT NULL REFERENCES merchants(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    phone VARCHAR(14) UNIQUE NOT NULL,
    address TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMP
);
CREATE INDEX idx_outlets_merchant ON outlets(merchant_id);
