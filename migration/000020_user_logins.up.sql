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

COMMENT ON TABLE user_logins IS 'Riwayat login/logout untuk audit governance (IP, user agent, device).';

COMMENT ON COLUMN user_logins.id IS 'Primary key sesi login.';
COMMENT ON COLUMN user_logins.user_id IS 'Pengguna yang login.';
COMMENT ON COLUMN user_logins.login_at IS 'Waktu mulai sesi.';
COMMENT ON COLUMN user_logins.logout_at IS 'Waktu logout jika tercatat.';
COMMENT ON COLUMN user_logins.ip_address IS 'Alamat IP klien.';
COMMENT ON COLUMN user_logins.user_agent IS 'User-Agent browser/app.';
COMMENT ON COLUMN user_logins.device_info IS 'Info perangkat tambahan.';
COMMENT ON COLUMN user_logins.created_at IS 'Waktu rekaman baris.';

COMMIT;

