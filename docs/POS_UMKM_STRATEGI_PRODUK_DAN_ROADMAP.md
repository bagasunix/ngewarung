# Strategi Produk & Roadmap: POS UMKM Indonesia yang Unggul

**Tujuan:** Membangun aplikasi POS untuk UMKM Indonesia yang lebih baik dari Stroberi Kasir dan kompetitor.  
**Fokus:** Inovasi produk dan peluang startup.  
**Horizon:** 12 bulan.

---

## 1. Analisis Kelemahan Umum Aplikasi POS UMKM Saat Ini

### 1.1 Kelemahan Fungsional

| Kelemahan | Deskripsi | Dampak ke Merchant |
|-----------|-----------|---------------------|
| **Pembayaran tidak terintegrasi** | Banyak POS hanya mencatat "uang masuk" manual; tidak ada terima QRIS/e-wallet/kartu dalam satu alur. | Harus pakai banyak alat (flip chart QRIS, e-wallet terpisah); rekonsiliasi manual; risiko selisih kas. |
| **Stok reaktif, bukan prediktif** | Hanya kurangi stok saat jual; tidak ada rekomendasi "kapan beli lagi" atau "berapa banyak". | Stok habis mendadak atau overstock; barang kedaluwarsa; modal tertanam tidak optimal. |
| **Laporan historis saja** | Hanya tampil angka lalu (harian/mingguan/bulanan); tidak ada insight atau rekomendasi tindak lanjut. | Pemilik bingung "lalu apa yang harus dilakukan"; keputusan tetap mengandalkan feeling. |
| **Pelanggan tidak terkelola** | Tidak ada database pelanggan, segmentasi, atau riwayat belanja per orang. | Sulit jual ulang, loyalitas, atau promosi yang tepat sasaran. |
| **Tagihan/piutang terpisah** | Fitur tagihan ada tapi tidak terhubung ke kasir (mis. bayar cicilan langsung kurangi piutang + update kas). | Double entry; piutang macet tidak terpantau dengan baik. |
| **Single outlet** | Satu toko = satu akun/device; tidak ada dashboard gabungan multi-outlet. | Yang punya 2–3 warung harus buka banyak app; tidak ada view konsolidasi. |
| **Tidak offline-first** | Banyak tergantung internet; saat sinyal lemah transaksi gagal atau tidak tersimpan. | Kehilangan penjualan dan data di daerah dengan jaringan buruk. |
| **Export/ integrasi terbatas** | Laporan bisa diunduh (PDF/Excel) tapi tidak ada integrasi ke software akuntansi atau pajak. | Untuk pinjam bank atau lapor pajak harus input ulang manual. |

### 1.2 Kelemahan Teknis & UX

| Kelemahan | Deskripsi |
|-----------|------------|
| **Paket gratis sangat terbatas** | Batas transaksi per bulan (mis. 500); fitur penting dikunci di berbayar. |
| **Performa saat ramai** | Lambat atau error saat jam sibuk; antrian panjang. |
| **Login berulang** | Session sering logout; kasir harus login berkali-kali (feedback nyata pengguna Stroberi). |
| **Hanya Android** | Banyak POS hanya di Android; tidak ada web atau iOS untuk owner yang mau cek dari laptop/iPhone. |
| **Keamanan & privasi data** | Beberapa app tidak encrypt data; kebijakan data kurang transparan. |

### 1.3 Kelemahan Model Bisnis & Ekosistem

| Kelemahan | Deskripsi |
|-----------|------------|
| **Gratis = prioritas produk rendah** | POS gratis (mis. dari bank) fokus funnel ke produk bank, bukan evolusi fitur kasir. |
| **Lock-in ke satu bank/penyedia** | Merchant yang ingin netral atau multi-bank kurang terlayani. |
| **Tidak ada jalur "naik kelas"** | Dari warung ke toko besar tetap pakai produk yang sama; tidak ada tier fitur yang mengikuti skala bisnis. |

---

## 2. Pain Point Utama Pemilik Usaha Kecil (UMKM)

### 2.1 Pain Point Operasional

