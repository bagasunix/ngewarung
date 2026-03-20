-- 000083_billing_invoices_and_payments.up.sql
-- Billing invoices, line items, and payment records.

BEGIN;

CREATE TABLE IF NOT EXISTS billing_invoices (
    id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    merchant_id           UUID NOT NULL REFERENCES merchants(id) ON DELETE CASCADE,
    subscription_id       UUID REFERENCES merchant_subscriptions(id) ON DELETE SET NULL,
    invoice_no            TEXT NOT NULL UNIQUE,
    status                SMALLINT NOT NULL DEFAULT 1, -- 1=draft,2=issued,3=paid,4=void,5=overdue,6=failed
    currency              VARCHAR(3) NOT NULL DEFAULT 'IDR',
    subtotal_amount       BIGINT NOT NULL DEFAULT 0,
    tax_amount            BIGINT NOT NULL DEFAULT 0,
    discount_amount       BIGINT NOT NULL DEFAULT 0,
    total_amount          BIGINT NOT NULL DEFAULT 0,
    paid_amount           BIGINT NOT NULL DEFAULT 0,
    due_amount            BIGINT NOT NULL DEFAULT 0,
    issue_date            TIMESTAMPTZ,
    due_date              TIMESTAMPTZ,
    paid_at               TIMESTAMPTZ,
    external_provider     TEXT,
    external_invoice_id   TEXT,
    metadata_json         JSONB,
    created_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
    deleted_at            TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_billing_invoices_merchant_id ON billing_invoices(merchant_id);
CREATE INDEX IF NOT EXISTS idx_billing_invoices_status ON billing_invoices(status);
CREATE INDEX IF NOT EXISTS idx_billing_invoices_due_date ON billing_invoices(due_date);

CREATE TABLE IF NOT EXISTS billing_invoice_items (
    id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    merchant_id           UUID NOT NULL REFERENCES merchants(id) ON DELETE CASCADE,
    invoice_id            UUID NOT NULL REFERENCES billing_invoices(id) ON DELETE CASCADE,
    feature_key           TEXT,
    description           TEXT NOT NULL,
    quantity              BIGINT NOT NULL DEFAULT 1,
    unit_amount           BIGINT NOT NULL DEFAULT 0,
    subtotal_amount       BIGINT NOT NULL DEFAULT 0,
    tax_amount            BIGINT NOT NULL DEFAULT 0,
    total_amount          BIGINT NOT NULL DEFAULT 0,
    metadata_json         JSONB,
    created_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
    deleted_at            TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_billing_invoice_items_invoice_id ON billing_invoice_items(invoice_id);
CREATE INDEX IF NOT EXISTS idx_billing_invoice_items_merchant_id ON billing_invoice_items(merchant_id);

CREATE TABLE IF NOT EXISTS billing_payments (
    id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    merchant_id           UUID NOT NULL REFERENCES merchants(id) ON DELETE CASCADE,
    invoice_id            UUID REFERENCES billing_invoices(id) ON DELETE SET NULL,
    status                SMALLINT NOT NULL DEFAULT 1, -- 1=initiated,2=success,3=failed,4=voided
    payment_method        TEXT, -- va, ewallet, card, bank_transfer, etc.
    provider              TEXT, -- xendit, midtrans, etc.
    amount                BIGINT NOT NULL,
    currency              VARCHAR(3) NOT NULL DEFAULT 'IDR',
    paid_at               TIMESTAMPTZ,
    external_payment_id   TEXT,
    external_reference    TEXT,
    request_payload       JSONB,
    response_payload      JSONB,
    metadata_json         JSONB,
    created_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
    deleted_at            TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_billing_payments_merchant_id ON billing_payments(merchant_id);
CREATE INDEX IF NOT EXISTS idx_billing_payments_invoice_id ON billing_payments(invoice_id);
CREATE INDEX IF NOT EXISTS idx_billing_payments_status ON billing_payments(status);

-- RLS: tenant scoped
ALTER TABLE billing_invoices ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS billing_invoices_by_merchant ON billing_invoices;
CREATE POLICY billing_invoices_by_merchant
ON billing_invoices
FOR ALL
USING (merchant_id = app_current_merchant_id())
WITH CHECK (merchant_id = app_current_merchant_id());

ALTER TABLE billing_invoice_items ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS billing_invoice_items_by_merchant ON billing_invoice_items;
CREATE POLICY billing_invoice_items_by_merchant
ON billing_invoice_items
FOR ALL
USING (merchant_id = app_current_merchant_id())
WITH CHECK (merchant_id = app_current_merchant_id());

ALTER TABLE billing_payments ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS billing_payments_by_merchant ON billing_payments;
CREATE POLICY billing_payments_by_merchant
ON billing_payments
FOR ALL
USING (merchant_id = app_current_merchant_id())
WITH CHECK (merchant_id = app_current_merchant_id());

COMMIT;

