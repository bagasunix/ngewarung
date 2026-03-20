# Strategi Bisnis: Paket Free / Pro / Enterprise & Diferensiasi Produk

Dokumen ini merangkum **kebijakan tier**, **batasan bisnis**, **alur pengguna**, dan **posisi vs kompetitor** (mis. Stroberi Kasir) agar konsisten antara produk, pricing, dan implementasi teknis (`billing_*`, `merchant_entitlements`, `outlets`).

**Tautan terkait:** [PRD_POS_UMKM.md](./PRD_POS_UMKM.md), [DATABASE_OVERVIEW.md](./DATABASE_OVERVIEW.md) (§5 billing), [BILLING_SEED_AND_GATE_QUERIES.sql](./BILLING_SEED_AND_GATE_QUERIES.sql).

---

## 1) Ringkasan eksekutif

| Tier | Inti nilai | Batasan kunci (contoh kebijakan) |
|------|------------|----------------------------------|
| **Free** | Mulai jualan cepat dengan satu titik operasi | **Tidak dapat menambah cabang/outlet baru** (hanya 1 outlet aktif) |
| **Pro** | Bisnis berkembang — multi-cabang & operasi terukur | Multi-outlet sesuai limit paket; fitur lanjutan non-enterprise |
| **Enterprise** | Kontrol, integrasi, dan skala organisasi | API, audit menyeluruh, merger data, SLA (sesuai kontrak) |

**Aturan emas Free:** pembatasan utama adalah **struktur organisasi (cabang)**, bukan sekadar “fitur kasir dipotong” tanpa narasi — sehingga mudah dijelaskan di UI dan paywall.

---

## 2) Matriks tier (dimensi produk)

| Dimensi | Free | Pro | Enterprise |
|---------|------|-----|------------|
| **Jumlah cabang / outlet** | **1** (tidak bisa buka cabang tambahan) | Multi-outlet (sesuai `feature_key` / limit, mis. `outlet_count`) | Multi-outlet + kebijakan lanjutan (wilayah, approval — opsional roadmap) |
| **POS & stok** | Inti: transaksi + stok dasar | + Varian, modifier, laporan per cabang | + SOP, audit, integrasi |
| **Harga pusat vs cabang** | Bisa disederhanakan (satu outlet) atau sama dengan Pro | **Dukung penuh** (`price_mode`, `is_price_central`) | Sama + kebijakan harga kompleks jika diperlukan |
| **Laporan** | Harian/mingguan sederhana; export terbatas | Per cabang + gabungan; periode lebih panjang | Lengkap + export untuk akuntan; retensi data sesuai paket |
| **Perangkat / kasir** | Kebijakan produk: mis. 1–2 device (anti-abuse) | Lebih banyak role & perangkat | Banyak user, RBAC penuh |
| **Offline-first** | Nilai diferensiasi — disarankan jadi core | Ya | Ya + monitoring readiness |
| **Integrasi** | Minimal / tidak | Pembayaran, WA struk (opsional) | API, webhook, merger |
| **Support** | Self-serve + dokumentasi | Email/chat prioritas | SLA, onboarding dibantu |

> Angka limit konkret (mis. Pro = 5 cabang) ditetapkan di **katalog billing** (`billing_plan_features.limit_value`) dan dicek di aplikasi (query gate).

---

## 3) Isi per tier (supaya tidak “mirip Stroberi tanpa identitas”)

### 3.1 Free — retensi & onboarding

- **Satu merchant + satu outlet** (selaras konsep: registrasi = induk/pusat operasi, bukan outlet tanpa induk).
- POS + katalog + stok dasar + laporan ringkas.
- **Offline-first** (jika menjadi pilar teknologi): status sinkron, antrian op — ini diferensiator kuat vs banyak POS cloud murni.
- Export bisa dibatasi (mis. CSV bulan berjalan saja) untuk mendorong upgrade.
- Support: dokumentasi + komunitas.

### 3.2 Pro — monetisasi utama