| Pain Point | Uraian | Frekuensi |
|------------|--------|-----------|
| **Waktu terbatas** | Pemilik sekaligus kasir, buyer, dan admin; tidak punya waktu untuk pembukuan rumit. | Harian |
| **Salah catat / salah hitung** | Harga, jumlah, diskon salah → rugi atau konflik dengan pelanggan. | Mingguan |
| **Stok habis tidak tahu** | Barang laris tiba-tiba habis; pelanggan pindah ke toko lain. | Mingguan |
| **Antrian panjang** | Proses bayar lambat saat ramai; pelanggan tidak sabar. | Saat peak |
| **Piutang lupa ditagih** | Pelanggan langganan utang; tidak ada pengingat sistematis. | Bulanan |

### 2.2 Pain Point Keuangan & Akses Modal

| Pain Point | Uraian |
|------------|--------|
| **Tidak punya laporan yang "bisa dipakai"** | Bank atau KUR minta laporan formal; pemilik hanya punya catatan receh atau spreadsheet berantakan. |
| **Cash flow tidak terlihat** | Tidak tahu kapan uang masuk vs keluar; sulit rencanakan belanja stok atau bayar supplier. |
| **Modal kerja terbatas** | Butuh pinjaman atau paylater untuk beli stok; proses lama dan tidak terintegrasi dengan POS. |

### 2.3 Pain Point Pelanggan & Penjualan

| Pain Point | Uraian |
|------------|--------|
| **Pelanggan tidak kembali** | Tidak ada data siapa beli apa; tidak ada cara promosi atau loyalty. |
| **Kompetisi dengan toko sebelah** | Harga dan stok mirip; butuh pembeda (layanan, promosi, kemudahan bayar). |
| **Pesan/order di luar toko** | Pelanggan mau pesan lewat WA; tidak ada sistem, jadi catat manual dan sering salah. |

### 2.4 Pain Point Digital & Teknis

| Pain Point | Uraian |
|------------|--------|
| **Internet tidak stabil** | Daerah tertentu sinyal lemah; aplikasi cloud sering putus. |
| **Tidak paham akuntansi** | Istilah laba/rugi, accrual, chart of accounts membingungkan; butuh yang "otomatis" dan bahasa sederhana. |
| **Takut data hilang** | Pernah kehilangan catatan kertas; butuh jaminan data aman dan bisa diunduh. |

---

## 3. Lima Belas Fitur Inovatif yang Belum Banyak Dimiliki POS di Indonesia

Fitur berikut dirancang untuk mengatasi kelemahan dan pain point di atas, dengan fokus pada diferensiasi di pasar Indonesia.

---

### Fitur 1: **QRIS + E-Wallet + Tunai dalam Satu Transaksi (Split Tender)**

**Apa:** Satu struk bisa dibayar dengan kombinasi (mis. sebagian tunai, sebagian QRIS/GoPay/OVO). Sistem otomatis rekonsiliasi ke saldo/settlement.

**Mengapa inovatif:** Mayoritas POS UMKM hanya "catat uang masuk" atau satu metode bayar per transaksi. Split tender mengurangi konflik kas dan memudahkan pelanggan.

**Keunggulan kompetitif:** Satu aplikasi menggantikan banyak alat; rekonsiliasi otomatis; cocok untuk warung yang terima cash + e-wallet.

---

### Fitur 2: **Penerima Pembayaran Satu QR (Unified QR)**

**Apa:** Satu kode QR untuk semua metode (QRIS, semua e-wallet, bank). Pelanggan scan sekali; sistem deteksi dan terima pembayaran; transaksi POS otomatis tercatat.

**Mengapa inovatif:** Banyak merchant masih pakai banyak QR (GoPay, OVO, Dana, QRIS) sehingga ribet. Satu QR = lebih cepat dan rapi.

**Keunggulan kompetitif:** UX kasir dan pelanggan lebih baik; mengurangi salah input nominal; data penjualan real-time.

---

### Fitur 3: **Prediksi Stok & Rekomendasi Restock (AI)**

