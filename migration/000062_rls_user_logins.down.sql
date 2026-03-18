-- 000062_rls_user_logins.down.sql

BEGIN;

ALTER TABLE user_logins DISABLE ROW LEVEL SECURITY;

COMMIT;

