-- 000019_user_role_assignments.up.sql
-- Map users to roles (per outlet optional)

BEGIN;

CREATE TABLE IF NOT EXISTS user_role_assignments (
    id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id    UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    role_id    UUID NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
    outlet_id  UUID REFERENCES outlets(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (user_id, role_id, outlet_id)
);

CREATE INDEX IF NOT EXISTS idx_user_role_assignments_user_id ON user_role_assignments(user_id);
CREATE INDEX IF NOT EXISTS idx_user_role_assignments_outlet_id ON user_role_assignments(outlet_id);

COMMENT ON TABLE user_role_assignments IS 'Penugasan user ke peran; outlet opsional untuk scope cabang.';

COMMENT ON COLUMN user_role_assignments.id IS 'Primary key penugasan.';
COMMENT ON COLUMN user_role_assignments.user_id IS 'Pengguna.';
COMMENT ON COLUMN user_role_assignments.role_id IS 'Peran yang diberikan.';
COMMENT ON COLUMN user_role_assignments.outlet_id IS 'Batasi ke cabang tertentu jika tidak NULL.';
COMMENT ON COLUMN user_role_assignments.created_at IS 'Waktu pembuatan.';
COMMENT ON COLUMN user_role_assignments.updated_at IS 'Waktu pembaruan.';

COMMIT;