**Apa:** Berdasarkan riwayat penjualan dan (opsional) musiman, sistem menyarankan: "Barang X diperkirakan habis dalam 3 hari", "Rekomendasi beli: 20 pcs", "Barang Y jarang laku, jangan tambah stok dulu".

**Mengapa inovatif:** POS Indonesia umumnya hanya kurangi stok; tidak ada prediksi atau reorder point otomatis.

**Keunggulan kompetitif:** Mengurangi kehabisan stok dan overstock; bahasa sederhana ("beli ini sebanyak ini") tanpa istilah teknis.

---

### Fitur 4: **Pesan & Bayar lewat WhatsApp**

**Apa:** Pelanggan kirim pesan (atau pilih dari menu) via WhatsApp; order masuk ke POS sebagai draft transaksi. Link bayar (QRIS/payment link) dikirim ke WA; setelah bayar, status otomatis lunas dan struk dikirim WA.

**Mengapa inovatif:** Order via WA sangat umum di Indonesia, tapi hampir selalu manual. Integrasi WA–POS masih jarang di segment UMKM murah.

**Keunggulan kompetitif:** Mengurangi salah catat order; pembayaran dan struk otomatis; pelanggan tidak perlu datang dulu untuk bayar.

---

### Fitur 5: **Loyalty Sederhana (Poin / Stempel Digital)**

**Apa:** Setiap transaksi dapat poin atau stempel; setelah N transaksi atau N poin bisa tukar diskon atau barang. Bisa pakai nomor HP atau nama; tidak wajib kartu fisik.

**Mengapa inovatif:** Banyak POS UMKM tidak punya loyalty; yang ada biasanya di tier enterprise (Moka, dll) dengan harga tinggi.

**Keunggulan kompetitif:** Meningkatkan repeat purchase; data pembelian per pelanggan untuk promosi berikutnya.

---

### Fitur 6: **Laporan "Lalu Apa?" (Actionable Insights)**

**Apa:** Di samping angka (penjualan, laba, stok), sistem menampilkan kalimat rekomendasi: "Penjualan kopi turun 20% vs minggu lalu — coba promo", "3 produk akan kedaluwarsa dalam 7 hari — prioritaskan jual", "Piutang Bapak Ahmad sudah 30 hari — kirim pengingat".

**Mengapa inovatif:** Laporan kebanyakan hanya tabel/grafik; pemilik UMKM butuh "saya harus ngapain".

**Keunggulan kompetitif:** Meningkatkan engagement dan retensi; posisi sebagai "asisten bisnis", bukan sekadar pencatat.

---

### Fitur 7: **Multi-Outlet dalam Satu Dashboard**

**Apa:** Satu akun punya banyak outlet (warung/toko). Setiap outlet punya stok dan kasir sendiri; owner lihat dashboard gabungan: penjualan per outlet, stok gabungan, perbandingan performa.

**Mengapa inovatif:** Banyak POS gratis/simple single-outlet; multi-outlet biasanya paket mahal.

**Keunggulan kompetitif:** Menjaring merchant yang punya 2–3 cabang; upsell natural saat bisnis berkembang.

---

### Fitur 8: **Mode Offline Penuh + Sinkron Otomatis**

**Apa:** Kasir, input produk, dan kurangi stok bisa dipakai tanpa internet. Data disimpan lokal; saat online, sinkron ke cloud. Konflik (mis. stok) diselesaikan dengan aturan jelas (server wins / last write).

**Mengapa inovatif:** Banyak solusi cloud-only; daerah dengan sinyal buruk kehilangan penjualan.

**Keunggulan kompetitif:** Bisa dipasarkan ke warung di pasar, desa, atau lokasi dengan jaringan tidak stabil.

---

### Fitur 9: **Tagihan & Piutang Terintegrasi dengan Kasir**

**Apa:** Buat tagihan ke pelanggan (nama, nominal, jatuh tempo). Saat pelanggan bayar (tunai/transfer/QRIS), input di POS → otomatis kurangi piutang, tambah kas, dan update laporan. Pengingat jatuh tempo (WA/in-app).

**Mengapa inovatif:** Di banyak app, tagihan dan kasir terpisah; double entry dan piutang susah dilacak.

