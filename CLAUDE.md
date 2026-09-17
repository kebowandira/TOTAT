# TOTAT — CLAUDE.md
# Place at: /opt/totat/CLAUDE.md on NL1
# Claude Code reads this automatically in every session in this directory
# GDrive: https://drive.google.com/drive/folders/1u5dWXJF6eDGy4rkBU3WrLAbxx7J7UWNI


## Project
TOTAT (Toko Catat) | PT Catat Mapan | Owner: BuLe


## Full Context
https://context.totat.my.id/master-brief.md
https://context.totat.my.id/schema.sql


## Server
NL1: 92.112.126.231 (DeluxHost, Ubuntu 24.04, 4core/8GB/80GB)
SSH user: bule
Caddy: systemd-managed, existing config — SEE CADDY RULES BELOW
Structure: /opt/totat/


## CADDY RULES — READ BEFORE ANY CADDY COMMAND
NL1 already runs a systemd-managed Caddy instance serving other sites.
NEVER run: caddy start (would conflict with existing instance)
NEVER run: caddy stop (would kill existing sites)


SAFE commands only:
  systemctl reload caddy        ← reload existing systemd Caddy
  systemctl status caddy        ← check status
  caddy validate --config /etc/caddy/Caddyfile  ← validate before changes


To add TOTAT to existing Caddy:
  Check existing config: cat /etc/caddy/Caddyfile (or wherever it is)
  ADD totat blocks to existing config — do not create separate instance
  Then: systemctl reload caddy


## Structure
/opt/totat/
├── caddy/Caddyfile     ← TOTAT Caddy blocks (merge into existing, do not run separately)
├── sites/[modul]/      ← landing pages (static HTML)
├── apps/[modul]/       ← PWA builds
├── context/            ← AI context files → context.totat.my.id
└── scripts/            ← helper scripts


## Quick Commands
bash /opt/totat/scripts/add-subdomain.sh [modul]
bash /opt/totat/scripts/deploy.sh [modul] ./dist
bash /opt/totat/scripts/backup.sh


## NEVER TOUCH
/opt/totat/apps/warung/ ← live production (on Hercules, not here yet)
Existing Caddy systemd config ← check before any Caddy changes


## Current Status
- TOTAT app: LIVE at warungbeta.totat.my.id via Hercules (NOT on NL1 yet)
- Landing pages (totat.my.id + all [modul].totat.my.id): LIVE on Cloudflare
  Workers (wrangler.jsonc + worker.js host-routing, NOT NL1, NOT classic
  Pages `_redirects`) — confirmed working by BuLe 2026-09-17 after a
  browser cache clear. **MIGRATION IN PROGRESS to CF Pages Classic — see
  below.**
- KNOWN GOTCHA: the Cloudflare dashboard's own "Deployments" build status
  can show a stale "Latest build failed" long after a fix has shipped and
  is live. Don't trust that tab at face value — check the live site
  (clear cache first) or the GitHub Actions/Git-integration deploy result
  before concluding something is actually broken.
- NL1 role: context server (context.totat.my.id) + future self-host (Sep
  2027) — NL1 does NOT serve totat.my.id landing pages (decommissioned,
  see PR #4)
- /opt/totat/ may not exist yet — check before assuming


## MIGRATION IN PROGRESS: Workers → per-subdomain CF Pages Classic
Started 2026-09-17. NOT YET COMPLETE — see checklist below before
assuming either architecture is authoritative.

**Why:** all landing pages are plain static HTML with real cross-domain
`<a href>` links (no client routing, no server logic needed). Cloudflare
Pages Classic gives unlimited free static-asset requests when a project
has zero Functions/Workers logic — better fit than the current Worker,
which is metered against the 100,000 req/day Workers Free plan even
though it does no real work besides a hostname→path rewrite.

**Rejected approach (do not attempt):** one Pages project with all 13+
domains attached as Custom Domains, "routed by path." Verified against
Cloudflare's own docs — Pages custom domains have no per-domain path
mapping, and any routing fix requires a Pages Function, which then bills
identically to Workers and defeats the point.

**Chosen approach:** one Pages project PER subdomain, each with `Root
directory` set to its own `sites/[modul]` folder, no build command, no
Functions — zero request-time logic anywhere.

| Pages project | Root directory | Custom domain | Cutover status |
|---|---|---|---|
| totat-main | `sites/main` | totat.my.id (+www) | pending |
| totat-warung | `sites/warung` | warung.totat.my.id | pending |
| totat-cafe | `sites/cafe` | cafe.totat.my.id | pending |
| totat-sewa | `sites/sewa` | sewa.totat.my.id | pending |
| totat-tamu | `sites/tamu` | tamu.totat.my.id | pending |
| totat-jasa | `sites/jasa` | jasa.totat.my.id | pending |
| totat-talent | `sites/talent` | talent.totat.my.id | pending |
| totat-kanal | `sites/kanal` | kanal.totat.my.id | pending |
| totat-kirim | `sites/kirim` | kirim.totat.my.id | pending |
| totat-jaringan | `sites/jaringan` | jaringan.totat.my.id | pending |
| totat-investor | `sites/investor` | investor.totat.my.id | pending |
| totat-distribusi | `sites/distribusi` | distribusi.totat.my.id | pending |
| totat-karir | `sites/karir` | karir.totat.my.id | pending |

Each domain must be detached from the current "totat" Worker before it
can be attached to its Pages project — cut over one domain at a time and
verify before moving to the next. **NEVER attach `warungbeta.totat.my.id`
to any Pages project** — it's served by Hercules, not this repo.

**HARD RULE — do not rename/delete `wrangler.jsonc` or `worker.js`, and do
not delete the "totat" Worker project, until every row above reads
"live" and has been verified with a fresh (cache-cleared) request, not
just "looks fine in browser."** They are the live fallback until cutover
is fully confirmed. Once complete: rename (not delete —
kept for a possible future dynamic API Worker) to `wrangler.jsonc.bak` /
`worker.js.bak`, delete the Worker's custom domain routes, and update
this section to COMPLETE with the actual completion date.


## context.totat.my.id — Auth
DECIDED: PUBLIC — no auth required (Sep 2026). Schema + conventions only, no user data.
DO NOT expose sensitive financial/user data in context files.