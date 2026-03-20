# Product Requirement Document (PRD): POS UMKM Indonesia

**Product name:** Ngewarung (atau nama produk final)  
**Version:** 1.0  
**Status:** Draft  
**Last updated:** March 2026  
**Owner:** Product Manager  
**References:** [PRODUCT_ANALYSIS_STROBERI_KASIR.md](./PRODUCT_ANALYSIS_STROBERI_KASIR.md), [POS_UMKM_STRATEGI_PRODUK_DAN_ROADMAP.md](./POS_UMKM_STRATEGI_PRODUK_DAN_ROADMAP.md)

---

## 1. Product Vision

**Vision:** Menjadi POS pilihan utama UMKM Indonesia yang menggabungkan kasir, pembayaran digital, stok, piutang, dan laporan dalam satu aplikasi—ringan, bisa dipakai offline, dan siap dipakai untuk akses pembiayaan.

**Mission (1 kalimat):** Memungkinkan setiap warung dan toko kecil mencatat penjualan, mengelola stok dan piutang, menerima pembayaran digital, dan mendapatkan laporan yang bisa dipakai—tanpa ribet dan tanpa tergantung internet terus-menerus.

---

## 2. Target Users & Personas

### Persona 1: **Bu Siti — Pemilik Warung Kelontong (Owner-Operator)**

| Attribute | Detail |
|-----------|--------|
| **Demografi** | Perempuan, 35–50 tahun, pemilik warung di perumahan/perkampungan. |
| **Tech literacy** | Bisa pakai WhatsApp dan aplikasi sederhana; tidak nyaman dengan istilah akuntansi. |
| **Konteks** | Menjalankan warung sendirian atau dengan 1 orang bantu; banyak jual langganan (utang). |
| **Jobs to be done** | (1) Mencatat penjualan dan pengeluaran tanpa buku tulis. (2) Mengingat siapa yang utang dan kapan jatuh tempo. (3) Melihat “uang masuk vs keluar” dan “untung/rugi” dengan bahasa yang mudah. (4) Punya bukti transaksi/laporan untuk pinjam ke koperasi atau bank. |
| **Success looks like** | Setiap transaksi tercatat; piutang tidak lupa; laporan harian/mingguan bisa dibuka dalam &lt;1 menit; tidak perlu internet untuk kasir. |

---

### Persona 2: **Bapak Ahmad — Pemilik 2–3 Toko (Multi-Outlet Owner)**

| Attribute | Detail |
|-----------|--------|
| **Demografi** | Laki-laki, 30–45 tahun, punya 2–3 toko/warung (satu lokasi atau beda kelurahan). |
| **Tech literacy** | Menggunakan smartphone dan kadang laptop; terbiasa dengan aplikasi bisnis sederhana. |
| **Konteks** | Tidak selalu di toko; butuh cek performa dan stok dari mana saja; kadang ada kasir karyawan. |
| **Jobs to be done** | (1) Melihat ringkasan penjualan semua toko dalam satu tempat. (2) Memastikan stok dan kas per toko terkontrol. (3) Memberi akses kasir ke karyawan tanpa membuka akses laporan laba/hapus data. (4) Terima pembayaran QRIS/e-wallet dan rekonsiliasi otomatis. |
| **Success looks like** | Satu dashboard untuk semua outlet; transaksi dan stok tercatat per toko; pembayaran digital terintegrasi; ada audit siapa melakukan apa. |

---

### Persona 3: **Dewi — Kasir Toko (Staff Kasir)**

| Attribute | Detail |
|-----------|--------|
| **Demografi** | Perempuan/laki-laki, 18–35 tahun, karyawan toko/warung. |
| **Tech literacy** | Cukup; sehari-hari pakai HP untuk WA dan aplikasi. |
| **Konteks** | Hanya mengurus kasir dan stok; tidak boleh ubah harga/hapus produk/lihat laba penuh. |
| **Jobs to be done** | (1) Mencatat penjualan dengan cepat (tambah item, jumlah, selesai). (2) Menerima bayaran tunai dan/atau QRIS dalam satu transaksi. (3) Mengirim struk ke pelanggan lewat WA jika diminta. (4) Melihat stok produk yang tersedia (tanpa perlu lihat laporan keuangan). |
| **Success looks like** | Checkout cepat; tidak perlu login berulang; bisa kerja saat internet putus (sync nanti); tidak bisa mengubah pengaturan toko. |

---

## 3. Problem Statements & Success Metrics (KPIs)

