# TOTAT — Master Brief (Short)
> Paste ini di awal setiap AI session. Cukup 1 halaman.
> Full context: https://context.totat.my.id/master-brief.md


---


## SIAPA TOTAT
- **Produk:** TOTAT (Toko Catat) — app kasir + manajemen bisnis gratis untuk UMKM Indonesia
- **Perusahaan:** PT Catat Mapan
- **Tagline:** "Catat usahamu, mapankan hidupmu"
- **Owner/Dev/Operator:** BuLe (one-man-show)
- **Status:** Beta live di Hercules · Migrasi ke NL1 self-host Sep 2027


## TECH STACK
Frontend:  React 19 + Vite + TypeScript + Tailwind v4 + shadcn/ui
Database:  Supabase PostgreSQL (production) / Convex (beta Hercules)
Auth:      Supabase Auth — Google OAuth
Hosting:   NL1 VPS (92.112.126.231) via Caddy · totat.my.id
App URL:   app.totat.my.id/[modul]
Current:   my-new-app-355108.onhercules.app (beta)


## DESIGN SYSTEM
Primary:    #2A9D8F (Teal)
Dark:       #1F7A6E
Light:      #E6F4F2
Text:       #1C2B29
Gray:       #6B7280
Font:       System UI / Helvetica Neue
Style:      Mobile-first, Android PWA, warung owner bukan startup
Components: shadcn/ui — sudah ada di /src/components/ui/


## 5 UX RULES — TIDAK BOLEH DILANGGAR
1. Satu tap = satu aksi — tidak ada menu dalam menu
2. Semua aksi penting visible — tidak tersembunyi di hamburger
3. Bahasa Indonesia informal — "kamu" bukan "Anda"
4. Error harus ada solusinya — bukan hanya pesan error
5. Offline-first — core features jalan tanpa internet


## PRICING RULES
- Free = benar-benar full function, BUKAN freemium
- Premium = complexity layer (multi-outlet, investor view)
- JANGAN lock fitur dasar di balik paywall


## PRODUCT FAMILY
Warung   → app.totat.my.id/warung  ✅ Live
Saji     → app.totat.my.id/saji    Nov 2026
Sewa     → app.totat.my.id/sewa    Nov 2026
Tamu     → app.totat.my.id/tamu    Jan 2027
Jasa     → app.totat.my.id/jasa    Mar 2027
Talent   → app.totat.my.id/talent  Jan 2027
Kanal    → app.totat.my.id/kanal   Mar 2027
Kirim    → app.totat.my.id/kirim   Apr 2027
Jaringan → app.totat.my.id/jaringan Jun 2027
Investor → app.totat.my.id/investor Aug 2027
Karir    → app.totat.my.id/karir   Jan 2027+


## TASK UNTUK SESSION INI
Task:
Modul/file:
Jangan ubah:
Output format:


---
Full context: https://context.totat.my.id/master-brief.md
Schema: https://context.totat.my.id/schema.sql