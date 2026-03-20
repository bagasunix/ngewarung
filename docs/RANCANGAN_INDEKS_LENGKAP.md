# Peta Rancangan Lengkap — Apa Sudah Terdokumentasi & Apa Belum

Dokumen ini menjawab: **“Apakah semua yang pernah kita bahas sudah masuk ke file?”** dengan checklist terhadap topik utama dari diskusi produk + teknis.

---

## 1) Sudah ada dokumen khusus (lengkap untuk referensi)

| Topik dari diskusi | File | Catatan |
|--------------------|------|---------|
| Analisis produk Stroberi Kasir | [PRODUCT_ANALYSIS_STROBERI_KASIR.md](./PRODUCT_ANALYSIS_STROBERI_KASIR.md) | Konteks kompetitor |
| Strategi POS UMKM, pain point, 15 fitur, roadmap 12 bln | [POS_UMKM_STRATEGI_PRODUK_DAN_ROADMAP.md](./POS_UMKM_STRATEGI_PRODUK_DAN_ROADMAP.md) | Fondasi produk |
| PRD (visi, persona, MVP, KPI, NFR, GTM, AC) | [PRD_POS_UMKM.md](./PRD_POS_UMKM.md) | Requirement terstruktur |
| **Tier bisnis** Free / Pro / Enterprise, diferensiasi, flow gate cabang | [BUSINESS_TIER_AND_DIFFERENTIATION.md](./BUSINESS_TIER_AND_DIFFERENTIATION.md) | Kebijakan paket & narasi vs Stroberi |
| **Konsep DB multi-tenant**, cabang, harga pusat, billing, offline, audit, merge (ringkas) | [DATABASE_OVERVIEW.md](./DATABASE_OVERVIEW.md) | Baca ini untuk “gambaran besar” |
| **Katalog tabel** per domain + nomor migrasi | [DATABASE_SCHEMA_CATALOG.md](./DATABASE_SCHEMA_CATALOG.md) | Referensi cepat |
| **RLS**, `app.merchant_id`, daftar tabel, merchant config keys, audit HTTP | [TENANT_RLS_DOCUMENTATION.md](./TENANT_RLS_DOCUMENTATION.md) | Wajib untuk implementasi API |
| **Merger** tenant/outlet — orchestration, scope, keamanan | [MERGE_TENANT_OUTLET_PLAYBOOK.md](./MERGE_TENANT_OUTLET_PLAYBOOK.md) | Bukan prosedur SQL detail |
| Arsitektur backend (ringkas + prinsip GORM/RLS/worker) | [BACKEND_ARCHITECTURE_POS_UMKM.md](./BACKEND_ARCHITECTURE_POS_UMKM.md) | Pointer, bukan desain mendalam |
| Seed 1 tenant + konsistensi data | [SEEDDATA_EXAMPLE_1TENANT.sql](./SEEDDATA_EXAMPLE_1TENANT.sql) | Contoh SQL |
| Billing seed + contoh query gate fitur | [BILLING_SEED_AND_GATE_QUERIES.sql](./BILLING_SEED_AND_GATE_QUERIES.sql) | Contoh SQL |
| Indeks semua dokumen | [README.md](./README.md) | Titik masuk |

**Skema Postgres** sebagai sumber kebenaran: folder `migration/` (`000001` … `000085`) — termasuk enums, tabel inti, enterprise, RLS, soft delete, billing, audit, merge.

---

## 2) Ter-cover di beberapa dokumen (tidak perlu file terpisah)

| Topik | Di mana |
|-------|---------|
| Multi-branch / B2B / varian harga | `DATABASE_OVERVIEW` + `DATABASE_SCHEMA_CATALOG` + migrasi |
| Web admin “didukung DB” | `DATABASE_OVERVIEW` §13 |
| Offline-first, `client_ops`, `outbox_events` | `DATABASE_OVERVIEW` §8; PRD/NFR di PRD |
| Monitoring readiness (`outlets.last_sync_*`, dll.) | `DATABASE_OVERVIEW` §9 |
| Konsep registrasi = merchant induk, cabang berbayar | `BUSINESS_TIER_AND_DIFFERENTIATION` + `DATABASE_OVERVIEW` |

---

## 3) Pernah dibahas / direncanakan — belum (atau belum lengkap) di repo

| Topik | Status | Saran |
|-------|--------|--------|
| **Arsitektur backend mendalam** (microservice breakdown, diagram alir, offline sync pseudocode lengkap, Kafka vs Redis, SLO detail, sequence diagram) | Hanya **ringkas** di `BACKEND_ARCHITECTURE_POS_UMKM.md`; detail besar pernah di obrolan, **belum** dijadikan satu dokumen panjang di `docs/` | Buat `BACKEND_ARCHITECTURE_DEEP_DIVE.md` saat mulai implementasi service, atau salin dari catatan internal |
| **Prosedur eksekusi merge** (urutan UPDATE per tabel, mapping SKU/customer conflict, SQL/checkpoint) | Playbook menjelaskan **orchestration & scope**; **bukan** runbook SQL step-by-step | Tambah sub-bab di playbook atau file `MERGE_EXECUTION_RUNBOOK.md` saat logic merge diimplementasi |
| **Perbandingan migrasi `main` vs `v2`** | Analisis pernah di chat; **tidak** ada file di `docs/` | Opsional: `MIGRATION_MAIN_VS_V2.md` jika masih relevan untuk tim |
| **Pengujian GORM + migrate** (path folder `migration/` vs `migrations/` di README root) | README project masih menyebut `migrations` — **inkonsistensi** kecil | Rapikan `README.md` root agar path sama dengan repo |

---

## 4) Kesimpulan singkat

- **Ya — bayangan produk + skema + keamanan + billing + tier + merger (konsep) sudah punya “rumah” di `docs/`** dan bisa dipelajari dari [README.md](./README.md) + [DATABASE_OVERVIEW.md](./DATABASE_OVERVIEW.md).
- **Belum “semua” dalam arti 1:1 teks obrolan:** khususnya **dokumentasi arsitektur backend yang sangat detail** dan **runbook eksekusi merge tingkat SQL** — itu sengaja menunggu implementasi atau bisa ditambahkan sebagai dokumen follow-up.

---

## 5) Urutan baca untuk “nggak lupa” (30 menit)

1. [README.md](./README.md)  
2. [BUSINESS_TIER_AND_DIFFERENTIATION.md](./BUSINESS_TIER_AND_DIFFERENTIATION.md)  
3. [DATABASE_OVERVIEW.md](./DATABASE_OVERVIEW.md)  
4. [TENANT_RLS_DOCUMENTATION.md](./TENANT_RLS_DOCUMENTATION.md) (skim policy)  
5. [PRD_POS_UMKM.md](./PRD_POS_UMKM.md) (bagian MVP & NFR sesuai kebutuhan)

---

*Update file ini ketika menambah dokumen besar baru (mis. deep-dive backend) atau menutup gap di §3.*
