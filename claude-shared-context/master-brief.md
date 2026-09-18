# TOTAT — Master Brief (Full)
# PT Catat Mapan | Owner: BuLe (one-man-show)
# Tagline: "Catat usahamu, mapankan hidupmu"
# Last updated: Sep 2026
# GDrive: https://drive.google.com/drive/folders/1u5dWXJF6eDGy4rkBU3WrLAbxx7J7UWNI
# Live context: https://context.totat.my.id/


## 1. IDENTITAS PRODUK
Nama: TOTAT (Toko Catat)
Perusahaan: PT Catat Mapan
Owner: BuLe — one-man-show (owner + dev + operator)
Target: Pedagang kecil Indonesia — warung, kios, café, online seller
Platform: Android PWA (offline-first)
Bahasa: Indonesia informal


## 2. TECH STACK
Beta (sekarang):
  Builder: Hercules.app
  Frontend: React 19 + Vite + TypeScript + Tailwind v4 + shadcn/ui
  DB: Convex (Hercules cloud)
  Auth: Google OAuth via @usehercules/auth
  URL: my-new-app-355108.onhercules.app / warungbeta.totat.my.id


Production (Sep 2027):
  Frontend: React 19 + Vite (same codebase, swap Convex → Supabase)
  DB: Supabase PostgreSQL
  Auth: Supabase Auth (Google OAuth)
  Hosting: NL1 VPS 92.112.126.231 via Caddy
  Domain: totat.my.id
  Context: https://context.totat.my.id/


## 3. DESIGN SYSTEM
Primary:   #2A9D8F (Teal)
Dark:       #1F7A6E
Light:      #E6F4F2
Text:       #1C2B29
Gray:       #6B7280
Font:       System UI / Helvetica Neue
Style:      Mobile-first, Android PWA, warung owner bukan startup
Components: shadcn/ui — /src/components/ui/


## 4. 5 UX RULES — TIDAK BOLEH DILANGGAR
1. Satu tap = satu aksi — tidak ada menu dalam menu
2. Semua aksi penting visible — tidak tersembunyi
3. Bahasa Indonesia informal — "kamu" bukan "Anda"
4. Error harus ada solusinya
5. Offline-first — core features jalan tanpa internet


## 5. PRICING RULES
- Free = benar-benar full function, BUKAN freemium
- Premium = complexity layer (multi-outlet, investor view)
- JANGAN lock fitur dasar di balik paywall


## 6. PRODUCT FAMILY
Commerce Track:
  P1  Warung    app.totat.my.id/warung    LIVE Sep 2026
  P1B Struk     —                         Okt 2026
  P2  Saji      app.totat.my.id/saji      Nov 2026
  P3  Talent    app.totat.my.id/talent    Jan 2027
  P4  Kanal     app.totat.my.id/kanal     Mar 2027
  P5  Kirim     app.totat.my.id/kirim     Apr 2027
  P6  Jaringan  app.totat.my.id/jaringan  Jun 2027
  P7  Investor  app.totat.my.id/investor  Aug 2027
  P8  Distribusi                           Oct 2027+


