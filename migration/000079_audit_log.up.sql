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