**Keunggulan kompetitif:** Satu sumber kebenaran untuk kas dan piutang; cocok untuk toko yang banyak jual langganan/utang.

---

### Fitur 10: **Export ke Software Akuntansi & Pajak**

**Apa:** Export terjadwal atau on-demand ke format yang bisa diimpor ke Accurate, Jurnal.id, atau tools pajak (e.g. format CSV/Excel yang sesuai). Opsional: API untuk integrasi langsung.

**Mengapa inovatif:** Mayoritas POS UMKM hanya export PDF/Excel umum; tidak ada mapping ke chart of accounts atau format pajak.

**Keunggulan kompetitif:** Menarik merchant yang sadar pajak dan pinjam bank; mengurangi input ulang manual.

---

### Fitur 11: **Struk & Tagihan Otomatis lewat WhatsApp**

**Apa:** Setelah transaksi/tagihan lunas, struk atau konfirmasi pembayaran otomatis dikirim ke nomor WA pelanggan (dengan persetujuan pelanggan).

**Mengapa inovatif:** Banyak masih print atau foto struk lalu kirim manual.

**Keunggulan kompetitif:** Pengalaman pelanggan lebih baik; bukti transaksi tersimpan di WA.

---

### Fitur 12: **Pinjaman Modal / Paylater untuk Merchant (Embedded Finance)**

**Apa:** Berdasarkan riwayat penjualan dan stok di POS, merchant bisa ajukan limit pinjaman (working capital atau belanja stok). Cair ke rekening atau langsung ke supplier; angsuran dipotong dari settlement penjualan (jika terintegrasi payment).

**Mengapa inovatif:** Fintech dan bank biasanya tidak punya data operasional toko; POS punya. Embed financing = nilai tambah besar.

**Keunggulan kompetitif:** Monetisasi selain subscription; meningkatkan LTV dan retensi; "naik kelas" dengan akses modal.

---

### Fitur 13: **Bahasa Laporan Sederhana (Tanpa Istilah Akuntansi)**

**Apa:** Semua laporan dan insight memakai istilah sehari-hari: "Uang masuk hari ini", "Uang keluar bulan ini", "Sisa kas", "Keuntungan kotor", "Barang yang paling laku". Tanpa "revenue", "COGS", "accrual".

**Mengapa inovatif:** Banyak pemilik UMKM tidak paham akuntansi; laporan teknis tidak dipakai.

**Keunggulan kompetitif:** Adopsi lebih dalam; cocok untuk segment pertama kali pakai pembukuan digital.

---

### Fitur 14: **Pengingat Piutang & Stok Kedaluwarsa via WhatsApp**

**Apa:** Notifikasi otomatis ke pemilik/kasir: "Piutang Bu Siti jatuh tempo besok", "Stok Indomie Goreng akan habis dalam 2 hari", "Ada 5 item kedaluwarsa dalam 7 hari". Bisa via WA Business API atau push notifikasi.

**Mengapa inovatif:** Stroberi punya pengingat kedaluwarsa di app; pengingat piutang dan stok habis via WA masih jarang di POS murah.

**Keunggulan kompetitif:** Tindakan tepat waktu tanpa harus buka app tiap saat.

---

### Fitur 15: **Role & Audit Trail (Pemilik vs Kasir)**

**Apa:** Pemilik bisa buat akun kasir dengan role terbatas (hanya transaksi, tidak bisa hapus produk atau lihat laporan laba penuh). Semua aksi penting tercatat: siapa, kapan, apa (audit trail). Opsional: approval untuk diskon besar atau void transaksi.

**Mengapa inovatif:** Banyak POS UMKM satu user saja; tidak ada pembagian wewenang atau jejak audit.

**Keunggulan kompetitif:** Merchant dengan karyawan lebih percaya pakai app; mengurangi kecurangan dan salah urus.

---

## 4. Bagaimana Fitur Tersebut Memberikan Keunggulan Kompetitif

### 4.1 Peta Posisi Kompetitif (Simplified)