### 3.1 Problem Statements

| # | Problem statement | Impact |
|---|--------------------|--------|
| P1 | Pemilik UMKM tidak punya pencatatan transaksi dan keuangan yang rapi, sehingga sulit dapat pinjaman atau lapor pajak. | Kehilangan akses modal dan risiko compliance. |
| P2 | Stok sering habis atau overstock karena tidak ada pengingat dan rekomendasi restock. | Rugi penjualan atau barang kedaluwarsa. |
| P3 | Piutang tidak terkelola—lupa menagih, tidak ada pengingat jatuh tempo. | Cash flow buruk dan piutang macet. |
| P4 | Pembayaran QRIS/e-wallet dicatat manual; rekonsiliasi merepotkan dan rawan selisih. | Waktu terbuang dan selisih kas. |
| P5 | Aplikasi kasir bergantung internet; di daerah sinyal lemah transaksi gagal atau tidak tersimpan. | Kehilangan penjualan dan data. |

### 3.2 Success Metrics (KPIs)

| KPI | Definition | Target (MVP-1) | Target (MVP-2) |
|-----|------------|----------------|----------------|
| **Activation rate** | % registrasi yang menyelesaikan onboarding dan ≥1 transaksi dalam 7 hari | ≥40% | ≥50% |
| **D7 / D30 retention** | % user aktif (≥1 transaksi) yang kembali aktif dalam 7 / 30 hari | D7 ≥35%, D30 ≥25% | D7 ≥45%, D30 ≥35% |
| **Time to first transaction** | Rata-rata waktu dari install sampai transaksi pertama | &lt;48 jam | &lt;24 jam |
| **Transactions per active merchant (TPAM)** | Rata-rata transaksi per merchant aktif per minggu | ≥10 | ≥15 |
| **Report export rate** | % merchant aktif yang export laporan (PDF/Excel/CSV) minimal 1x per bulan | ≥20% | ≥30% |
| **Payment digital share (MVP-2)** | % transaksi yang dibayar via QRIS/e-wallet (dari total transaksi) | — | ≥25% |
| **NPS** | Net Promoter Score (survey merchant aktif) | ≥20 | ≥30 |
| **Support ticket rate** | Tiket per 100 merchant aktif per bulan | &lt;15 | &lt;10 |

---

## 4. MVP Scope

### 4.1 Release Timeline (Gantt-Style)

| Release | Timeline | Theme | Key deliverables |
|---------|----------|--------|-------------------|
| **MVP-1** | Month 1–3 | Foundation: Kasir, Stok, Laporan, Tagihan | Auth, onboarding, core POS, produk & kategori, biaya, laporan dasar, stok & kedaluwarsa, tagihan & piutang terintegrasi |
| **MVP-2** | Month 4–6 | Growth: Pembayaran & Pelanggan | QRIS + split tender, struk & notifikasi WA, loyalty dasar, insight "Lalu Apa?", bahasa laporan sederhana |

### 4.2 MVP-1 Scope (Month 1–3)

| # | Feature | Priority | Owner (example) |
|---|---------|----------|------------------|
| M1.1 | Auth & onboarding (register, login, profil toko) | P0 | Backend + Mobile |
| M1.2 | Core POS (cart, transaksi, diskon, kurangi stok) | P0 | Backend + Mobile |
| M1.3 | Product catalog (CRUD produk, kategori) | P0 | Backend + Mobile |
| M1.4 | Pengeluaran (biaya) & laporan dasar (harian, P&L, kas) | P0 | Backend + Mobile |
| M1.5 | Stok & kedaluwarsa (field expiry, pengingat in-app) | P0 | Backend + Mobile |
| M1.6 | Tagihan & piutang (buat tagihan, catat bayar, update kas) | P0 | Backend + Mobile |
| M1.7 | Export laporan (PDF, Excel dasar) | P1 | Backend + Mobile |

### 4.3 MVP-2 Scope (Month 4–6)

| # | Feature | Priority | Owner (example) |
|---|---------|----------|------------------|
| M2.1 | Integrasi QRIS (tampil QR, callback, auto-complete transaksi) | P0 | Backend + Mobile + Payment partner |
| M2.2 | Split tender (tunai + QRIS dalam satu transaksi) | P0 | Backend + Mobile |
| M2.3 | Struk & notifikasi WA (struk ke pelanggan, pengingat piutang/kedaluwarsa) | P0 | Backend + WA provider |
| M2.4 | Loyalty dasar (poin per transaksi, redeem diskon) | P1 | Backend + Mobile |
| M2.5 | Laporan "Lalu Apa?" (rekomendasi rule-based) | P1 | Backend + Mobile |
| M2.6 | Bahasa laporan sederhana (label Indonesia non-akuntansi) | P1 | Mobile + Copy |

