# TOTAT — Domain & Product Structure
# Canonical reference for all AI, Claude Code, and landing page builds
# GDrive: https://drive.google.com/drive/folders/1u5dWXJF6eDGy4rkBU3WrLAbxx7J7UWNI
# GitHub: https://github.com/kebowandira/TOTAT (after PR #2 merge)
# Last updated: Sep 2026


---


## COMPANY STRUCTURE


PT Catat Mapan
└── TOTAT (Toko Catat)
    Tagline: "Catat usahamu, mapankan hidupmu"
    Color: #2A9D8F (Teal)


---


## PRODUCT FAMILY — COMPLETE


### Commerce Track
| Produk | Subdomain landing | App URL | Status | Timeline |
|--------|-------------------|---------|--------|----------|
| TOTAT Warung | warung.totat.my.id | app.totat.my.id/warung | ✅ LIVE | Sep 2026 |
| TOTAT Saji | cafe.totat.my.id | app.totat.my.id/saji | Planned | Nov 2026 |
| TOTAT Talent | talent.totat.my.id | app.totat.my.id/talent | Planned | Jan 2027 |
| TOTAT Kanal | kanal.totat.my.id | app.totat.my.id/kanal | Planned | Mar 2027 |
| TOTAT Kirim | kirim.totat.my.id | app.totat.my.id/kirim | Planned | Apr 2027 |
| TOTAT Jaringan | jaringan.totat.my.id | app.totat.my.id/jaringan | Planned | Jun 2027 |
| TOTAT Investor | investor.totat.my.id | app.totat.my.id/investor | Planned | Aug 2027 |
| TOTAT Distribusi | distribusi.totat.my.id | app.totat.my.id/distribusi | Planned | Oct 2027+ |


### Hospitality Track (BuLe's edge)
| Produk | Subdomain landing | App URL | Status | Timeline |
|--------|-------------------|---------|--------|----------|
| TOTAT Sewa | sewa.totat.my.id | app.totat.my.id/sewa | Planned | Nov 2026 |
| TOTAT Tamu | tamu.totat.my.id | app.totat.my.id/tamu | Planned | Jan 2027 |
| TOTAT Jasa | jasa.totat.my.id | app.totat.my.id/jasa | Planned | Mar 2027 |


### Standalone
| Produk | Subdomain landing | App URL | Status | Timeline |
|--------|-------------------|---------|--------|----------|
| TOTAT Karir | karir.totat.my.id | app.totat.my.id/karir | Planned | Jan 2027+ |


---


## DOMAIN MAP — COMPLETE


```
totat.my.id                    → Company landing (PT Catat Mapan)
context.totat.my.id            → AI context server (public, read-only)


# Landing pages (one per product)
warung.totat.my.id             → TOTAT Warung landing  ← BUILD NEXT
cafe.totat.my.id               → TOTAT Saji landing
sewa.totat.my.id               → TOTAT Sewa landing
tamu.totat.my.id               → TOTAT Tamu landing
jasa.totat.my.id               → TOTAT Jasa landing
talent.totat.my.id             → TOTAT Talent landing
kanal.totat.my.id              → TOTAT Kanal landing
kirim.totat.my.id              → TOTAT Kirim landing
jaringan.totat.my.id           → TOTAT Jaringan landing
investor.totat.my.id           → TOTAT Investor landing
distribusi.totat.my.id         → TOTAT Distribusi landing
karir.totat.my.id              → TOTAT Karir landing


# PWA apps (all under one subdomain)
app.totat.my.id/warung         → PWA Warung ✅ LIVE (via Hercules beta)
app.totat.my.id/saji           → PWA Saji
app.totat.my.id/sewa           → PWA Sewa
app.totat.my.id/tamu           → PWA Tamu
app.totat.my.id/jasa           → PWA Jasa
app.totat.my.id/talent         → PWA Talent
app.totat.my.id/kanal          → PWA Kanal
app.totat.my.id/kirim          → PWA Kirim
app.totat.my.id/jaringan       → PWA Jaringan
app.totat.my.id/investor       → PWA Investor
app.totat.my.id/karir          → PWA Karir
```


---


## NL1 FOLDER MAP (/opt/totat/)