```
                    FITUR TINGGI
                         │
     Moka, Pawoon        │     [PRODUK KITA]
     (berbayar,          │     Inovasi + harga
      enterprise)        │     terjangkau UMKM
                         │
    ────────────────────┼──────────────────── FITUR INOVATIF
                         │     (WA, AI, loyalty,
    Stroberi, BukuWarung │      embedded finance)
     (gratis, basic)     │
                         │
                    FITUR RENDAH
```

### 4.2 Sumber Keunggulan Kompetitif

| Sumber | Cara Fitur Mendukung |
|--------|------------------------|
| **Differentiation** | Split tender, satu QR, WA order-bayar-struk, loyalty, insight "lalu apa?", multi-outlet, offline — membedakan dari Stroberi (basic) dan dari POS mahal (fitur berat). |
| **Switching cost** | Semakin merchant pakai (stok, pelanggan, tagihan, history), semakin berat pindah; loyalty dan embedded finance menambah ikatan. |
| **Network / ecosystem** | WA dan pembayaran terintegrasi = pelanggan dan merchant dalam satu loop; embedded finance = partner bank/fintech. |
| **Cost-to-serve** | Laporan jelas + export akuntansi = kurang support "gimana cara lapor"; insight otomatis = kurang konsultasi manual. |
| **Land-and-expand** | Mulai single-outlet gratis/surah → multi-outlet, payment, financing = naik ARPU dan LTV. |

### 4.3 Value Proposition Ringkas

- **Untuk warung/toko mikro:** "Kasir + terima bayaran (QRIS/e-wallet) + stok + piutang + laporan yang bisa dipakai — dalam satu app, tetap ringan dan bisa offline."
- **Untuk yang punya 2+ outlet:** "Satu dashboard untuk semua toko; bandingkan performa dan kelola stok dari satu tempat."
- **Untuk yang butuh modal:** "Data penjualan kamu dipakai untuk akses pinjaman/paylater tanpa ribet."

---

## 5. Roadmap Pengembangan Produk 12 Bulan

Roadmap dibagi dalam 4 fase: **Foundation**, **Growth**, **Differentiation**, **Scale**. Setiap fase ~3 bulan, dengan rilis inkremental (bulanan bila memungkinkan).

---

### Fase 1: Foundation (Bulan 1–3) — "MVP yang Layak Jual"

**Tujuan:** Produk yang bisa dipakai sehari-hari untuk kasir, stok, dan laporan dasar; onboarding cepat; satu sumber kebenaran keuangan.

| Bulan | Fokus | Fitur / Deliverable |
|-------|--------|----------------------|
| **1** | Core POS & Produk | Kasir: tambah item ke cart, quantity, harga, diskon, selesai transaksi. CRUD produk + kategori. Pengurangan stok otomatis saat transaksi. |
| **1** | Auth & Onboarding | Daftar/login (HP + OTP). Profil toko (nama, alamat). Onboarding wizard singkat (tambah produk pertama, transaksi pertama). |
| **2** | Keuangan Dasar | Catat pengeluaran (biaya). Laporan: transaksi harian, pemasukan vs pengeluaran, laba/rugi sederhana, kas. Export PDF/Excel dasar. |
| **2** | Stok & Kedaluwarsa | Field tanggal kedaluwarsa di produk. Pengingat stok hampir habis (threshold) dan kedaluwarsa (in-app). |
| **3** | Tagihan & Piutang | Buat tagihan (nama, nominal, jatuh tempo). Catat pembayaran → kurangi piutang, update kas. Daftar piutang dan riwayat bayar. |
| **3** | Kualitas & Stabilitas | Perbaikan bug, performa, UX. Persiapan infrastruktur multi-tenant dan API untuk fase berikutnya. |

**Outcome Fase 1:** MVP bisa dipakai warung/toko untuk gantikan buku tulis; sudah lebih lengkap dari Stroberi di sisi tagihan-terintegrasi dan pengingat stok/kedaluwarsa.

---

### Fase 2: Growth (Bulan 4–6) — "Pembayaran & Pengalaman Pelanggan"

**Tujuan:** Terima pembayaran digital dalam app; kurangi rekonsiliasi manual; tingkatkan pengalaman pelanggan (struk, WA).

