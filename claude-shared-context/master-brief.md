# TOTAT — Master Brief (Full)
# PT Catat Mapan | Owner: BuLe (one-man-show)
# Tagline: "Catat usahamu, mapankan hidupmu"
# Last updated: Sep 2026 (AI Roster v2)
# GDrive: https://drive.google.com/drive/folders/1u5dWXJF6eDGy4rkBU3WrLAbxx7J7UWNI
# Live context: https://context.totat.my.id/
# Current execution status (read first): https://raw.githubusercontent.com/kebowandira/TOTAT/main/PROJECT_STATUS.md


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
- Offline-first — target untuk v2 self-host. Beta butuh koneksi internet ke hercules app.


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


## 10. INFRASTRUCTURE (NL1) — UPDATED Sep 2026
IP: 92.112.126.231 (DeluxHost, Ubuntu 24.04, 4core/8GB)
Caddy: /opt/totat/caddy/Caddyfile
Landing pages: NOT on NL1 — moved to 13 separate Cloudflare Pages
  Classic projects (one per subdomain, see repo CLAUDE.md "Landing page
  architecture"). NL1 does not serve totat.my.id in any form.
Context: /opt/totat/context/ ← context.totat.my.id
Scripts: /opt/totat/scripts/
AI stack: /opt/totat/ai-stack/ (Docker Compose) — see §14-16. Planned
  items in §15 are NOT deployed yet; treat as unverified until a Phase
  0 audit confirms them on the box itself.
Apps: /opt/totat/apps/[modul]/ — future self-host target (~Sep 2027,
  see §2), not live yet; beta app runs on Hercules, not NL1.


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
App beta: https://warungbeta.totat.my.id (invite-only for now — Beta links
  on the public landing pages route to the tester form, not this URL
  directly; see sites/main and sites/warung)
Form tester: https://tally.so/r/Bzr1qN
Form feedback: https://tally.so/r/Y51OEv
WA Community: https://chat.whatsapp.com/GLmk1xTigpO6uGLoDk4z8z (NOT
  currently linked from any live page — held back per BuLe, "Group WA
  juga nanti"; do not re-add to landing pages without checking first)
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

## 14. AI ROSTER v2 — KEROYOKAN (dev tools + self-host + product runtime)

Status legend:
  ✅ IN-USE   🧪 PENDING (decision/intake at deploy time)
  📦 SELF-HOST-PLANNED (NOT on NL1 yet — Phase 0 must confirm before assuming)
  ⏸ DEFERRED  ❌ DROPPED

### 14.1 Dev & Ops Roster

| AI | Role | Scope | Status | Notes |
|---|---|---|---|---|
| Claude chat | Controller / Architect | Architecture decisions, prompts, memory, audit | ✅ Pro $20 | Decisions-only (protects 5h + weekly caps) |
| Claude Code | Infra & Backend executor | NL1 ops, Supabase migration, CI/CD, Git; gated prompts (GO protocol) | ✅ Pro quota | Bulk work → GLM backend swap |
| z.ai GLM | Bulk executor + Copy | Claude Code backend swap; onboarding UX, consent copy, CP-T0 kit | 🧪 $6/mo Lite (optional) | Near-Claude coding at ~1/10 price; free tier for copy |
| Gemini Pro | Schema + Long Context | Convex→Supabase mapping, 1M-context docs, Deep Research | ✅ via XL bundle (free ≤6 mo) | Reassess month 5 → AI Studio free tier |
| Gemini CLI | Frontend overflow executor | React components, free ~1,000 req/day | 🧪 free | Pairs with Jules |
| Jules | Frontend async | React components per module via GitHub issues | ✅ free tier | Daily task cap |
| Abacus ChatLLM | QA + fallback + consolidation | GPT+Claude+Gemini+DeepSeek one dashboard; test-gen; Controller backup | 🧪 $10/mo (optional) | Replaces paid ChatGPT sub |
| Grok | Research | Marketplace APIs, regulatory, competitive intel | ✅ free | Quotas fluctuate |
| Hercules | Blueprint factory | Phase 2-3 beta builds, framework validation | ✅ | — |
| OpenRouter | Gateway/router | One key → DeepSeek/GLM/Qwen/vision chain | 🧪 key ready | Set $5 monthly cap at intake |
| Hermes Agent | Self-improving ops agent | Telegram ops, browsing, skills/memory, TOTAT conventions | 📦 deploying next | github.com/NousResearch/hermes-agent — see §15 |
| n8n | Ops automation | Tally triage, digests, backup cron, license checks, alert hub | 📦 planned | Deploys with ai-stack (separate prompt) |
| SearXNG + Perplexica | Sourced research | Self-hosted Perplexity; Perplexity Pro only if volume demands | 📦 planned | Deploys with ai-stack |
| Open WebUI | Chat UI | DeepSeek/GLM/local models | 📦 planned | Deploys with ai-stack |
| Ollama | Local batch only | Embeddings/classification, night jobs | 📦 planned | ≤4B model, manual start, never always-on (8GB) |
| Letta | — | — | ❌ DROPPED | Retired pre-install; Hermes covers self-improvement |
| Perplexity Pro | — | — | ⏸ DEFERRED | Perplexica first |
| Cursor | — | — | ⏸ OPTIONAL | Free alt: Cline/Roo + GLM plan |
| Paid ChatGPT | — | — | ❌ DROPPED | Replaced by ChatLLM |

