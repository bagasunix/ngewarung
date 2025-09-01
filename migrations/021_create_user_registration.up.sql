-- Migration: create table user registration
CREATE TABLE user_registrations (
    id BIGSERIAL PRIMARY KEY,
    role_id BIGINT NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
    name VARCHAR(150) NOT NULL,
    sex SMALLINT NOT NULL, -- 1=male, 2=female
    phone VARCHAR(14), -- user phone
    email VARCHAR(150) UNIQUE NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    user_status SMALLINT DEFAULT 1, -- 1=active, 2=suspended
    deleted_at TIMESTAMP, -- soft delete
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now() 
);

CREATE INDEX idx_user_registrations_email ON user_registrations(email);