| Bulan | Fokus | Fitur / Deliverable |
|-------|--------|----------------------|
| **4** | Pembayaran Terintegrasi | Integrasi QRIS (atau payment aggregator): tampil QR di app, nominal dari cart; callback terima pembayaran → auto complete transaksi. |
| **4** | Split Tender | Satu transaksi bisa bayar sebagian tunai, sebagian QRIS/e-wallet. Rekonsiliasi otomatis. |
| **5** | Struk & Notifikasi WA | Opsional input nomor WA pelanggan; setelah bayar, kirim struk via WhatsApp. Pengingat piutang & stok kedaluwarsa via WA (template compliant). |
| **5** | Loyalty Dasar | Poin per transaksi (atau per rupiah). Redeem: setelah N poin dapat diskon. Input nomor HP/nama untuk kaitkan ke pelanggan. |
| **6** | Laporan "Lalu Apa?" | Di halaman laporan: tambah blok "Rekomendasi" — mis. "3 produk kedaluwarsa 7 hari", "Piutang tertunggak 3 orang", "Top 5 produk laris". Rule-based dulu (belum ML). |
| **6** | Bahasa Sederhana | Semua label laporan pakai istilah Indonesia sehari-hari; tooltip singkat bila perlu. |

**Outcome Fase 2:** POS yang menerima bayaran digital dan mengirim struk/peringatan lewat WA; loyalty dan insight dasar membedakan dari kompetitor murah.

---

### Fase 3: Differentiation (Bulan 7–9) — "AI, Multi-Outlet, Offline"

**Tujuan:** Prediksi stok, multi-outlet, offline-first; siap naik tier harga untuk merchant yang berkembang.

| Bulan | Fokus | Fitur / Deliverable |
|-------|--------|----------------------|
| **7** | Offline-First | Semua flow kasir & stok jalan tanpa internet; queue sync; saat online, upload dan resolve conflict (server wins untuk stok). |
| **7** | Multi-Outlet | Satu akun, banyak outlet. Pilih outlet saat transaksi; stok per outlet. Dashboard owner: ringkasan per outlet, perbandingan penjualan. |
| **8** | Prediksi Stok & Rekomendasi Restock | Model sederhana (moving average atau trend) untuk prediksi "habis dalam X hari" dan "rekomendasi beli Y pcs". Tampil di dashboard dan notifikasi. |
| **8** | Pesan & Bayar via WA | Flow: pelanggan order (form/WA); draft order di POS; kirim link bayar; setelah bayar, konfirmasi + struk WA. Integrasi WA Business. |
| **9** | Role & Audit Trail | Role: Owner vs Kasir. Kasir hanya transaksi + lihat stok terbatas; owner full akses. Log: siapa ubah apa, kapan. Opsional: approval void/diskon besar. |
| **9** | Export Akuntansi | Template export (CSV/Excel) untuk impor ke Accurate/Jurnal atau format pajak; dokumentasi mapping. |

**Outcome Fase 3:** Produk siap untuk toko dengan beberapa cabang dan karyawan; offline dan WA order-bayar cocok untuk pasar Indonesia; prediksi stok jadi pembeda "cerdas".

---

### Fase 4: Scale (Bulan 10–12) — "Embedded Finance & Skalabilitas"

**Tujuan:** Monetisasi non-subscription (embedded finance); ekspansi fitur untuk naik ARPU; skalabilitas teknis dan operasional.

| Bulan | Fokus | Fitur / Deliverable |
|-------|--------|----------------------|
| **10** | Embedded Finance (V1) | Kerja sama dengan fintech/bank: data penjualan (anonim/agregat) untuk penawaran limit. Link ke aplikasi pinjaman atau KUR; belum potong angsuran dari settlement. |
| **10** | Unified QR (Optional) | Satu QR untuk semua metode bayar (jika mitra payment support); kurangi clutter di kasir. |
| **11** | Dashboard & Laporan Lanjutan | Grafik tren penjualan, perbandingan periode, cohort pelanggan (yang beli 2+ kali). Laporan terjadwal (email/WA) mingguan/bulanan. |
| **11** | Onboarding & Aktivasi | In-app tips, checklist "Aktivasi 7 hari" (tambah 10 produk, 5 transaksi, 1 laporan). A/B test alur pendaftaran. |
| **12** | Embedded Finance (V2) | Jika ada mitra: potong angsuran dari settlement (paylater merchant); atau alur "belanja stok now, bayar nanti" terintegrasi. |
| **12** | Review & Persiapan Tahun 2 | Retrospektif produk; prioritas fitur tahun berikutnya (mis. integrasi pajak resmi, multi-currency, white-label). |

