-- 000061_rls_user_role_assignments.down.sql

BEGIN;

ALTER TABLE user_role_assignments DISABLE ROW LEVEL SECURITY;

COMMIT;