```
/opt/totat/
├── caddy/
│   └── totat-blocks.caddy     ← merge into existing Caddy config
├── sites/
│   ├── main/                  ← totat.my.id
│   ├── warung/                ← warung.totat.my.id  ← BUILD NEXT
│   ├── cafe/                  ← cafe.totat.my.id
│   ├── sewa/                  ← sewa.totat.my.id
│   ├── tamu/                  ← tamu.totat.my.id
│   ├── jasa/                  ← jasa.totat.my.id
│   ├── talent/                ← talent.totat.my.id
│   ├── kanal/                 ← kanal.totat.my.id
│   ├── kirim/                 ← kirim.totat.my.id
│   ├── jaringan/              ← jaringan.totat.my.id
│   ├── investor/              ← investor.totat.my.id
│   ├── distribusi/            ← distribusi.totat.my.id
│   └── karir/                 ← karir.totat.my.id
├── apps/
│   ├── warung/                ← app.totat.my.id/warung (future self-host)
│   ├── saji/                  ← app.totat.my.id/saji
│   └── [modul]/               ← app.totat.my.id/[modul]
├── context/                   ← context.totat.my.id
│   ├── master-brief.md
│   ├── master-brief-short.md
│   ├── schema.sql
│   ├── conventions.md
│   ├── per-ai-setup.md
│   ├── AI_MASTER_GUIDE.md
│   ├── AI_ROLES.md
│   └── domain-structure.md    ← THIS FILE
└── scripts/
    ├── add-subdomain.sh
    ├── deploy.sh
    ├── backup.sh
    └── sync-from-github.sh
```


---


## PRODUCT DESCRIPTIONS (for landing pages)


### TOTAT Warung
Target: Warung sembako, kios pasar, PKL, pedagang kecil
Core: Kasir, stok otomatis, hutang pelanggan, laporan harian
USP: Gratis selamanya, offline-first, tidak perlu akuntansi


### TOTAT Saji
Target: Café, warung makan, foodcourt
Core: Menu, meja, dapur, role kasir/barista, QRIS per meja
USP: Dari order ke dapur ke struk — satu app


### TOTAT Sewa
Target: Pemilik kos, kontrakan, penginapan kecil
Core: Kamar, penyewa, tagihan bulanan, deposit, WA reminder
USP: Bukan PMS hotel — khusus kos/kontrakan informal


### TOTAT Tamu
Target: Penginapan dengan tamu berulang
Core: Profil tamu lengkap — preferensi, keluarga, ulang tahun
USP: Setiap tamu merasa seperti di rumah sendiri
Note: Duduk di atas TOTAT Sewa


### TOTAT Jasa
Target: Airbnb host, private residence, villa kecil
Core: Room service digital — tamu scan QR → order → tagihan
USP: Hotel experience tanpa hotel system


### TOTAT Talent
Target: Usaha dengan karyawan (warung → perusahaan)
Core: Roster, absensi, gaji, slip WA, kasbon, THR
USP: HR gratis untuk warung, powerful untuk perusahaan


### TOTAT Kanal
Target: Seller online (Shopee/Tokopedia/TikTok/Lazada)
Core: Stok terpusat → sync ke semua marketplace otomatis
USP: Update stok 1x di TOTAT → semua marketplace terupdate


### TOTAT Kirim
Target: Warung/café dengan GrabFood/GoFood
Core: Order masuk → kasir TOTAT → stok berkurang otomatis
USP: Satu kasir untuk toko fisik + delivery


### TOTAT Jaringan
Target: Investor/owner dengan 2+ outlet
Core: Consolidated P&L, stock transfer, POS hardware
USP: Lihat semua outlet dari satu dashboard


### TOTAT Investor
Target: Investor pasif (tidak operasional sehari-hari)
Core: ROI tracker, BEP calculator, laporan bulanan otomatis
USP: Share link ke investor — tidak perlu akses penuh


### TOTAT Distribusi
Target: Perusahaan distribusi
Core: Sales management, ops, akunting, finance, HR
USP: Semua dalam satu sistem, bukan Excel berpisah


### TOTAT Karir
Target: Tenaga hospitality (waiter, FO, housekeeping, F&B)
Core: Micro-task harian berbasis SKKNI/ASEAN MRA-TP
USP: 5 menit sehari → siap sertifikasi regional


---


## BETA STATUS
App live: https://warungbeta.totat.my.id (Hercules custom domain)
Also at: https://my-new-app-355108.onhercules.app
Tester form: https://tally.so/r/Bzr1qN
Feedback form: https://tally.so/r/Y51OEv
WA Community: https://chat.whatsapp.com/GLmk1xTigpO6uGLoDk4z8z


---
PT Catat Mapan | TOTAT | Sep 2026
GDrive: https://drive.google.com/drive/folders/1u5dWXJF6eDGy4rkBU3WrLAbxx7J7UWNI
GitHub: https://github.com/kebowandira/TOTAT