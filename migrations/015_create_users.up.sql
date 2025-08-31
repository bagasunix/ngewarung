-- Migration: create table users
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    merchant_id BIGINT REFERENCES merchants(id) ON DELETE CASCADE,
    outlet_id BIGINT REFERENCES outlets(id) ON DELETE SET NULL,
    role_id BIGINT NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
    name VARCHAR(150) NOT NULL,
    sex SMALLINT NOT NULL, -- 1=male, 2=female
    phone VARCHAR(14), -- user phone
    email VARCHAR(150) UNIQUE NOT NULL,
    address TEXT, -- user address
    dob DATE, -- user date of birth
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    photo TEXT, -- URL foto profil
    user_status SMALLINT DEFAULT 0, -- 0=inactive, 1=active, 2=suspended
    is_login SMALLINT DEFAULT 0, -- 0=logged out, 1=logged in
    deleted_at TIMESTAMP, -- soft delete
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now() 
);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_merchant ON users(merchant_id);