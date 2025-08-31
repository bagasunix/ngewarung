-- Migration: create table user_logs
CREATE TABLE user_logins (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    login_at TIMESTAMP DEFAULT now(),
    logout_at TIMESTAMP,
    ip_address VARCHAR(50),
    user_agent TEXT, -- browser/app info
    device_info TEXT, -- misalnya: "iPhone 15 / Chrome"
    created_at TIMESTAMP DEFAULT now()
);

-- Index untuk mempercepat pencarian login history per user
CREATE INDEX idx_user_logins_user_id ON user_logins(user_id);
CREATE INDEX idx_user_logins_login_at ON user_logins(login_at);

