-- Migration: create table roles
CREATE TABLE roles (
    id BIGSERIAL PRIMARY KEY,
    merchant_id BIGINT REFERENCES merchants(id) ON DELETE CASCADE, -- NULL = role global
    name VARCHAR(50) NOT NULL, -- superadmin, admin, cashier, manager
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now() 
);
