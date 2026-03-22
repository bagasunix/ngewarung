-- Seed data example for 1 merchant (enterprise grade / tenant-aware)
-- Assumptions:
-- - All migrations are already applied.
-- - Nominal uang: kolom memakai NUMERIC(19,2) — literal bisa integer atau desimal (mis. 3500.00).
-- - RLS context is set via: SET LOCAL app.merchant_id = '<merchant_id>';
-- - Database is empty (or IDs don't collide).
-- Usage:
--   BEGIN;
--   SET LOCAL app.merchant_id = '<merchant_id>';
--   -- run inserts ...
--   COMMIT;

BEGIN;
SET LOCAL app.merchant_id = '11111111-1111-1111-1111-111111111111';

-- =====================================
-- MERCHANT (tenant)
-- =====================================
INSERT INTO merchants (id, name, email, phone, address, merchant_status, created_at, updated_at)
VALUES
  ('11111111-1111-1111-1111-111111111111', 'Toko Stroberi Demo', 'owner@stoberidemo.id', '+628111234567', 'Jl. Demo No. 1', 1, now(), now())
ON CONFLICT (id) DO NOTHING;

-- =====================================
-- USERS
-- =====================================
INSERT INTO users (id, phone, full_name, password_hash, created_at, updated_at)
VALUES
  ('22222222-2222-2222-2222-222222222222', '628111111111', 'Bu Owner Demo', NULL, now(), now()),
  ('22222222-2222-2222-2222-222222222223', '628122222222', 'Dewi Kasir Demo', NULL, now(), now())
ON CONFLICT (id) DO NOTHING;

-- =====================================
-- ROLES + USER ROLES
-- =====================================
INSERT INTO roles (id, merchant_id, name, deleted_at, is_deleted, created_at, updated_at)
VALUES
  ('33333333-3333-3333-3333-333333333333', '11111111-1111-1111-1111-111111111111', 'owner', NULL, FALSE, now(), now()),
  ('33333333-3333-3333-3333-333333333334', '11111111-1111-1111-1111-111111111111', 'cashier', NULL, FALSE, now(), now())
ON CONFLICT (id) DO NOTHING;

-- Audit login example
INSERT INTO user_logins (id, user_id, login_at, logout_at, ip_address, user_agent, device_info, created_at)
VALUES
  ('88888888-8888-8888-8888-888888888888', '22222222-2222-2222-2222-222222222223',
   '2026-03-01T08:00:00Z', '2026-03-01T16:00:00Z', '203.0.113.10', 'app', 'Android', now())
ON CONFLICT (id) DO NOTHING;

-- Units
INSERT INTO units (id, name, created_at, updated_at)
VALUES
  ('66666666-6666-6666-6666-666666666666', 'pcs', now(), now())
ON CONFLICT (id) DO NOTHING;

-- =====================================
-- OUTLET (branch/cabang)
-- =====================================
INSERT INTO outlets (
  id, merchant_id, owner_id, name, address,
  created_at, updated_at, deleted_at, is_deleted,
  is_price_central, price_mode
)
VALUES
  ('44444444-4444-4444-4444-444444444444', '11111111-1111-1111-1111-111111111111',
   '22222222-2222-2222-2222-222222222222', 'Outlet A - Warung Demo', 'Jl. Outlet A',
   now(), now(), NULL, FALSE,
   TRUE, 0)
ON CONFLICT (id) DO NOTHING;

INSERT INTO user_role_assignments (id, user_id, role_id, outlet_id, created_at, updated_at)
VALUES
  ('77777777-7777-7777-7777-777777777777', '22222222-2222-2222-2222-222222222223',
   '33333333-3333-3333-3333-333333333334', '44444444-4444-4444-4444-444444444444', now(), now())
ON CONFLICT (id) DO NOTHING;

-- =====================================
-- CATEGORIES + PRODUCTS
-- =====================================
INSERT INTO categories (id, outlet_id, name, created_at, updated_at, deleted_at, is_deleted)
VALUES
  ('55555555-5555-5555-5555-555555555555', '44444444-4444-4444-4444-444444444444', 'Makanan', now(), now(), NULL, FALSE)
ON CONFLICT (id) DO NOTHING;

-- products.price = NULL: harga jual lewat product_variant_prices (varian + outlet).
-- unit = teks (legacy/quick label); unit_id = FK ke units — selaras, lihat docs/PRODUCT_UNITS.md
INSERT INTO products (
  id, outlet_id, category_id,
  name, sku, price, unit, unit_id,
  stock, expiry_date, is_deleted, deleted_at,
  created_at, updated_at
)
VALUES
  ('77777777-7777-7777-7777-777777777779',
   '44444444-4444-4444-4444-444444444444',
   '55555555-5555-5555-5555-555555555555',
   'Indomie Goreng 1 Cup',
   'SKU-INDOMIE-001',
   NULL,
   'pcs',
   '66666666-6666-6666-6666-666666666666',
   99,
   '2026-06-01',
   FALSE,
   NULL,
   now(), now())
ON CONFLICT (id) DO NOTHING;

-- =====================================
-- PRODUCT VARIANTS + PRICES + STOCKS
-- =====================================
INSERT INTO product_variants (id, product_id, name, sku, deleted_at, created_at, updated_at)
VALUES
  ('88888888-8888-8888-8888-888888888889',
   '77777777-7777-7777-7777-777777777779',
   'Regular',
   'SKU-INDOMIE-001-REG',
   NULL,
   now(), now())
ON CONFLICT (id) DO NOTHING;

INSERT INTO product_variant_prices (id, variant_id, outlet_id, price, deleted_at, created_at, updated_at)
VALUES
  ('99999999-9999-9999-9999-999999999990',
   '88888888-8888-8888-8888-888888888889',
   '44444444-4444-4444-4444-444444444444',
   3500.00,
   NULL,
   now(), now())
ON CONFLICT (id) DO NOTHING;

INSERT INTO product_variant_stocks (id, variant_id, outlet_id, quantity, updated_at, deleted_at)
VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '88888888-8888-8888-8888-888888888889',
   '44444444-4444-4444-4444-444444444444',
   99,
   now(),
   NULL)
