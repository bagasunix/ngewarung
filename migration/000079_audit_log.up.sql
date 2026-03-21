-- 000079_audit_log.up.sql
-- Audit log for enterprise governance (who did what, when)

BEGIN;

CREATE TABLE IF NOT EXISTS audit_log (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    merchant_id     UUID NOT NULL REFERENCES merchants(id) ON DELETE CASCADE,
    outlet_id       UUID REFERENCES outlets(id) ON DELETE SET NULL,
    actor_user_id   UUID REFERENCES users(id) ON DELETE SET NULL,

    action_type     TEXT NOT NULL,  -- e.g. UPDATE_PRICE, VOID_TRANSACTION
    entity_type     TEXT NOT NULL,  -- e.g. product_variant_prices, transactions
    entity_id       TEXT,          -- store as text to support multiple id types

    before_json     JSONB,
    after_json      JSONB,
    metadata_json   JSONB,

    -- Optional HTTP context (useful for request-driven audit)
    method          VARCHAR(50),
    headers         TEXT,
    url              TEXT,
    status_code     VARCHAR(10),
    request         TEXT,
    response        TEXT,
    ip_address      VARCHAR(45),
    user_agent      TEXT,

    created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_audit_log_merchant_created_at
  ON audit_log(merchant_id, created_at);
CREATE INDEX IF NOT EXISTS idx_audit_log_outlet_created_at
  ON audit_log(outlet_id, created_at);
CREATE INDEX IF NOT EXISTS idx_audit_log_actor_created_at
  ON audit_log(actor_user_id, created_at);

COMMENT ON TABLE audit_log IS 'Audit governance: aksi penting per tenant (before/after JSON, opsional konteks HTTP request).';

COMMENT ON COLUMN audit_log.id IS 'Primary key jejak audit.';
COMMENT ON COLUMN audit_log.merchant_id IS 'Tenant yang terdampak.';
COMMENT ON COLUMN audit_log.outlet_id IS 'Cabang konteks jika relevan.';
COMMENT ON COLUMN audit_log.actor_user_id IS 'Pengguna yang melakukan aksi.';
COMMENT ON COLUMN audit_log.action_type IS 'Kode aksi (mis. UPDATE_PRICE).';
COMMENT ON COLUMN audit_log.entity_type IS 'Nama tabel/entitas.';
COMMENT ON COLUMN audit_log.entity_id IS 'ID entitas (teks untuk fleksibilitas tipe).';
COMMENT ON COLUMN audit_log.before_json IS 'Snapshot sebelum perubahan.';
COMMENT ON COLUMN audit_log.after_json IS 'Snapshot sesudah perubahan.';
COMMENT ON COLUMN audit_log.metadata_json IS 'Metadata tambahan.';
COMMENT ON COLUMN audit_log.method IS 'HTTP method jika dari request.';
COMMENT ON COLUMN audit_log.headers IS 'Header request (serialisasi teks).';
COMMENT ON COLUMN audit_log.url IS 'URL request.';
COMMENT ON COLUMN audit_log.status_code IS 'HTTP status respons.';
COMMENT ON COLUMN audit_log.request IS 'Body/request ringkas atau penuh.';
COMMENT ON COLUMN audit_log.response IS 'Body respons ringkas atau penuh.';
COMMENT ON COLUMN audit_log.ip_address IS 'Alamat IP klien.';
COMMENT ON COLUMN audit_log.user_agent IS 'User-Agent klien.';
COMMENT ON COLUMN audit_log.created_at IS 'Waktu kejadian dicatat.';

-- Tenant isolation
ALTER TABLE audit_log ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS audit_log_by_merchant ON audit_log;

CREATE POLICY audit_log_by_merchant
ON audit_log
FOR ALL
USING (
  merchant_id = app_current_merchant_id()
)
WITH CHECK (
  merchant_id = app_current_merchant_id()
);

COMMIT;

