-- Migration: create table merchants
CREATE TABLE merchants ( 
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    phone VARCHAR(14),
    address TEXT,
    merchant_status SMALLINT DEFAULT 1, -- 1=active, 2=suspended
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now(),
    deleted_at TIMESTAMP  
);
CREATE INDEX idx_merchants_email ON merchants(email);
