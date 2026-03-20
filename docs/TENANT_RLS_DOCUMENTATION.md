# Tenant Isolation Documentation (Postgres RLS)

**Lihat juga:** [README.md](./README.md) (indeks dokumen), [DATABASE_OVERVIEW.md](./DATABASE_OVERVIEW.md) (konsep tenant & pricing), [DATABASE_SCHEMA_CATALOG.md](./DATABASE_SCHEMA_CATALOG.md) (daftar tabel).

## 0) Overview
This document describes how the database layer enforces **multi-tenant isolation** using **Postgres Row Level Security (RLS)** for the POS product.

### Tenant model
- **Tenant (enterprise scope):** `merchants`
- **Branch/cabang scope:** `outlets` (each outlet belongs to a merchant)
- **Tenant isolation rule:** all reads/writes must be scoped to the active `merchant_id`.

RLS policies rely on a Postgres session setting:
- `SET LOCAL app.merchant_id = '<merchant_uuid>'`

> Backend must set `app.merchant_id` at the beginning of every request/DB transaction that touches tenant data.

---

## 1) What was implemented

### 1.1 Helper functions (RLS context)
The following helper functions are created to support policies:

1. `app_current_merchant_id()`  
   Reads `current_setting('app.merchant_id')` and converts it into UUID.

2. `app_outlet_belongs_to_current_merchant(_outlet_id UUID)`  
   Checks whether an outlet belongs to the active merchant.

3. `app_transaction_belongs_to_current_merchant(_transaction_id UUID)`  
   Checks whether a transaction belongs to the active merchant via `transactions.outlet_id -> outlets.merchant_id`.

4. `app_transaction_item_belongs_to_current_merchant(_transaction_item_id UUID)`  
   Checks whether a transaction item belongs to the active merchant via `transaction_items -> transactions -> outlets`.

5. Enterprise extensions:
   - `app_product_belongs_to_current_merchant(_product_id UUID)`
   - `app_product_variant_belongs_to_current_merchant(_variant_id UUID)`
   - `app_purchase_order_belongs_to_current_merchant(_purchase_order_id UUID)`

These are defined by migrations:
- `migration/000034_rls_helpers.*`
- `migration/000047_rls_helpers_extend.*`

> Implementation detail: some RLS policies were later updated to use direct `EXISTS (...)` joins (instead of calling helper functions) to avoid potential recursion under RLS when helpers query the same table being protected.

---

## 2) Required backend behavior (mandatory)

### 2.1 Set tenant context per request
At the beginning of each request/DB transaction, backend must execute:

```sql
SET LOCAL app.merchant_id = '<merchant_uuid>';
```

Recommended: execute it inside the same DB transaction you use for subsequent queries.

### 2.2 Source of `merchant_uuid`
`merchant_uuid` must come from authenticated context:
- user session claims, or
- `user_role_assignments -> roles.merchant_id`, or
- a server-side mapping of user permissions.

Never accept `merchant_id` directly from the client request body/querystring.

---

## 3) Tables with RLS enabled

The following tables have RLS enabled and policies restricting to the active merchant:

### 3.1 Base tenant-scoped tables (RLS via outlet)
- `outlets`
- `categories`
- `products`
- `customers`
- `transactions`
- `transaction_items`
- `payments`
- `expenses`
- `tagihan`
- `tagihan_payments`
- `daily_summaries`
- `client_ops` (offline sync idempotency)
- `merchant_configs` (tenant config store)
- `audit_log` (enterprise governance audit trail)
- `merchant_subscriptions`
- `merchant_feature_overrides`
- `billing_invoices`
- `billing_invoice_items`
- `billing_payments`
- `billing_usage_daily`
- `merchant_entitlements`

### 3.1b Event bus / outbox
- `outbox_events` (tenant-aware via `merchant_id`, RLS enabled)

### 3.2 Enterprise product/inventory/restocking tables
- `product_variants`
- `product_variant_prices`
- `product_variant_stocks`
- `product_modifiers`
- `product_modifier_items`
- `suppliers`
- `purchase_orders`
- `purchase_order_items`
- `product_history`
- `transaction_item_modifiers`

### 3.3 Governance & audit tables (enterprise)
- `merchants`
- `roles`
- `user_role_assignments`
- `user_logins`

---

## 4) Policy logic (short explanation)

For each table:
- `USING (...)` defines which rows are visible for SELECT.
- `WITH CHECK (...)` defines which rows are allowed for INSERT/UPDATE.

Most policies use one of:
- `app_outlet_belongs_to_current_merchant(outlet_id)` for outlet-scoped rows
- `app_transaction_item_belongs_to_current_merchant(transaction_item_id)` for indirect-scoped rows
- enterprise helpers for product/variant/PO-scoped rows

---

## 5) Example backend flow (Go/Fiber pseudocode)

```pseudo
func withMerchantContext(handler):
  merchantID = resolveMerchantIDFromAuthContext()
  dbTx = db.BeginTx()
  dbTx.Exec("SET LOCAL app.merchant_id = ?", merchantID)
  defer dbTx.Rollback()

  handler(dbTx)  // all queries under this tx are tenant-scoped by RLS

  dbTx.Commit()
```

