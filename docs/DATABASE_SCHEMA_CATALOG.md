# Katalog Skema Database — Referensi Cepat (v2)

Referensi ini mengelompokkan **tabel** ke domain bisnis, mencantumkan **file migrasi utama** (create table / modul), dan catatan singkat. Urutan angka mengikuti prefix file di `migration/`.

> **Sumber kebenaran:** file `*.up.sql`. Dokumen ini bisa menyimpang jika migrasi berubah — selalu cek migrasi terbaru.

---

## Indeks migrasi (create / modul besar)

| Rentang | Tema |
|---------|------|
| `000001` | Enums & extensions (`000001_enums_and_extensions`) |
| `000002`–`000015` | Tabel inti: users, outlets, katalog, transaksi, client_ops, outbox |
| `000016` | merchants |
| `000017` | outlets: tambah `merchant_id`, index pusat harga |
| `000018`–`000020` | roles, user_role_assignments, user_logins |
| `000021`–`000033` | units, varian, modifier, PO, history, transaction_item_modifiers |
| `000034`–`000066` | RLS helpers + policy per tabel |
| `000063` | outbox: `merchant_id` + RLS |
| `000077`–`000078` | merchant_configs + RLS |
| `000079` | audit_log |
| `000081`–`000084` | billing katalog, subscription, invoice/payment, usage & entitlements |
| `000085` | merge orchestration |

`000001_init_schema` = deprecated / no-op (lihat komentar di file).

---

## 1) Identitas & akses

| Tabel | Migrasi utama | Keterangan singkat |
|-------|---------------|---------------------|
| `users` | `000002_users` | Akun pengguna global. |
| `merchants` | `000016_merchants` | Tenant / induk bisnis. |
| `outlets` | `000003_outlets`, `000017_outlets_add_merchant_id` | Cabang; `merchant_id`, `price_mode`, `is_price_central`, readiness, soft delete. |
| `roles` | `000018_roles` | Peran per merchant. |
| `user_role_assignments` | `000019_user_role_assignments` | User ↔ role ↔ merchant. |
| `user_logins` | `000020_user_logins` | Jejak login (audit session). |

---

## 2) Master data & katalog

| Tabel | Migrasi utama | Keterangan |
|-------|---------------|------------|
| `categories` | `000004_categories` | Kategori produk per outlet. |
| `products` | `000005_products`, `000022_products_add_unit_id` | Produk; stok agregat bisa ada di level produk (selaras dengan varian). |
| `units` | `000021_units` | Satuan (pcs, kg, …). |
| `customers` | `000006_customers` | Pelanggan. |

---

## 3) Varian, harga, stok, modifier

| Tabel | Migrasi utama | Keterangan |
|-------|---------------|------------|
| `product_variants` | `000023_product_variants` | Varian SKU per produk. |
| `product_variant_prices` | `000024_product_variant_prices` | Harga per varian per konteks outlet (pusat vs cabang CUSTOM). |
| `product_variant_stocks` | `000025_product_variant_stocks` | Stok per varian per outlet. |
| `product_modifiers` | `000026_product_modifiers` | Grup modifier (topping, dll.). |
| `product_modifier_items` | `000027_product_modifier_items` | Item dalam grup modifier. |
| `product_history` | `000031_product_history` | Riwayat perubahan stok/harga/produk. |
| `transaction_item_modifiers` | `000033_transaction_item_modifiers` | Modifier terpasang pada baris transaksi. |

---

## 4) B2B / pembelian

| Tabel | Migrasi utama | Keterangan |
|-------|---------------|------------|
| `suppliers` | `000028_suppliers` | Pemasok. |
| `purchase_orders` | `000029_purchase_orders` | PO. |
| `purchase_order_items` | `000030_purchase_order_items` | Baris PO. |

---

## 5) POS & keuangan operasional

| Tabel | Migrasi utama | Keterangan |
|-------|---------------|------------|
| `transactions` | `000007_transactions` | Header penjualan. |
| `transaction_items` | `000008_transaction_items`, `000032_transaction_items_add_finance_columns` | Baris transaksi. |
| `payments` | `000009_payments` | Pembayaran terhadap transaksi. |
| `expenses` | `000010_expenses` | Pengeluaran. |
| `tagihan` | `000011_tagihan` | Piutang/tagihan. |
| `tagihan_payments` | `000012_tagihan_payments` | Pembayaran tagihan. |
| `daily_summaries` | `000013_daily_summaries` | Agregat harian per outlet. |

