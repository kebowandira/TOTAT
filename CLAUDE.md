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
- NL1 role: context server + landing pages + future self-host (Sep 2027)
- /opt/totat/ may not exist yet — check before assuming


## context.totat.my.id — Auth
DECIDED: PUBLIC — no auth required (Sep 2026). Schema + conventions only, no user data.
DO NOT expose sensitive financial/user data in context files.