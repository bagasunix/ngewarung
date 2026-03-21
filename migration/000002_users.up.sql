-- 000002_users.up.sql
-- Users table (owner / cashier accounts)

BEGIN;

CREATE TABLE IF NOT EXISTS users (
    id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    phone         TEXT UNIQUE NOT NULL,
    full_name     TEXT NOT NULL,
    password_hash TEXT,
    created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMENT ON TABLE users IS 'Akun pengguna global (pemilik/kasir); autentikasi dan profil dasar.';

COMMENT ON COLUMN users.id IS 'Primary key pengguna.';
COMMENT ON COLUMN users.phone IS 'Nomor telepon unik untuk login/identitas.';
COMMENT ON COLUMN users.full_name IS 'Nama tampilan lengkap.';
COMMENT ON COLUMN users.password_hash IS 'Hash kata sandi (opsional jika login OTP saja).';
COMMENT ON COLUMN users.created_at IS 'Waktu pertama kali akun dibuat.';
COMMENT ON COLUMN users.updated_at IS 'Waktu terakhir profil diubah.';

COMMIT;