**Outcome Fase 4:** Revenue dari financing dan potensi take rate pembayaran; produk siap skala dengan multi-outlet, laporan lanjutan, dan embedding ke ekosistem keuangan.

---

### 5.1 Ringkasan Roadmap (Gantt-style)

| Fitur / Tema           | M1 | M2 | M3 | M4 | M5 | M6 | M7 | M8 | M9 | M10 | M11 | M12 |
|------------------------|----|----|----|----|----|----|----|----|----|-----|-----|-----|
| Core POS & Produk      | ●  |    |    |    |    |    |    |    |    |     |     |     |
| Auth & Onboarding      | ●  |    |    |    |    |    |    |    |    |     |     |     |     |
| Biaya & Laporan Dasar  |    | ●  |    |    |    |    |    |    |    |     |     |     |     |
| Stok & Kedaluwarsa     |    | ●  |    |    |    |    |    |    |    |     |     |     |     |
| Tagihan & Piutang      |    |    | ●  |    |    |    |    |    |    |     |     |     |     |
| QRIS & Split Tender    |    |    |    | ●  |    |    |    |    |    |     |     |     |     |
| Struk & WA Notif       |    |    |    |    | ●  |    |    |    |    |     |     |     |     |
| Loyalty                |    |    |    |    | ●  |    |    |    |    |     |     |     |     |
| Insight "Lalu Apa?"    |    |    |    |    |    | ●  |    |    |    |     |     |     |     |
| Offline-First          |    |    |    |    |    |    | ●  |    |    |     |     |     |     |
| Multi-Outlet           |    |    |    |    |    |    | ●  |    |    |     |     |     |     |
| Prediksi Stok          |    |    |    |    |    |    |    | ●  |    |     |     |     |     |
| Order & Bayar WA       |    |    |    |    |    |    |    | ●  |    |     |     |     |     |
| Role & Audit            |    |    |    |    |    |    |    |    | ●  |     |     |     |     |
| Export Akuntansi       |    |    |    |    |    |    |    |    | ●  |     |     |     |     |
| Embedded Finance       |    |    |    |    |    |    |    |    |    |     | ●   |     | ●   |
| Unified QR             |    |    |    |    |    |    |    |    |    |     | ●   |     |     |
| Dashboard & Laporan    |    |    |    |    |    |    |    |    |    |     |     | ●   |     |

---

### 5.2 Metrik yang Disarankan (per Fase)

- **Fase 1:** Registrasi, aktivasi (min 1 transaksi dalam 7 hari), retensi D7/D30.
- **Fase 2:** % transaksi dengan pembayaran digital, penggunaan loyalty, open rate notifikasi WA.
- **Fase 3:** Penggunaan multi-outlet, penggunaan mode offline, penggunaan rekomendasi restock.
- **Fase 4:** Konversi penawaran financing, ARPU, NPS/CSAT.

---

## Lampiran: Prioritas Jika Sumber Daya Terbatas

Jika tim kecil atau anggaran terbatas, prioritas yang disarankan:

1. **Harus ada di MVP:** Core POS, produk, stok, biaya, laporan dasar, tagihan terintegrasi.
2. **Quick win diferensiasi:** QRIS + split tender, struk/peringatan WA, bahasa laporan sederhana.
3. **Pembeda kuat:** Offline-first, multi-outlet, rekomendasi restock (rule-based dulu), order & bayar via WA.
4. **Monetisasi & skala:** Embedded finance, export akuntansi, role & audit trail.

Dokumen ini dapat digunakan untuk pitch investor, alignment tim produk/engineering, dan dasar backlog development (mis. di repo Ngewarung).
