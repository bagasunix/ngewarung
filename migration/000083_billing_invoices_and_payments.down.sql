-- 000083_billing_invoices_and_payments.down.sql

BEGIN;

DROP POLICY IF EXISTS billing_payments_by_merchant ON billing_payments;
ALTER TABLE billing_payments DISABLE ROW LEVEL SECURITY;
DROP TABLE IF EXISTS billing_payments;

DROP POLICY IF EXISTS billing_invoice_items_by_merchant ON billing_invoice_items;
ALTER TABLE billing_invoice_items DISABLE ROW LEVEL SECURITY;
DROP TABLE IF EXISTS billing_invoice_items;

DROP POLICY IF EXISTS billing_invoices_by_merchant ON billing_invoices;
ALTER TABLE billing_invoices DISABLE ROW LEVEL SECURITY;
DROP TABLE IF EXISTS billing_invoices;

COMMIT;