Hospitality Track (BuLe's edge):
  H1  Sewa      app.totat.my.id/sewa      Nov 2026
  H2  Tamu      app.totat.my.id/tamu      Jan 2027
  H3  Jasa      app.totat.my.id/jasa      Mar 2027
  H4  Multi-property → merge P6           Jun 2027


Standalone:
  Karir         app.totat.my.id/karir     Jan 2027+


## 7. DATABASE SCHEMA (ringkas)
Full schema: https://context.totat.my.id/schema.sql


Tables:
  users, produk, penjualan, item_penjualan
  pelanggan, hutang, kas_awal
  supplier, pembelian_stok, item_pembelian_stok
  penyesuaian_stok, license


## 8. FILE STRUCTURE
/src
  App.tsx, main.tsx, index.css
  components/ui/        ← shadcn (jangan edit)
  components/layout/    ← AppLayout, PageHeader
  pages/[modul]/page.tsx
  hooks/use-auth.ts, use-mobile.ts
  lib/csv.ts, format.ts, utils.ts
/convex (beta only → replace /src/api/ saat migrasi)


## 9. CODE CONVENTIONS
- formatRp(15000) → "Rp 15.000"
- Sonner untuk toast, Sheet dari bawah untuk modal
- Native file input (never getUserMedia)
- Bahasa Indonesia: "Simpan" "Batal" "Hapus" "Tambah"
Full: https://context.totat.my.id/conventions.md


## 10. INFRASTRUCTURE (NL1)
IP: 92.112.126.231 (DeluxHost, Ubuntu 24.04, 4core/8GB)
Caddy: /opt/totat/caddy/Caddyfile
Sites: /opt/totat/sites/[modul]/
Apps: /opt/totat/apps/[modul]/
Context: /opt/totat/context/ ← context.totat.my.id
Scripts: /opt/totat/scripts/


## 11. CF PAGES — REDIRECTS (Added Sep 17, 2026)
Architecture: 13 separate Cloudflare Pages Classic projects, one per
subdomain, each with its own `_redirects` file inside its own
`sites/[modul]/` folder (see repo CLAUDE.md's "Landing page architecture"
section for the full domain → project mapping).
- _redirects: wildcard fallback `/* /index.html 200` in every project —
  an unknown path under a subdomain rewrites to THAT subdomain's own
  homepage, not the main totat.my.id page, so each module stays
  self-contained.
- 404.html: intentionally skipped. The wildcard rewrite always returns
  HTTP 200, so a custom 404 page would never actually render — adding
  one would be dead code.
- Next: once a module's landing page grows beyond a single index.html,
  add specific routes to that module's own _redirects file.


## 12. KEY LINKS
App beta: https://warungbeta.totat.my.id
Form tester: https://tally.so/r/Bzr1qN
Form feedback: https://tally.so/r/Y51OEv
WA Community: https://chat.whatsapp.com/GLmk1xTigpO6uGLoDk4z8z
GDrive Foundation: https://drive.google.com/drive/folders/1u5dWXJF6eDGy4rkBU3WrLAbxx7J7UWNI
Context server: https://context.totat.my.id/


## 13. CONVEX DB — VERIFIED Sep 18, 2026

### Schema (confirmed from Hercules dashboard)
Tables: hutang, itemPembelianStok, itemPenjualan, kasAwal, pelanggan,
pembelianStok, penjualan, penyesuaianStok, produk, supplier, users
Functions: backup, kasAwal, pelanggan, pembelianStok, penjualan, produk, supplier, users
File Storage: Convex Files (foto pelanggan + foto nota)

### Auth mechanism
Data linked to Google user via users:getCurrentUser (Convex auth).
NOT device UUID. Wipe/reinstall → login same Google → data intact.
D-2 re-link screen: trivial (email → Convex user lookup).

---

## 14. AI ROSTER — SELF-HOST MIGRATION (Keroyokan AI)

| AI | Role | Scope |
|---|---|---|
| Claude chat | Controller / Architect | Architecture decisions, prompts, memory, audit |
| Claude Code | Infra & Backend | NL1, Supabase migration, API, CI/CD, Git |
| Gemini Plus | Schema + Long Context | Convex→Supabase mapping, large doc analysis |
| Jules (Google) | Frontend async | React components per module via GitHub issues |
| ChatGPT | UI fallback + QA | Components, acceptance test generation |
| Z.ai | Product spec + Copy | Onboarding UX, consent copy, CP-T0 kit |
| Grok | Research | Marketplace API docs, regulatory, competitive intel |
| Hercules | Blueprint factory | Phase 2-3 beta builds, framework validation |

Controller: Claude chat. Executor: Claude Code.
Claude Pro limit strategy: Claude chat for decisions only — heavy output to Gemini Plus or Jules.

---

Commit message: "Add Convex schema verification + AI roster for self-host migration"
Branch: main (direct commit OK, no PR needed for docs update)
