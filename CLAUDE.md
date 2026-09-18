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

Also runs a free/self-hosted AI agent stack (added by BuLe, Sep 2026,
per BuLe: intended to help develop TOTAT) in /opt/totat/ai-stack/ — a
Docker Compose setup, plus a "search."/"ai." Caddy block already in the
existing Caddyfile. As of this note, a Nous Research "Hermes Agent"
install was being planned on top of it (dedicated non-sudo `hermes`
user, Telegram-only gateway, OpenRouter/DeepSeek backends, browser
tool) — NOT verified complete or actually running from this repo's
side; this session has no SSH/server access to NL1, so treat exact
state (what's installed, what's live, ports, RAM headroom) as
BuLe-reported until confirmed from a session with real NL1 access.
Relevant if TOTAT dev work ever wants to use this agent, and as a
capacity-planning factor: NL1 is only 8GB RAM total, already shared
with Caddy, the Dasabo warm-standby mirror, and (eventually, ~Sep 2027)
a possible TOTAT self-host — don't assume unlimited headroom for all of
these running at once.
AI roster v2 + self-host stack: master-brief.md §14-16. Planned =/= installed —
audit NL1 (Phase 0 style) before assuming any service/file/DNS exists.


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
- Landing pages (totat.my.id + all [modul].totat.my.id): LIVE on 13
  separate Cloudflare Pages Classic projects (one per subdomain, each
  with `Root directory` set to its own `sites/[modul]` folder, no
  Functions/Workers logic) — migration completed 2026-09-17, confirmed
  live by BuLe via Tor Browser (cache/CDN-proof check) on every
  subdomain. The old single-Worker host-routing setup
  (wrangler.jsonc/worker.js) is retired — see `wrangler.jsonc.bak` /
  `worker.js.bak` if a future dynamic API Worker is ever built.
- KNOWN GOTCHA: the Cloudflare dashboard's own "Deployments" build status
  can show a stale "Latest build failed" long after a fix has shipped and
  is live. Don't trust that tab at face value — check the live site
  (clear cache first) or the Git-integration deploy result before
  concluding something is actually broken.
- NL1 role: context server (context.totat.my.id) + future self-host (Sep
  2027) — NL1 does NOT serve totat.my.id landing pages (decommissioned,
  see PR #4)
- /opt/totat/ may not exist yet — check before assuming


## Landing page architecture: 13 Cloudflare Pages Classic projects
COMPLETE as of 2026-09-17. Each subdomain is its own independent Pages
project connected to this repo (`kebowandira/TOTAT`, branch `main`),
Root directory pointed at its own `sites/[modul]` folder, no build
command, no Functions — zero request-time logic, genuinely unlimited
free static requests (verified against Cloudflare's pricing docs: this
only holds when a project has no Functions/Workers invoked per request).

| Domain | Root directory | Status |
|---|---|---|
| totat.my.id (+www) | `sites/main` | live |
| warung.totat.my.id | `sites/warung` | live |
| cafe.totat.my.id | `sites/cafe` | live |
| sewa.totat.my.id | `sites/sewa` | live |
| tamu.totat.my.id | `sites/tamu` | live |
| jasa.totat.my.id | `sites/jasa` | live |
| talent.totat.my.id | `sites/talent` | live |
| kanal.totat.my.id | `sites/kanal` | live |
| kirim.totat.my.id | `sites/kirim` | live |
| jaringan.totat.my.id | `sites/jaringan` | live |
| investor.totat.my.id | `sites/investor` | live |
| distribusi.totat.my.id | `sites/distribusi` | live |
| karir.totat.my.id | `sites/karir` | live |

(Exact Cloudflare project names vary slightly from `sites/` folder names
— e.g. `totatcafe`, `totatwarung` — check the Cloudflare dashboard for
the authoritative project list; the Root directory → domain mapping
above is what matters for the repo.)

**NEVER attach `warungbeta.totat.my.id` to any of these Pages projects**
— it's served by Hercules, not this repo.

**Adding a new module in future:** create one more Pages project the
same way (Import Git repo → Root directory `sites/[modul]` → attach
`[modul].totat.my.id`). There is no shared routing file to edit anymore
— each subdomain is fully independent.


## context.totat.my.id — Auth
DECIDED: PUBLIC — no auth required (Sep 2026). Schema + conventions only, no user data.
DO NOT expose sensitive financial/user data in context files.