---

## 6) Testing checklist (recommended)

### 6.1 Basic isolation test
1. Create:
   - `merchant_A`, `merchant_B`
   - `outlet_A` (merchant_A), `outlet_B` (merchant_B)
   - `product_A` in outlet_A
2. Set `app.merchant_id = merchant_A`:
   - SELECT products where id = product_A should return 1 row
   - SELECT products where id = product_B should return 0 rows
3. Swap `app.merchant_id` to merchant_B and repeat.

### 6.2 Sync endpoint test (offline batch)
For `POST /sync/batch`:
1. Attempt to submit an offline op that references an outlet/transaction from another merchant.
2. Expect rejection:
   - either no rows applied due to RLS filtering, or
   - explicit conflict/authorization error at the API layer.

---

## 7) Troubleshooting

### 7.1 “Queries return empty” for a valid merchant
Common causes:
- Backend forgot to execute `SET LOCAL app.merchant_id`.
- Backend executed it in a different DB connection than the one used for queries.

Fix: ensure `SET LOCAL` is executed on the same DB transaction/connection as subsequent queries.

### 7.2 Worker jobs behave differently than API
If you process outbox events / background tasks:
- Ensure the worker connects using the correct database role/permissions.
- Decide whether the worker should:
  - set `app.merchant_id` per event/tenant, or
  - use a controlled privileged role with `BYPASSRLS` (if you choose this route).

---

## 8) Migration reference (for maintainers)

Core migrations:
- `000034_rls_helpers.*`
- `000047_rls_helpers_extend.*`

RLS migrations:
- `000035_rls_outlets.*`
- `000036_rls_categories.*`
- `000037_rls_products.*`
- `000038_rls_customers.*`
- `000039_rls_transactions.*`
- `000040_rls_transaction_items.*`
- `000041_rls_payments.*`
- `000042_rls_expenses.*`
- `000043_rls_tagihan.*`
- `000044_rls_tagihan_payments.*`
- `000045_rls_daily_summaries.*`
- `000046_rls_client_ops.*`
- `000063_outbox_events_add_merchant_id_and_rls.*`

Enterprise RLS:
- `000048_rls_product_variants.*`
- `000049_rls_product_variant_prices.*`
- `000050_rls_product_variant_stocks.*`
- `000051_rls_product_modifiers.*`
- `000052_rls_product_modifier_items.*`
- `000053_rls_suppliers.*`
- `000054_rls_purchase_orders.*`
- `000055_rls_purchase_order_items.*`
- `000056_rls_product_history.*`
- `000057_rls_transaction_item_modifiers.*`

Governance RLS:
- `000058_rls_helpers_user_mgmt.*`
- `000059_rls_merchants.*`
- `000060_rls_roles.*`
- `000061_rls_user_role_assignments.*`
- `000062_rls_user_logins.*`

Tenant config RLS:
- `000078_rls_merchant_configs.*`

Billing/subscription RLS:
- `000082_billing_subscriptions.*`
- `000083_billing_invoices_and_payments.*`
- `000084_billing_usage_and_entitlements.*`

---
## 10) Audit Log

Tabel `audit_log` digunakan untuk menyimpan kejadian penting (siapa melakukan apa, kapan, pada entity apa).

Relasi tenant:
- `audit_log.merchant_id` FK ke `merchants`.
- `audit_log.outlet_id` opsional untuk konteks yang lebih spesifik.

RLS:
- diaktifkan dan diproteksi dengan policy `audit_log_by_merchant` sehingga hanya data milik merchant aktif yang terlihat.

## 10.1 HTTP Context (optional)
Untuk audit yang berasal dari request HTTP, sistem dapat mengisi kolom:
- `method` (HTTP method)
- `headers` (serialized headers)
- `url`
- `status_code`
- `request` (payload/body ringkas atau full sesuai kebijakan)
- `response` (payload ringkas atau full sesuai kebijakan)
- `ip_address`
- `user_agent`

Semua kolom ini bersifat opsional (nullable) supaya audit juga bisa dibuat dari background job/worker.

---

## 9) Merchant Config Key Naming Convention

Konvensi ini untuk memudahkan management konfigurasi per tenant (JWT keys, API keys, webhook secrets, dsb.) yang tersimpan di `merchant_configs.config_key`.

### 9.1 Format
- Gunakan namespace berbasis namespace produk + module + purpose + field.
- Semua huruf kecil.
- Pisahkan antar bagian dengan titik `.`.

Contoh format:
- `<product>.<module>.<purpose>.<field>`

### 9.2 Contoh key

JWT / Auth:
- `ngewarung.jwt.signing_key`
- `ngewarung.jwt.issuer`
- `ngewarung.jwt.rotation_id`

3rd party (contoh QRIS):
- `ngewarung.qris.api_key`
- `ngewarung.qris.callback_secret`
- `ngewarung.qris.environment`

WhatsApp:
- `ngewarung.wa.phone_number_id`
- `ngewarung.wa.access_token`
- `ngewarung.wa.webhook_secret`

Webhook umum:
- `ngewarung.webhook.qris.secret`