- **Multi-outlet** + **harga mengikuti pusat atau custom per cabang** (sesuai skema DB).
- Laporan gabungan & per cabang; role (kasir, admin cabang, owner).
- Integrasi pembayaran / notifikasi (mis. kirim struk via WhatsApp).
- Audit dasar (opsional).

### 3.3 Enterprise — margin & lock-in

- **Audit trail lengkap** (`audit_log`), export untuk akuntan.
- API / webhook; environment terpisah jika diperlukan.
- **Merger / konsolidasi data** antar tenant atau outlet (`merge_*`) — operasi privileged.
- Onboarding dibantu, SLA — sesuai kontrak.

---

## 4) Alur aplikasi (flow pengguna)

1. **Onboarding:** daftar → sistem membuat **1 merchant + 1 outlet** → wizard stok singkat → **transaksi pertama** (aha moment).
2. **Gate cabang:** pengguna menekan “Tambah cabang” → **paywall Pro** dengan pesan manfaat: *laporan gabungan, satu harga pusat, kontrol stok antar toko*.
3. **Gate fitur:** setiap fitur premium punya **satu kalimat manfaat** + contoh use case (bukan sekadar tabel fitur).
4. **Upgrade:** trial Pro (opsional 7–14 hari) → pembayaran → **entitlement** aktif (`merchant_subscriptions` + `merchant_entitlements`).
5. **Downgrade Free dengan >1 cabang:** wajib didesain: pengguna **memilih cabang yang tetap aktif**, cabang lain **dinonaktifkan / diarsipkan** (jangan hapus data secara diam-diam). Dokumentasikan di PRD dan komunikasi ke user.

---

## 5) Diferensiasi vs Stroberi Kasir (posisi strategis)

Stroberi = POS + inventory yang sudah dikenal pasar. **Posisi Ngewarung** bisa dibangun dari kombinasi berikut (pilih **2–3 pilar** untuk konsistensi marketing + produk):

| Pilar | Kenapa beda |
|-------|-------------|
| **Offline-first + sync** | Pain point lapangan (sinyal lemah); transparansi status antrian sinkronisasi. |
| **Multi-cabang** | Bukan sekadar “banyak toko”, tapi **harga pusat + override per cabang** + stok yang konsisten. |
| **Paket Free yang jelas** | **1 outlet, tidak bisa tambah cabang** — mudah dipahami; upgrade path ke Pro terukur. |
| **Kepercayaan & skala** | RBAC, audit log — untuk yang naik ke Enterprise. |
| **Saluran Indonesia** | WhatsApp (struk, reminder stok) sebagai add-on atau bagian Pro. |
| **Operasi data** | Merger/konsolidasi tenant — jarang di POS UMKM biasa. |

**Narasi produk (contoh):** *“POS yang mengerti cabang dan harga pusat — jalan offline, operasi jelas.”*

---

## 6) Pemetaan ke implementasi (teknis)

| Konsep bisnis | Artefak DB / perilaku |
|---------------|----------------------|
| Plan Free / Pro / Enterprise | `billing_plans`, `billing_plan_prices`, `billing_plan_features` |
| Langganan merchant | `merchant_subscriptions` |
| Override khusus | `merchant_feature_overrides` |
| Gate cepat di API | `merchant_entitlements` + query usage (mis. `COUNT(outlets)` vs `limit_value` untuk `outlet_count`) |
| Blok tambah cabang (Free) | Cek entitlement sebelum `INSERT` ke `outlets` |
| Harga pusat vs cabang | `outlets.price_mode`, `outlets.is_price_central`, `product_variant_prices` |

---

## 7) Checklist saat mengubah tier atau harga

- [ ] Update seed / katalog plan di SQL atau admin internal.
- [ ] Update copy paywall & onboarding.
- [ ] Uji gate: create outlet, export, API (sesuai tier).
- [ ] Dokumentasikan kebijakan downgrade (arsip cabang).
- [ ] Sinkronkan dokumen ini dengan [PRD_POS_UMKM.md](./PRD_POS_UMKM.md) jika KPI/MVP berubah.

---

*Dokumen ini bersifat kebijakan produk; limit numerik dan nama plan final mengikuti keputusan bisnis dan konfigurasi di `billing_*`.*
