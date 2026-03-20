# Dokumentasi Produk & Teknis — Ngewarung POS (v2)

Dokumen ini menjadi **titik masuk** untuk memahami rancangan produk, basis data multi-tenant, keamanan (RLS), billing, dan operasi merger. Skema aktual ada di folder `migration/` (urutan `000001` … `000085`).

**Apakah semua rancangan dari diskusi sudah masuk dokumen?** Lihat **[RANCANGAN_INDEKS_LENGKAP.md](./RANCANGAN_INDEKS_LENGKAP.md)** (peta cakupan + apa yang belum / opsional).

---

## 1) Mulai dari mana?

| Prioritas | Dokumen | Isi singkat |
|-----------|---------|-------------|
| **Meta** | [RANCANGAN_INDEKS_LENGKAP.md](./RANCANGAN_INDEKS_LENGKAP.md) | Checklist: topik vs file; apa yang belum dijadikan dokumen |
| **Wajib** | [DATABASE_OVERVIEW.md](./DATABASE_OVERVIEW.md) | Konsep tenant/cabang, pricing pusat vs cabang, billing & entitlement, readiness, offline sync, diagram ringkas |
| **Wajib** | [DATABASE_SCHEMA_CATALOG.md](./DATABASE_SCHEMA_CATALOG.md) | Katalog tabel per domain, relasi utama, file migrasi |
| **Wajib (ops)** | [TENANT_RLS_DOCUMENTATION.md](./TENANT_RLS_DOCUMENTATION.md) | Row Level Security, `SET LOCAL app.merchant_id`, daftar tabel ter-RLS, troubleshooting |
| **Produk** | [PRD_POS_UMKM.md](./PRD_POS_UMKM.md) | PRD: visi, MVP, KPI, NFR |
| **Strategi** | [POS_UMKM_STRATEGI_PRODUK_DAN_ROADMAP.md](./POS_UMKM_STRATEGI_PRODUK_DAN_ROADMAP.md) | Analisis pasar, 15 fitur, roadmap 12 bulan |
| **Tier & diferensiasi** | [BUSINESS_TIER_AND_DIFFERENTIATION.md](./BUSINESS_TIER_AND_DIFFERENTIATION.md) | Free/Pro/Enterprise, flow gate cabang, beda vs Stroberi, mapping ke billing DB |
| **Referensi kompetitor** | [PRODUCT_ANALYSIS_STROBERI_KASIR.md](./PRODUCT_ANALYSIS_STROBERI_KASIR.md) | Analisis Stroberi Kasir (konteks) |
| **Arsitektur backend** | [BACKEND_ARCHITECTURE_POS_UMKM.md](./BACKEND_ARCHITECTURE_POS_UMKM.md) | Ringkasan + link ke diagram & sync (isi diperluas di kode) |
| **Merger** | [MERGE_TENANT_OUTLET_PLAYBOOK.md](./MERGE_TENANT_OUTLET_PLAYBOOK.md) | Alur merge tenant/outlet, scope, keamanan |
| **Contoh data** | [SEEDDATA_EXAMPLE_1TENANT.sql](./SEEDDATA_EXAMPLE_1TENANT.sql) | Seed 1 merchant (konsisten stok/transaksi) |
| **Billing** | [BILLING_SEED_AND_GATE_QUERIES.sql](./BILLING_SEED_AND_GATE_QUERIES.sql) | Seed katalog plan + contoh query *gate* fitur |

---

## 2) Konsep inti (satu paragraf)

**Satu akun bisnis = satu `merchants` (induk/pusat).** Cabang = `outlets` dengan `merchant_id`. Isolasi data antar tenant memakai **Postgres RLS** + `app.merchant_id`. **Harga** bisa per-cabang (`price_mode`) atau mengikuti **outlet pusat harga** (`is_price_central`). **Langganan** (`billing_*`, `merchant_subscriptions`, `merchant_entitlements`) mengatur batas fitur (mis. jumlah cabang). **Audit** di `audit_log`. **Merge** antar tenant/outlet di `merge_*` (eksekusi privileged, bukan flow kasir biasa).

---

## 3) Folder & artefak terkait

| Lokasi | Keterangan |
|--------|------------|
| `migration/*.up.sql` / `*.down.sql` | Sumber kebenaran skema Postgres |
| `docs/*.md` | Dokumen manusia (overview, RLS, merger, PRD) |
| `docs/*.sql` | Skrip contoh (seed / gate), bukan migrasi |

---

## 4) Menjaga dokumen tetap akurat

- Setelah menambah tabel/kolom baru: update **DATABASE_SCHEMA_CATALOG.md** dan (jika mengubah perilaku bisnis) **DATABASE_OVERVIEW.md**.
- Setelah mengubah RLS/policy: update **TENANT_RLS_DOCUMENTATION.md**.
- Merge / billing baru: update playbook atau subbagian overview.

---

*Branch: `v2` — skema dirancang untuk aplikasi enterprise multi-tenant + web admin + mobile offline-first.*