ON CONFLICT (id) DO NOTHING;

-- =====================================
-- MODIFIERS (topping/add-on) + mapping
-- =====================================
INSERT INTO product_modifiers (id, merchant_id, name, price, created_at, updated_at, deleted_at, is_deleted)
VALUES
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
   '11111111-1111-1111-1111-111111111111',
   'Telur',
   3000.00,
   now(), now(), NULL, FALSE)
ON CONFLICT (id) DO NOTHING;

INSERT INTO product_modifier_items (id, product_id, modifier_id)
VALUES
  ('cccccccc-cccc-cccc-cccc-cccccccccccc',
   '77777777-7777-7777-7777-777777777779',
   'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb')
ON CONFLICT (id) DO NOTHING;

-- =====================================
-- SUPPLIER + PURCHASE ORDER (restock)
-- =====================================
INSERT INTO suppliers (id, merchant_id, name, contact_person, phone, address, created_at, updated_at, deleted_at, is_deleted)
VALUES
  ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   '11111111-1111-1111-1111-111111111111',
   'Supplier Demo',
   'Pak Supplier',
   '628700000001',
   'Jl. Supplier',
   now(), now(), NULL, FALSE)
ON CONFLICT (id) DO NOTHING;

INSERT INTO purchase_orders (id, merchant_id, supplier_id, outlet_id, order_date, purchase_status, deleted_at, is_deleted)
VALUES
  ('ffffffff-ffff-ffff-ffff-ffffffffffff',
   '11111111-1111-1111-1111-111111111111',
   'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   '44444444-4444-4444-4444-444444444444',
   '2026-03-01T07:00:00Z',
   2, -- received
   NULL, FALSE)
ON CONFLICT (id) DO NOTHING;

INSERT INTO purchase_order_items (id, purchase_order_id, variant_id, quantity, price)
VALUES
  ('01010101-0101-0101-0101-010101010101',
   'ffffffff-ffff-ffff-ffff-ffffffffffff',
   '88888888-8888-8888-8888-888888888889',
   10,
   3000.00)
ON CONFLICT (id) DO NOTHING;

-- ledger: purchase +10
INSERT INTO product_history (id, variant_id, outlet_id, movement_type, quantity, reference_id, note, created_at)
VALUES
  ('02020202-0202-0202-0202-020202020202',
   '88888888-8888-8888-8888-888888888889',
   '44444444-4444-4444-4444-444444444444',
   1, -- purchase
   10,
   'ffffffff-ffff-ffff-ffff-ffffffffffff',
   'PO received',
   '2026-03-01T07:10:00Z')
ON CONFLICT (id) DO NOTHING;

-- ledger: sale -1 (movement_type=2 indicates sale)
INSERT INTO product_history (id, variant_id, outlet_id, movement_type, quantity, reference_id, note, created_at)
VALUES
  ('02120212-0212-0212-0212-021202120212',
   '88888888-8888-8888-8888-888888888889',
   '44444444-4444-4444-4444-444444444444',
   2, -- sale
   1,
   '03030303-0303-0303-0303-030303030303',
   'Sale',
   '2026-03-02T12:05:00Z')
ON CONFLICT (id) DO NOTHING;

-- =====================================
-- CUSTOMERS + TAGIHAN (credit/invoice)
-- =====================================
INSERT INTO customers (id, outlet_id, phone, name, points_balance, last_transaction_at, deleted_at, is_deleted, created_at, updated_at)
VALUES
  ('dddddddd-dddd-dddd-dddd-dddddddddddd',
   '44444444-4444-4444-4444-444444444444',
   '628123450001',
   'Bapak Ahmad',
   50,
   now(),
   NULL, FALSE,
   now(), now())
ON CONFLICT (id) DO NOTHING;

INSERT INTO tagihan (
  id, outlet_id, customer_id, customer_name, customer_phone,
  amount, amount_paid, due_date, status, created_at, updated_at
)
VALUES
  ('08080808-0808-0808-0808-080808080808',
   '44444444-4444-4444-4444-444444444444',
   'dddddddd-dddd-dddd-dddd-dddddddddddd',
   'Bapak Ahmad',
   '628123450001',
   100000.00,
   50000.00,
   '2026-03-10',
   'PARTIAL',
   now(), now())