---

## 6) Sinkronisasi & event

| Tabel | Migrasi utama | Keterangan |
|-------|---------------|------------|
| `client_ops` | `000014_client_ops` | Idempotensi batch sync / op_id. |
| `outbox_events` | `000015_outbox_events`, `000063_outbox_events_add_merchant_id_and_rls` | Outbox; tenant-aware. |

---

## 7) Konfigurasi tenant

| Tabel | Migrasi utama | Keterangan |
|-------|---------------|------------|
| `merchant_configs` | `000077_merchant_configs` | Key-value/secret per merchant; RLS `000078`. |

---

## 8) Audit

| Tabel | Migrasi utama | Keterangan |
|-------|---------------|------------|
| `audit_log` | `000079_audit_log` | Audit dengan opsional HTTP context; RLS by merchant. |

---

## 9) Billing & langganan

| Tabel | Migrasi utama | Keterangan |
|-------|---------------|------------|
| `billing_plans` | `000081_billing_plans_catalog` | Katalog plan global. |
| `billing_plan_prices` | `000081` | Harga per mata uang & interval. |
| `billing_plan_features` | `000081` | Fitur + limit per plan (`feature_key`). |
| `merchant_subscriptions` | `000082_billing_subscriptions` | Langganan aktif merchant. |
| `merchant_feature_overrides` | `000082` | Override limit/fitur. |
| `billing_invoices` | `000083_billing_invoices_and_payments` | Invoice. |
| `billing_invoice_items` | `000083` | Baris invoice. |
| `billing_payments` | `000083` | Pembayaran invoice. |
| `billing_usage_daily` | `000084_billing_usage_and_entitlements` | Usage harian. |
| `merchant_entitlements` | `000084` | Cache entitlement efektif. |

---

## 10) Merger (orchestration)

| Tabel | Migrasi utama | Keterangan |
|-------|---------------|------------|
| `merge_requests` | `000085_merge_orchestration` | Request merge M→M atau outlet→merchant; status & dry-run. |
| `merge_checkpoints` | `000085` | Langkah eksekusi (checkpoint). |
| `merge_entity_mappings` | `000085` | Mapping ID sumber → target. |

**RLS:** tidak diaktifkan di migrasi 000085 — akses hanya untuk **service admin / privileged**.

---

## 11) RLS — file migrasi (referensi)

Policy dan helper tersebar di:

- `000034_rls_helpers` … `000066_rls_*` (per tabel + perbaikan rekursi)
- `000047_rls_helpers_extend`
- `000058`–`062` (user/merchant governance)
- `000063` (outbox)
- `000078` (merchant_configs)
- `000082`–`000084` (subscription, invoice, entitlements — policy di file yang sama)

Daftar lengkap tabel ter-RLS: **[TENANT_RLS_DOCUMENTATION.md](./TENANT_RLS_DOCUMENTATION.md)** §3.

---

## 12) Komentar di PostgreSQL (`COMMENT ON TABLE` / `COMMENT ON COLUMN`)

Setiap migrasi `CREATE TABLE` menyertakan:

- **`COMMENT ON TABLE`** — deskripsi tujuan tabel.
- **`COMMENT ON COLUMN`** — fungsi tiap kolom (terlihat di **pgAdmin**, **DBeaver**, `\d+` di psql, `pg_catalog.pg_description`).

Kolom yang ditambah migrasi terpisah pun punya komentar di file yang sama, mis. `outlets.merchant_id` (`000017`), `products.unit_id` (`000022`), kolom finance `transaction_items` (`000032`), `outbox_events.merchant_id` (`000063`).

- Bahasa: Indonesia (ringkas).
- Tabel `outbox_events`: komentar tabel diperbarui di `000063` setelah `merchant_id` dan RLS.

---

## 13) Artefak SQL di `docs/` (bukan migrasi)

| File | Gunanya |
|------|---------|
| `SEEDDATA_EXAMPLE_1TENANT.sql` | Contoh data 1 tenant + `SET LOCAL app.merchant_id` |
| `BILLING_SEED_AND_GATE_QUERIES.sql` | Seed katalog billing + query gate fitur |

---

*Update dokumen ini ketika menambah migrasi `000086+` (termasuk `COMMENT ON` untuk tabel baru).*
