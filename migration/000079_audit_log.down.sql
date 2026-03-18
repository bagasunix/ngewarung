-- 000079_audit_log.down.sql

BEGIN;

DROP POLICY IF EXISTS audit_log_by_merchant ON audit_log;

ALTER TABLE audit_log DISABLE ROW LEVEL SECURITY;

DROP TABLE IF EXISTS audit_log;

COMMIT;