ON CONFLICT (id) DO NOTHING;

INSERT INTO tagihan_payments (id, tagihan_id, amount, paid_at, created_at)
VALUES
  ('09090909-0909-0909-0909-090909090909',
   '08080808-0808-0808-0808-080808080808',
   50000.00,
   '2026-03-02T15:00:00Z',
   now())
ON CONFLICT (id) DO NOTHING;

-- =====================================
-- TRANSACTIONS + ITEMS + MODIFIERS + PAYMENTS
-- =====================================
INSERT INTO transactions (id, outlet_id, cashier_id, customer_id, total, discount, status, occurred_at, created_at)
VALUES
  ('03030303-0303-0303-0303-030303030303',
   '44444444-4444-4444-4444-444444444444',
   '22222222-2222-2222-2222-222222222223',
   'dddddddd-dddd-dddd-dddd-dddddddddddd',
   6500.00, -- 3500 base + 3000 modifier/add-on (NUMERIC 19,2)
   0.00,
   'COMPLETED',
   '2026-03-02T12:00:00Z',
   now())
ON CONFLICT (id) DO NOTHING;

INSERT INTO transaction_items (
  id, transaction_id, product_id, variant_id, quantity, unit_price, subtotal,
  amount_bruto, discount_type, discount_value, discount_amount, tax_percent, tax_amount
)
VALUES
  ('04040404-0404-0404-0404-040404040404',
   '03030303-0303-0303-0303-030303030303',
   '77777777-7777-7777-7777-777777777779',
   '88888888-8888-8888-8888-888888888889',
   1,
   3500.00,
   3500.00,
   3500.00,
   0, 0.00, 0.00,
   0.00, 0.00)
ON CONFLICT (id) DO NOTHING;

-- selected modifier (Telur) on that transaction_item
INSERT INTO transaction_item_modifiers (id, transaction_item_id, modifier_id, price)
VALUES
  ('05050505-0505-0505-0505-050505050505',
   '04040404-0404-0404-0404-040404040404',
   'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
   3000.00)
ON CONFLICT (id) DO NOTHING;

-- payment (cash)
INSERT INTO payments (id, transaction_id, method, amount, external_ref, created_at)
VALUES
  ('06060606-0606-0606-0606-060606060606',
   '03030303-0303-0303-0303-030303030303',
   'cash',
   6500.00,
   NULL,
   now())
ON CONFLICT (id) DO NOTHING;

-- =====================================
-- EXPENSES + DAILY_SUMMARIES
-- =====================================
INSERT INTO expenses (id, outlet_id, amount, note, date, created_at)
VALUES
  ('07070707-0707-0707-0707-070707070707',
   '44444444-4444-4444-4444-444444444444',
   25000.00,
   'Beli plastik & serbet',
   '2026-03-02',
   now())
ON CONFLICT (id) DO NOTHING;

INSERT INTO daily_summaries (outlet_id, date, total_sales, total_expenses, transaction_count)
VALUES
  ('44444444-4444-4444-4444-444444444444', '2026-03-02', 6500.00, 25000.00, 1)
ON CONFLICT (outlet_id, date) DO NOTHING;

-- =====================================
-- OFFLINE SYNC IDEMPO TENCY + OUTBOX EVENTS
-- =====================================
INSERT INTO client_ops (op_id, outlet_id, op_type, result, first_seen_at)
VALUES
  ('0a0a0a0a-0a0a-0a0a-0a0a-0a0a0a0a0a0a',
   '44444444-4444-4444-4444-444444444444',
   'CREATE_TRANSACTION',
   '{}'::jsonb,
   now())
ON CONFLICT (op_id) DO NOTHING;

-- outbox event: mark published_at NULL so worker picks it up
INSERT INTO outbox_events (id, aggregate_id, event_type, payload, created_at, published_at, merchant_id)
VALUES
  (1001,
   '03030303-0303-0303-0303-030303030303',
   'TransactionCreated',
   '{"transaction_id":"03030303-0303-0303-0303-030303030303","outlet_id":"44444444-4444-4444-4444-444444444444"}'::jsonb,
   now(),
   NULL,
   '11111111-1111-1111-1111-111111111111')
ON CONFLICT (id) DO NOTHING;

-- =====================================
-- MERCHANT CONFIG
-- =====================================
INSERT INTO merchant_configs (id, merchant_id, config_key, value_json, value_encrypted, value_text, is_deleted, deleted_at, created_at, updated_at)
VALUES
  ('0b0b0b0b-0b0b-0b0b-0b0b-0b0b0b0b0b0b',
   '11111111-1111-1111-1111-111111111111',
   'ngewarung.jwt.signing_key',
   '{"alg":"HS256","kid":"kid-1"}'::jsonb,
   NULL,
   'secret-key-placeholder',
   FALSE,
   NULL,
   now(),
   now())
ON CONFLICT (id) DO NOTHING;

COMMIT;

