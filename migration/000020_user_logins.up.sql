-- 000020_user_logins.up.sql
-- Audit login history (enterprise governance)

BEGIN;

CREATE TABLE IF NOT EXISTS user_logins (
    id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id      UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    login_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
    logout_at    TIMESTAMPTZ,
    ip_address   TEXT,
    user_agent   TEXT,
    device_info  TEXT,
    created_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_user_logins_user_id ON user_logins(user_id);
CREATE INDEX IF NOT EXISTS idx_user_logins_login_at ON user_logins(login_at);

COMMIT;