Controller: Claude chat. Executor: Claude Code (+GLM swap).
Limit strategy: decisions-only Claude; heavy output → Gemini/Jules/GLM.
Budget target: ~$26–36/mo (Pro $20 + ChatLLM $10 + GLM $6 optional + capped APIs).

### 14.2 Product Runtime AI (TOTAT app itself)

Principle: AI = enhancement, NEVER gate. "Free = full function" → core catat
flow runs without any API call. Offline-first → on-device first (UX rule 5).

| Need | Solution | Mode |
|---|---|---|
| P1B Struk OCR (Okt 2026) | tesseract.js + Bahasa traineddata | On-device, offline (primary) |
| Struk OCR online fallback | Gemini Flash API | Enhancement only, pay-per-use |
| Future text features | DeepSeek API | Pay-per-use (~$0.28/M in, $0.42/M out — UNVERIFIED, check DeepSeek's current pricing page before relying on this); text-only |
| Vision fallback chain | Gemini Flash → GLM-4.5V → Qwen-VL | Via OpenRouter, hot-swappable |

## 15. SELF-HOST STACK — NL1 (92.112.126.231, Ubuntu 24.04, 4c/8GB)

⚠️ STATUS Sep 2026: NOTHING DEPLOYED YET. Everything below = planned.
⚠️ FUTURE AI SESSIONS: "planned" items DO NOT EXIST on NL1 until a Phase 0
   ground-truth audit confirms them. Never assume files/services/DNS exist.

Deployment method: Claude Code gated prompts — Phase 0 full audit (read-only)
→ STOP → owner reviews → "GO <n>" per phase. No --dangerously-skip-permissions
on this box. Provenance rule: owner hints are unverified; Phase 0 is ground truth.

| Service | Purpose | Local port | RAM ceiling | Status |
|---|---|---|---|---|
| Hermes Agent | Self-improving ops agent; Telegram gateway (allowlisted); browser tool | 8085 if UI | 1.5G w/ browser, else 1G | 🔜 deploying (prompt v5) |
| SearXNG | Metasearch backbone | 8081 | 256m | planned |
| Perplexica | Research UI (DeepSeek brain) | 8082 | 512m | planned |
| Open WebUI | Chat UI | 8083 | 768m | planned |
| n8n | Automation + alert hub | 8084 | 512m | planned |
| Ollama | Night batch only, ≤4B | internal | 3.5g | manual profile only |

Conventions (all self-host services):
- Dedicated user hermes (no sudo, no docker group); systemd hardened:
  ProtectSystem=strict, NoNewPrivileges, PrivateTmp, MemoryMax, CPUQuota=150%,
  Restart=on-failure. Never run agents as root.
- Secrets: single intake point, 600 perms, never in chat/logs/git; minimal
  per-service copies only (e.g. hermes.env owned by hermes).
- Agent memory/skills: /opt/totat/hermes/data — WEEKLY diff review (manual,
  mandatory month 1; self-edited prompts reviewed before trusted).
- Messaging: Telegram Bot API ONLY + numeric user-ID allowlist. NO unofficial
  WhatsApp gateways (ToS ban risk — WA community number never exposed).
- DNS automation: Cloudflare API token scoped Zone:DNS:Edit totat.my.id ONLY;
  A records grey-cloud (Caddy TLS); never overwrite/delete existing records;
  planned helper: /opt/totat/scripts/cf-dns-add.sh.
- Caddy: one site file per subdomain (LinguaKid pattern — LinguaKid is a
  separate, unrelated BuLe project; this just borrows its Caddy file
  layout convention), imported by BOTH Caddyfile and Caddyfile.promoted;
  validate before graceful reload; never restart.
- Guardrails: zero prod DB credentials to agents; API spend caps (OpenRouter
  $5/mo key limit; DeepSeek manual top-up); abort gates (disk <10GB, RAM >6GB).
- Updates: image pulls auto w/ health-gate + rollback; AGENT self-update stays
  manual monthly (release notes first).

DNS:
- agent.totat.my.id → NOT created yet. Will point to 92.112.126.231
  (grey cloud) as part of the Hermes deploy's Caddy phase — do not
  assume this record exists until a Phase 0 audit confirms it.
- context.totat.my.id → NOT created; context server = separate future task

## 16. AI DECISION LOG (why — so future sessions don't re-litigate)
- One self-improving agent only (Hermes) — Letta dropped pre-install.
- Telegram over WhatsApp for machines: unofficial WA gateways risk banning the
  community number; official WA Cloud API = separate decision, dedicated number.
- Free model tiers (OpenRouter ~20 req/min) are dev-tier, not ops-tier — agent
  brain = paid cheap route (DeepSeek/GLM), free as fallback only.
- Vision must exist in roster from day 1 (P1B Struk Okt 2026): on-device
  tesseract.js primary + Gemini Flash fallback.
- All-in-one consumer platforms (Krater/Poe/Monica) not adopted: no API/white-
  label value; OpenRouter + targeted subs cover the need at lower cost.