---

## 5. Detailed Feature Specs (MVP Items)

### 5.1 MVP-1: Auth & Onboarding (M1.1)

**Description:** Pendaftaran dan login dengan nomor HP + OTP; satu profil toko (nama, alamat). Onboarding wizard memandu: nama toko → tambah minimal 1 kategori → tambah minimal 1 produk → selesaikan 1 transaksi uji.

**User stories:**
- Sebagai pemilik toko, saya ingin mendaftar dengan nomor HP saja agar cepat mulai.
- Sebagai pemilik toko, saya ingin mengisi nama toko dan alamat sekali saja.
- Sebagai pemilik toko, saya ingin dipandu langkah demi langkah sampai transaksi pertama agar tidak bingung.

**Acceptance criteria:**
- [ ] User dapat register dengan nomor HP (format Indonesia); OTP dikirim dan divalidasi dalam 5 menit.
- [ ] Setelah OTP valid, user diminta nama lengkap dan nama toko, alamat toko (opsional).
- [ ] Onboarding wizard: (1) Set nama toko → (2) Tambah ≥1 kategori → (3) Tambah ≥1 produk → (4) Demo/transaksi uji. User bisa skip step 2–3 tapi tidak bisa “selesai onboarding” tanpa minimal 1 transaksi (boleh transaksi uji Rp 0).
- [ ] Waktu dari buka app (post-install) sampai selesai onboarding (termasuk 1 transaksi): **&lt;2 menit** untuk user yang mengisi minimal required (measurable: AC#1).
- [ ] Session tetap valid ≥7 hari (atau sampai logout); tidak logout otomatis tanpa alasan.

**Mock data example (profil toko):**
```json
{
  "outlet_id": "out_01HQXYZ",
  "name": "Warung Bu Siti",
  "address": "Jl. Merdeka No. 12, Kel. Sukamaju",
  "phone": "6281212345678",
  "created_at": "2026-03-01T10:00:00Z"
}
```

---

### 5.2 MVP-1: Core POS (M1.2)

**Description:** Layar kasir: tambah produk ke cart (dari katalog), ubah qty/harga, apply diskon transaksi, selesaikan transaksi. Stok berkurang otomatis. Transaksi tersimpan dengan metode bayar (tunai/default).

**User stories:**
- Sebagai kasir, saya ingin memilih produk dari daftar dan menambah ke keranjang agar cepat.
- Sebagai kasir, saya ingin mengubah jumlah dan harga (override) jika perlu.
- Sebagai kasir, saya ingin memberi diskon per transaksi dan menyelesaikan pembayaran.
- Sebagai sistem, stok produk harus berkurang otomatis saat transaksi selesai.

**Acceptance criteria:**
- [ ] Cart menampilkan item, qty, harga satuan, subtotal; total dan diskon di bawah.
- [ ] Transaksi selesai memerlukan minimal 1 item; metode bayar default: Tunai (nanti MVP-2: + QRIS).
- [ ] Setelah transaksi selesai: stok tiap product_id berkurang sesuai qty; transaksi tersimpan dengan id unik, timestamp, outlet_id.
- [ ] **Checkout (selesai transaksi) p95 latency &lt;200 ms** ketika dilayani dari local cache/offline queue (measurable: AC#2). Saat online, p95 &lt;500 ms.
- [ ] Transaksi yang dibuat offline masuk ke local queue dan tetap ada setelah app kill (measurable: AC#3).

**Mock data example (transaksi):**
```json
{
  "transaction_id": "txn_01HQXYZ",
  "outlet_id": "out_01HQXYZ",
  "items": [
    { "product_id": "prod_001", "name": "Indomie Goreng", "quantity": 2, "unit_price": 3500, "subtotal": 7000 }
  ],
  "subtotal": 7000,
  "discount": 0,
  "total": 7000,
  "payment_method": "cash",
  "status": "completed",
  "created_at": "2026-03-01T12:30:00Z"
}
```

---

### 5.3 MVP-1: Product Catalog (M1.3)

**Description:** CRUD produk dan kategori. Produk: nama, kategori, harga, satuan, stok awal, (opsional) tanggal kedaluwarsa. Kategori: nama saja.

**User stories:**
- Sebagai pemilik, saya ingin membuat kategori (mis. Makanan, Minuman) lalu menambah produk ke dalamnya.
- Sebagai pemilik, saya ingin mengedit dan menghapus produk; menghapus produk yang pernah dipakai di transaksi = soft delete (tetap ada di riwayat).

**Acceptance criteria:**
- [ ] Kategori: nama wajib; list kategori tampil di dropdown saat tambah/edit produk.
- [ ] Produk: nama, kategori_id, harga (number), satuan (pcs/liter/dll), stok (integer), expiry_date (optional date). Semua wajib kecuali expiry.
- [ ] Hapus produk: soft delete; produk tidak tampil di kasir tapi tetap di riwayat transaksi.
- [ ] List produk support search by name dan filter by kategori; minimal 100 produk per outlet tanpa degradasi performa.

**Mock data example (produk):**
```json
{
  "product_id": "prod_001",
  "outlet_id": "out_01HQXYZ",
  "category_id": "cat_01",
  "name": "Indomie Goreng",
  "sku": "IMG-001",
  "price": 3500,
  "unit": "pcs",
  "stock": 24,
  "expiry_date": "2026-06-01",
  "created_at": "2026-03-01T10:15:00Z"
}
```

---

### 5.4 MVP-1: Pengeluaran & Laporan Dasar (M1.4)

**Description:** Input pengeluaran (biaya) dengan nominal, tanggal, keterangan. Laporan: transaksi harian, uang masuk vs keluar, laba/rugi sederhana, sisa kas. Periode: hari, minggu, bulan.

**User stories:**
- Sebagai pemilik, saya ingin mencatat pengeluaran (beli stok, bayar listrik, dll) dengan tanggal dan catatan.
- Sebagai pemilik, saya ingin melihat laporan harian/mingguan/bulanan: penjualan, pengeluaran, laba/rugi, kas.

**Acceptance criteria:**
- [ ] Pengeluaran: amount (required), date (default today), note (optional). Tersimpan per outlet.
- [ ] Laporan harian: total penjualan (dari transaksi), total pengeluaran, laba/rugi (penjualan − pengeluaran), sisa kas (dapat dihitung dari opening + penjualan − pengeluaran; MVP boleh simplified).
- [ ] Laporan mingguan/bulanan: agregasi untuk periode yang dipilih; filter by date range.
- [ ] Semua label memakai bahasa sederhana: "Uang masuk", "Uang keluar", "Keuntungan/Rugi", "Sisa kas" (AC#4—bahasa sederhana untuk MVP-1 laporan dasar).

**Mock data example (pengeluaran):**
```json
{
  "expense_id": "exp_01HQXYZ",
  "outlet_id": "out_01HQXYZ",
  "amount": 150000,
  "date": "2026-03-01",
  "note": "Beli stok Indomie",
  "created_at": "2026-03-01T08:00:00Z"
}
```

---

### 5.5 MVP-1: Stok & Kedaluwarsa (M1.5)

**Description:** Field tanggal kedaluwarsa di produk. Pengingat in-app: produk yang stok di bawah threshold (configurable, default 5) dan produk yang kedaluwarsa dalam 7/14/30 hari.

**User stories:**
- Sebagai pemilik, saya ingin mengisi tanggal kedaluwarsa produk agar diingatkan sebelum kadaluarsa.
- Sebagai pemilik, saya ingin melihat daftar produk yang stok hampir habis dan yang akan kedaluwarsa.

**Acceptance criteria:**
- [ ] Produk punya field expiry_date (optional). Di list produk tampil badge "Akan kedaluwarsa" jika &lt;= 7 hari.
- [ ] Halaman/block "Pengingat": (1) Stok di bawah X (default 5, bisa diatur per produk atau global). (2) Kedaluwarsa dalam 7 hari, 14 hari, 30 hari.
- [ ] Pengingat bisa ditampilkan di dashboard/home dan/atau di menu Stok.

**Mock data example (alert):**
```json
{
  "alerts": [
    { "type": "low_stock", "product_id": "prod_001", "product_name": "Indomie Goreng", "current_stock": 3, "threshold": 5 },
    { "type": "expiring_soon", "product_id": "prod_002", "product_name": "Susu UHT", "expiry_date": "2026-03-05", "days_left": 4 }
  ]
}
```

---

### 5.6 MVP-1: Tagihan & Piutang (M1.6)

**Description:** Buat tagihan: nama pelanggan, nominal, jatuh tempo. Catat pembayaran (sebagian atau lunas): kurangi sisa piutang, tambah ke kas (pemasukan), update status tagihan. Daftar tagihan: belum lunas, riwayat bayar.

**User stories:**
- Sebagai pemilik, saya ingin membuat tagihan untuk pelanggan langganan (nama, nominal, jatuh tempo).
- Sebagai pemilik, saya ingin mencatat pembayaran dan otomatis mengurangi piutang serta menambah kas.

**Acceptance criteria:**
- [ ] Tagihan: customer_name, amount, due_date (required). Status: unpaid / partial / paid.
- [ ] Pembayaran: input amount bayar; jika amount &gt;= sisa piutang, status jadi paid; amount masuk ke "pemasukan" dan tampil di laporan kas/penjualan (satu sumber kebenaran).
- [ ] List tagihan: filter by status; kolom sisa piutang, riwayat pembayaran (tanggal, nominal).
- [ ] Tidak ada double entry: satu kali input bayar piutang = update tagihan + update kas/laporan.

**Mock data example (tagihan):**
```json
{
  "tagihan_id": "inv_01HQXYZ",
  "outlet_id": "out_01HQXYZ",
  "customer_name": "Bapak Ahmad",
  "customer_phone": "6281234567890",
  "amount": 150000,
  "amount_paid": 50000,
  "due_date": "2026-03-15",
  "status": "partial",
  "payments": [
    { "amount": 50000, "paid_at": "2026-03-02T14:00:00Z" }
  ]
}
```

---

### 5.7 MVP-1: Export Laporan (M1.7)

**Description:** Export laporan periode (harian/mingguan/bulanan) ke PDF dan Excel. Format Excel/CSV untuk laporan transaksi dan P&L harus punya mapping terdokumentasi ke format Accurate (chart of accounts / format impor).

**User stories:**
- Sebagai pemilik, saya ingin mengunduh laporan dalam PDF untuk arsip atau print.
- Sebagai pemilik, saya ingin mengunduh dalam Excel/CSV agar bisa impor ke software akuntansi.

**Acceptance criteria:**
- [ ] Export PDF: ringkasan periode (tanggal range), uang masuk, uang keluar, laba/rugi, sisa kas; optional list transaksi.
- [ ] Export Excel/CSV: minimal sheet/kolom (tanggal, keterangan, debit/kredit atau pemasukan/pengeluaran, saldo); **dokumentasi mapping ke format impor Accurate** (kolom yang sesuai) disediakan (measurable: AC#4).
- [ ] Export tersedia untuk range tanggal max 1 tahun; file generate dalam &lt;10 detik untuk 10k transaksi.

---

### 5.8 MVP-2: QRIS & Split Tender (M2.1, M2.2)

**Description:** Di kasir, pilih metode bayar: Tunai, QRIS, atau Split (tunai + QRIS). Jika QRIS: tampil QR dengan nominal = total cart; callback dari payment provider mengonfirmasi pembayaran → transaksi auto-complete. Split: input jumlah tunai; sisa via QRIS; rekonsiliasi otomatis.

**User stories:**
- Sebagai kasir, saya ingin menampilkan QRIS dengan nominal dari keranjang agar pelanggan bayar tanpa input manual.
- Sebagai kasir, saya ingin menerima sebagian tunai dan sebagian QRIS dalam satu transaksi.

**Acceptance criteria:**
- [ ] QRIS: nominal dari total cart; setelah pembayaran sukses (callback), transaksi otomatis completed dan stok berkurang.
- [ ] Split tender: input "Bayar tunai: Rp X"; sisa (total − X) via QRIS. Satu transaksi punya 2 payment_method entries (cash + qris) dan total match.
- [ ] Rekonsiliasi: laporan pemasukan bisa breakdown by payment method (tunai vs QRIS) per hari.

**Mock data example (payment split):**
```json
{
  "transaction_id": "txn_02",
  "payments": [
    { "method": "cash", "amount": 10000 },
    { "method": "qris", "amount": 25000, "reference": "QRIS-xxx" }
  ],
  "total": 35000
}
```

---

### 5.9 MVP-2: Struk & Notifikasi WA (M2.3)

**Description:** Opsional input nomor WA pelanggan saat/setelah transaksi. Jika ada dan opt-in: kirim struk ke WA setelah bayar. Pengingat piutang jatuh tempo dan produk kedaluwarsa bisa dikirim via WA (template compliant).

**User stories:**
- Sebagai kasir, saya ingin mengirim struk ke nomor WA pelanggan setelah transaksi.
- Sebagai pemilik, saya ingin menerima pengingat piutang dan stok kedaluwarsa lewat WA.

**Acceptance criteria:**
- [ ] Nomor WA pelanggan optional; **hanya kirim struk/notifikasi jika ada consent (checkbox/opt-in)** (measurable: AC#7—WA opt-in).
- [ ] Struk berisi: nama toko, tanggal, item, total, metode bayar. Format sesuai kebijakan WA Business (template).
- [ ] Pengingat piutang: "Tagihan [nama] jatuh tempo [tanggal]." Pengingat kedaluwarsa: "Ada N produk kedaluwarsa dalam 7 hari." Menggunakan template yang disetujui; tidak spam (max 1x per tagihan/per alert per hari).

---

### 5.10 MVP-2: Loyalty Dasar (M2.4)

**Description:** Setiap transaksi bisa dikaitkan ke pelanggan (nomor HP/nama). Poin per transaksi (mis. 1 poin per Rp 10.000) atau per item; redeem: setelah N poin dapat diskon (mis. Rp 5.000) di transaksi berikutnya.

**User stories:**
- Sebagai kasir, saya ingin memasukkan nomor HP pelanggan agar mereka dapat poin.
- Sebagai kasir, saya ingin menerapkan penukaran poin jadi diskon di transaksi saat ini.

**Acceptance criteria:**
- [ ] Di kasir: field opsional "Pelanggan" (HP atau nama). Jika ada, poin bertambah sesuai rule (config: poin per rupiah atau per transaksi).
- [ ] Redeem: pilih "Tukar poin" → pilih jumlah poin → diskon applied ke total (mis. 10 poin = Rp 5.000). Balance poin pelanggan berkurang.
- [ ] Data pelanggan: phone/name, total_poin, last_transaction_at; bisa dipakai untuk insight "Lalu Apa?" nanti.

**Mock data example (pelanggan + poin):**
```json
{
  "customer_id": "cust_01",
  "outlet_id": "out_01HQXYZ",
  "phone": "6281234567890",
  "name": "Bapak Ahmad",
  "points_balance": 25,
  "last_transaction_at": "2026-03-05T12:00:00Z"
}
```

---

### 5.11 MVP-2: Laporan "Lalu Apa?" & Bahasa Sederhana (M2.5, M2.6)

**Description:** Di halaman laporan, blok "Rekomendasi" menampilkan kalimat actionable: produk kedaluwarsa dalam 7 hari, piutang tertunggak, top 5 produk laris. Rule-based (belum ML). Semua label laporan memakai istilah Indonesia sehari-hari (Uang masuk, Uang keluar, Keuntungan, Barang laris).

**User stories:**
- Sebagai pemilik, saya ingin melihat rekomendasi singkat: apa yang harus saya lakukan berdasarkan data.
- Sebagai pemilik, saya tidak ingin melihat istilah seperti "revenue" atau "COGS"; cukup "Uang masuk", "Keuntungan".

**Acceptance criteria:**
- [ ] Rekomendasi: minimal 3 jenis—(1) produk kedaluwarsa dalam 7 hari, (2) piutang tertunggak (mis. &gt;7 hari lewat jatuh tempo), (3) top 5 produk laris (by quantity atau revenue). Update setiap kali laporan dibuka (period sesuai filter).
- [ ] Semua label di seluruh laporan dan onboarding memakai istilah sederhana; tidak ada "revenue", "COGS", "accrual" di UI (AC#4 extended).

---

## 6. Non-Functional Requirements

### 6.1 Offline Behavior

| Requirement | Detail |
|-------------|--------|
| **Offline queue** | Transaksi (create), update stok, tambah pengeluaran, dan catat bayar tagihan dapat dilakukan tanpa jaringan. Data disimpan di local DB (e.g. SQLite). |
| **Persistence on app kill** | **Offline queue tetap ada setelah app di-force quit atau crash** (measurable: AC#3). Queue disimpan ke disk sebelum respond ke UI. |
| **Sync when online** | Saat koneksi tersedia, client mengirim pending operations ke server dengan idempotency key. Konflik stok: server wins (server decrement adalah sumber kebenaran). |
| **Conflict resolution** | Transaksi duplicate (same idempotency key) diabaikan. Stok: server memakai nilai setelah decrement terakhir yang sukses. |

### 6.2 Latency & Performance

| Metric | Target | Scope |
|--------|--------|--------|
| **Checkout (complete transaction) p95** | **&lt;200 ms** when served from local cache / offline queue (measurable: AC#2). | Mobile client. |
| **Checkout p95 (online)** | &lt;500 ms | Request ke backend. |
| **Report load (daily summary)** | p95 &lt;1 s | Backend. |
| **Report export (PDF/Excel)** | Generate &lt;10 s for up to 10k transactions | Backend. |
| **List products (100 items)** | p95 &lt;300 ms | Mobile + API. |

### 6.3 Availability

| Metric | Target |
|--------|--------|
| **API availability** | 99.5% (excluding planned maintenance). |
| **Planned maintenance** | Max 2 jam per bulan; dijadwalkan di luar jam sibuk (e.g. dini hari WIB). |

### 6.4 Security

| Requirement | Detail |
|-------------|--------|
| **Data in transit** | Semua API dan sync memakai TLS 1.2+. |
| **Data at rest** | **Sensitive data (PII, transaksi) di server di-enkrypt at rest** (measurable: AC#5). Database encryption atau volume encryption. |
| **Authentication** | OTP untuk login/register; session token (JWT atau opaque) dengan expiry; refresh flow. |
| **Authorization** | Semua API filter by outlet_id + user_id; tidak ada akses cross-tenant. |
| **Sensitive fields** | Nomor HP disimpan; tidak log full OTP atau token di plain text. |

---

## 7. Compliance & Privacy Checklist

| # | Item | Status / Requirement |
|---|------|----------------------|
| 1 | **Data encryption** | **Data at rest:** encryption for DB/volume (AC#5). **Data in transit:** TLS 1.2+. |
| 2 | **WA opt-in** | **Struk dan notifikasi WA hanya dikirim jika user memberi consent** (checkbox/opt-in di setelan atau saat input nomor WA) (AC#7). Simpan consent + timestamp. |
| 3 | **PCI stance** | Kami **tidak menyimpan kartu kredit/debit**; pembayaran kartu (jika ada nanti) via redirect ke payment page atau tokenization oleh partner. **POS scope MVP: tunai + QRIS only** → no card data; dokumentasi "we do not store, process, or transmit cardholder data" untuk PCI scope. |
| 4 | **Privacy policy** | Kebijakan privasi tersedia (link di app dan saat daftar); jelaskan data yang dikumpulkan (HP, nama, transaksi, stok), tujuan, penyimpanan, hak akses/hapus. |
| 5 | **Data retention** | Retensi transaksi dan laporan sesuai kebutuhan bisnis dan pajak (min 5 tahun untuk data keuangan jika diwajibkan); dokumentasi retention policy. |
| 6 | **Right to delete** | User dapat request hapus akun; proses: anonymize atau delete PII dan data toko dalam 30 hari; transaksi dapat di-anonymize untuk keperluan agregat/audit. |

---

## 8. Go-to-Market: Pilot Plan

### 8.1 Pilot Scope

| Parameter | Target |
|-----------|--------|
| **Cohort** | 50–200 merchant (outlets) dalam 3 bulan pertama pasca MVP-1. |
| **Segment** | Warung kelontong, toko kecil, small F&B (kaki lima / warung makan) di 1–2 kota (e.g. Jabodetabek + satu kota tier-2). |
| **Channel** | Direct (tim lapangan), partner (koperasi/komunitas UMKM), dan organik (Play Store + konten). |

### 8.2 Activation Criteria (Definition of "Activated")

Merchant dianggap **activated** jika memenuhi **semua** dalam 7 hari sejak registrasi:

1. Profil toko lengkap (nama toko, minimal nama pemilik).
2. Minimal **1 kategori** dan **5 produk** terdaftar.
3. Minimal **3 transaksi** (boleh termasuk transaksi uji).
4. Minimal **1 pengeluaran** tercatat **atau** **1 tagihan** dibuat (opsional tapi dianjurkan).

Target pilot: **≥40%** dari merchant yang daftar mencapai status activated dalam 7 hari.

### 8.3 Onboarding Checklist (In-App + Tim)

| Step | Action | Owner |
|------|--------|--------|
| 1 | Install app; daftar dengan nomor HP; verifikasi OTP. | User |
| 2 | Isi nama toko, alamat (opsional). | User |
| 3 | Tambah minimal 1 kategori (contoh: Makanan). | User |
| 4 | Tambah minimal 5 produk (nama, harga, stok). | User |
| 5 | Selesaikan 1 transaksi (boleh Rp 0 untuk demo). | User |
| 6 | (Opsional) Catat 1 pengeluaran atau buat 1 tagihan. | User |
| 7 | Lihat laporan harian sekali. | User |
| 8 | (Jika pilot dengan tim) Tim lapangan verifikasi toko dan bantu isi produk pertama. | Ops |

**Success:** User menyelesaikan step 1–5 dalam **&lt;2 menit** (time dari buka app sampai transaksi pertama) untuk path minimal (AC#1).

### 8.4 Pilot Metrics to Track

- Jumlah registrasi, activated (7d), D7/D30 retention.
- Time to first transaction (target &lt;48 jam MVP-1, &lt;24 jam MVP-2).
- NPS setelah 14 hari pakai.
- Jumlah tiket support per 100 merchant; top 3 issue categories.

---

## 9. Measurable Acceptance Criteria (Summary — 10 AC)

PRD ini mensyaratkan **10 acceptance criteria** berikut yang dapat diukur (test atau monitoring):

| # | Acceptance criterion | How to measure |
|---|----------------------|----------------|
| **AC#1** | **Login + onboarding selesai (sampai transaksi pertama) &lt;2 menit** untuk path minimal (required fields only). | Instrumentasi: timestamp "app open" → "first transaction completed"; target p50 &lt;2 min. |
| **AC#2** | **Checkout (complete transaction) p95 &lt;200 ms** when served from local cache / offline queue. | Client-side metric: time from "complete" tap to "transaction confirmed" when offline or from cache. |
| **AC#3** | **Offline queue persists after app kill.** Transaksi yang dibuat offline tetap ada setelah force quit; sync saat online. | QA: buat transaksi offline → kill app → buka lagi → cek queue masih ada; setelah online → sync sukses. |
| **AC#4** | **Report export CSV/Excel has documented mapping to Accurate** (or equivalent) for import. | Dokumen mapping (kolom POS → kolom Accurate) ada; export file memenuhi format yang didokumentasikan. |
| **AC#5** | **Sensitive data encrypted at rest** (PII, transaction data on server). | Infra: DB or volume encryption enabled; audit checklist signed off. |
| **AC#6** | **API availability 99.5%** (excluding planned maintenance). | Monitoring (e.g. uptime probe); monthly report. |
| **AC#7** | **WA messages (receipt, reminders) only sent with explicit opt-in.** | Cek: tidak ada kirim WA tanpa consent; consent stored (e.g. flag + timestamp). |
| **AC#8** | **Session valid ≥7 days** without unnecessary logout. | Config + test: login sekali, tidak buka app 3 hari, buka lagi → masih login. |
| **AC#9** | **Export laporan (PDF/Excel) generate &lt;10 s** for up to 10k transactions in range. | Load test: request export for 10k rows; p95 response time &lt;10 s. |
| **AC#10** | **Activation rate (onboarding + ≥1 transaksi in 7d) ≥40%** for pilot cohort. | Analytics: count registered in period; count with ≥1 txn in 7d; ratio ≥0.4. |

---

## 10. Release Timeline (Gantt-Style)

| Feature / Item | M1 | M2 | M3 | M4 | M5 | M6 |
|----------------|----|----|----|----|----|-----|
| Auth & onboarding (M1.1) | ● | | | | | |
| Core POS (M1.2) | ● | | | | | |
| Product catalog (M1.3) | ● | | | | | |
| Pengeluaran & laporan dasar (M1.4) | | ● | | | | |
| Stok & kedaluwarsa (M1.5) | | ● | | | | |
| Tagihan & piutang (M1.6) | | | ● | | | |
| Export PDF/Excel + mapping (M1.7) | | | ● | | | |
| **MVP-1 release** | | | ◆ | | | |
| QRIS integration (M2.1) | | | | ● | | |
| Split tender (M2.2) | | | | ● | | |
| Struk & notifikasi WA (M2.3) | | | | | ● | |
| Loyalty dasar (M2.4) | | | | | ● | |
| Laporan "Lalu Apa?" (M2.5) | | | | | | ● |
| Bahasa sederhana (M2.6) | | | | | | ● |
| **MVP-2 release** | | | | | | ◆ |

**Legend:** ● = development; ◆ = release.

---

*PRD ini hidup (living doc). Perubahan scope atau timeline harus didokumentasikan dengan changelog dan persetujuan PM/eng lead.*
