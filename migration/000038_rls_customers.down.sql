-- 000038_rls_customers.down.sql

BEGIN;

ALTER TABLE customers DISABLE ROW LEVEL SECURITY;

COMMIT;

