-- 000072_billing_invoices_and_payments.up.sql
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

COMMENT ON TABLE billing_invoices IS 'Invoice tagihan ke merchant (langganan, add-on); status bayar, jatuh tempo.';
COMMENT ON TABLE billing_invoice_items IS 'Baris invoice: deskripsi, qty, pajak, subtotal per item.';
COMMENT ON TABLE billing_payments IS 'Pembayaran invoice ke gateway (VA, ewallet, dll.) dengan payload provider.';

COMMENT ON COLUMN billing_invoices.id IS 'Primary key invoice.';
COMMENT ON COLUMN billing_invoices.merchant_id IS 'Tenant ditagih.';
COMMENT ON COLUMN billing_invoices.subscription_id IS 'Langganan terkait jika ada.';
COMMENT ON COLUMN billing_invoices.invoice_no IS 'Nomor invoice unik.';
COMMENT ON COLUMN billing_invoices.status IS '1=draft; 2=terbit; 3=lunas; 4=batal; 5=lewat tempo; 6=gagal.';
COMMENT ON COLUMN billing_invoices.currency IS 'Mata uang.';
COMMENT ON COLUMN billing_invoices.subtotal_amount IS 'Subtotal sebelum pajak.';
COMMENT ON COLUMN billing_invoices.tax_amount IS 'Total pajak.';
COMMENT ON COLUMN billing_invoices.discount_amount IS 'Diskon.';
COMMENT ON COLUMN billing_invoices.total_amount IS 'Total tagihan.';
COMMENT ON COLUMN billing_invoices.paid_amount IS 'Sudah dibayar.';
COMMENT ON COLUMN billing_invoices.due_amount IS 'Sisa harus bayar.';
COMMENT ON COLUMN billing_invoices.issue_date IS 'Tanggal terbit.';
COMMENT ON COLUMN billing_invoices.due_date IS 'Jatuh tempo.';
COMMENT ON COLUMN billing_invoices.paid_at IS 'Waktu lunas.';
COMMENT ON COLUMN billing_invoices.external_provider IS 'Gateway.';
COMMENT ON COLUMN billing_invoices.external_invoice_id IS 'ID invoice di provider.';
COMMENT ON COLUMN billing_invoices.metadata_json IS 'Metadata.';
COMMENT ON COLUMN billing_invoices.created_at IS 'Waktu pembuatan.';
COMMENT ON COLUMN billing_invoices.updated_at IS 'Waktu pembaruan.';
COMMENT ON COLUMN billing_invoices.deleted_at IS 'Soft delete.';

COMMENT ON COLUMN billing_invoice_items.id IS 'Primary key baris.';
COMMENT ON COLUMN billing_invoice_items.merchant_id IS 'Tenant (denormalisasi RLS).';
COMMENT ON COLUMN billing_invoice_items.invoice_id IS 'Header invoice.';
COMMENT ON COLUMN billing_invoice_items.feature_key IS 'Fitur yang ditagih jika relevan.';
COMMENT ON COLUMN billing_invoice_items.description IS 'Deskripsi baris.';
COMMENT ON COLUMN billing_invoice_items.quantity IS 'Kuantitas.';
COMMENT ON COLUMN billing_invoice_items.unit_amount IS 'Harga per unit.';
COMMENT ON COLUMN billing_invoice_items.subtotal_amount IS 'Subtotal baris.';
COMMENT ON COLUMN billing_invoice_items.tax_amount IS 'Pajak baris.';
COMMENT ON COLUMN billing_invoice_items.total_amount IS 'Total baris.';
COMMENT ON COLUMN billing_invoice_items.metadata_json IS 'Metadata.';
COMMENT ON COLUMN billing_invoice_items.created_at IS 'Waktu pembuatan.';
COMMENT ON COLUMN billing_invoice_items.updated_at IS 'Waktu pembaruan.';
COMMENT ON COLUMN billing_invoice_items.deleted_at IS 'Soft delete.';

COMMENT ON COLUMN billing_payments.id IS 'Primary key pembayaran.';
COMMENT ON COLUMN billing_payments.merchant_id IS 'Tenant.';
COMMENT ON COLUMN billing_payments.invoice_id IS 'Invoice yang dibayar.';
COMMENT ON COLUMN billing_payments.status IS '1=dimulai; 2=sukses; 3=gagal; 4=dibatalkan.';
COMMENT ON COLUMN billing_payments.payment_method IS 'Metode (VA, ewallet, kartu, ...).';
COMMENT ON COLUMN billing_payments.provider IS 'Nama gateway.';
COMMENT ON COLUMN billing_payments.amount IS 'Jumlah dibayar.';
COMMENT ON COLUMN billing_payments.currency IS 'Mata uang.';
COMMENT ON COLUMN billing_payments.paid_at IS 'Waktu sukses bayar.';
COMMENT ON COLUMN billing_payments.external_payment_id IS 'ID transaksi provider.';
COMMENT ON COLUMN billing_payments.external_reference IS 'Referensi tambahan.';
COMMENT ON COLUMN billing_payments.request_payload IS 'Request ke provider (JSON).';
COMMENT ON COLUMN billing_payments.response_payload IS 'Respons provider (JSON).';
COMMENT ON COLUMN billing_payments.metadata_json IS 'Metadata.';
COMMENT ON COLUMN billing_payments.created_at IS 'Waktu pembuatan.';
COMMENT ON COLUMN billing_payments.updated_at IS 'Waktu pembaruan.';
COMMENT ON COLUMN billing_payments.deleted_at IS 'Soft delete.';

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

