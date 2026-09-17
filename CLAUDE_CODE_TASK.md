# TASK: Deploy TOTAT landing page to NL1 — SUPERSEDED, kept for history

**This entire plan no longer applies.** BuLe decided (2026-09-17) to
standardize on Cloudflare Pages for all landing pages — less load on
NL1, and it's already working (see `sites/` + PR #3, merged). The root
`index.html`, `assets/`, and `deploy/Caddyfile.totat-site` this file
references have been deleted from the repo; NL1 no longer serves
`totat.my.id` in any form, redirect included.

NL1's actual remaining scope is `context.totat.my.id` / `api.totat.my.id`
(dynamic services) and the eventual 2027 self-host migration — see
`TOTAT_ClaudeCode_Master_v5.md` Task 5 (GDrive) for that, not this file.

Kept below only as a record of what was tried and why it changed.

## Context for Claude Code
This is a static HTML deployment task on an existing VPS (NL1) that
already runs other services. Read this whole file before doing anything
— the "do not touch" section matters as much as the deploy steps.

## Documents disagree about NL1 — resolve this live before proceeding
Three sources describe NL1 differently, and they can't all be the
complete picture:
1. This file (earlier version) claimed NL1 runs "a FastAPI
   heartbeat/dashboard service."
2. A separate FOUNDATION setup prompt referenced `/opt/totat/apps/warung/`
   as live production on NL1, under its own Caddy config.
3. `claude-shared-context/INFRASTRUCTURE_SUMMARY.md` (Google Drive) says
   NL1 runs **Caddy** as a warm-standby mirror of Dasabo's WordPress/Grav
   sites — no mention of FastAPI or TOTAT at all.

**Do not trust any one of these. Verify live, first:**
```bash
sudo systemctl list-units --type=service --state=running
sudo ss -tlnp
ls /opt/totat 2>/dev/null
```
This task's steps below assume (3) is current (it's the most recently
updated, purpose-built handoff doc) — but confirm against the box itself
before touching config. If you find something that contradicts all three
descriptions, STOP and report back rather than guessing.

## Target server
- Name: NL1 (DeluxHost)
- IP: 92.112.126.231
- Existing hostname: nl1.bule.my.id
- Specs: 4 cores / 8GB RAM / 80GB disk — most free headroom in the fleet
- SSH: user `bule`, port **2299** (not 22), key `~/.ssh/nl1_new` on the
  operator's machine — `ssh -p 2299 -i ~/.ssh/nl1_new bule@92.112.126.231`.
  Never `cat`/paste private key contents into any chat session; reference
  by path only.
- **Already running (per the infra doc):** Caddy, PHP-FPM, MariaDB,
  serving a warm-standby mirror of Dasabo's production sites
  (`globalenglish-academy.com`, `bule.my.id`), plus an OpenVPN server.
  **Do not touch those other Caddy site blocks, MariaDB, or the OpenVPN
  config** — they are live/standby infrastructure for a different
  project. Adding totat.my.id means appending one new site block to the
  existing Caddyfile, nothing more.
- If you find something bound to 80/443 that doesn't match this
  description (e.g. an actual FastAPI service), STOP and report back
  rather than modifying or killing it — ask BuLe first.

## Domain
- totat.my.id — already purchased, DNS provider is Cloudflare
  (matches the pattern used for bule.my.id, budilelono.web.id)
- Needs an A record pointed at 92.112.126.231 for both:
  - totat.my.id
  - www.totat.my.id
- If Cloudflare API access is available to you in this environment, set
  this directly. If not, tell BuLe the exact records to add manually and
  wait for confirmation before proceeding — DNS must resolve before
  Caddy's automatic HTTPS (step below) can issue a cert.

## Files to deploy
These live in the `kebowandira/TOTAT` git repo now (branch `main`, or
`claude/keen-cannon-pxag51` for in-progress work) — pull from there
rather than re-requesting uploads. If anything below is missing from the
repo, STOP and ask BuLe rather than recreating it from scratch — the HTML
content is the approved final copy (bilingual ID/EN, TOTAT brand colors,
contact links already live) and should not be regenerated.

1. `index.html` — the landing page itself. Its only same-origin
   dependency is `assets/main.js` (the language-toggle script, moved out
   of an inline `<script>` so the CSP can run `script-src 'self'` with no
   `'unsafe-inline'`) — no build step, no external JS beyond Google Fonts.
2. `assets/main.js` — the language-toggle script referenced above. Must
   be uploaded alongside `index.html` at the same relative path.
3. `deploy/Caddyfile.totat-site` — the Caddy site block to append to
   NL1's existing Caddyfile. Includes security headers (CSP,
   X-Frame-Options, nosniff, referrer policy, HSTS) and blocks
   dotfile/config-file access. Caddy handles HTTPS automatically — there
   is no separate Certbot step (this superseded an earlier nginx+Certbot
   plan that was based on a wrong assumption about what NL1 runs).
4. `DEPLOY_STEPS.md` — the full manual walkthrough this brief is based
   on; use it as reference if any step here is ambiguous.
5. `claude-shared-context/` (`master-brief.md`, `master-brief-short.md`,
   `schema.sql`, `conventions.md`) and root-level `AGENTS.md`/`CLAUDE.md`
   — the multi-AI context bundle per `TOTAT_AI_Master_Guide_v2.md`
   (GDrive). Not part of the landing-page deploy itself; relevant if a
   future task wires up `context.totat.my.id` to sync from this repo.

**Caddy block conflict, resolve before merging:** if `nl1-setup.sh` (GDrive
foundation folder) has already run on NL1, it generates its own
`totat.my.id { ... }` block in `/opt/totat/caddy/totat-blocks.caddy`
pointing at `/opt/totat/sites/main` with no security headers and no
`www.totat.my.id` handling. **Use `deploy/Caddyfile.totat-site` from this
repo instead for that domain** — it's the more complete definition. Merge
the rest of `totat-blocks.caddy` (other subdomains, `context.totat.my.id`,
`app.totat.my.id`) normally; just don't merge both `totat.my.id` blocks or
Caddy will reject the duplicate address on validate.

## What to actually do, in order
1. Run the live verification commands above; reconcile against this doc.
2. Create `/var/www/totat.my.id/` and upload `index.html` **and**
   `assets/` (keeping the relative path) into it. Set ownership to
   `www-data:www-data`, permissions `755`.
3. Locate NL1's actual Caddyfile (`sudo systemctl show caddy -p
   FragmentPath`, or check the caddy systemd unit). Append the contents
   of `deploy/Caddyfile.totat-site` to it — **do not modify the existing
   site blocks already in that file**.
4. Validate before reloading: `sudo caddy validate --config <path>`. If
   validation fails, stop and report the error rather than force-reloading.
5. `sudo systemctl reload caddy`. Caddy will automatically provision
   HTTPS via Let's Encrypt once DNS resolves — no Certbot command needed.
6. Confirm `https://totat.my.id` returns 200 with the expected page
   title. If HTTPS doesn't come up, check `sudo journalctl -u caddy -n
   50` for ACME errors before assuming something is broken.
7. If the DNS record is Cloudflare-proxied (orange cloud), set Cloudflare
   SSL/TLS mode to Full or Full (strict) once Caddy's cert is confirmed
   live.

## Baseline hardening — already confirmed in place
Per `claude-shared-context/INFRASTRUCTURE_SUMMARY.md` (dated 2026-09-16),
the entire fleet including NL1 already has: SSH key-only auth with root
login disabled, SSH on a non-default port, UFW, Fail2Ban, and
unattended-upgrades. **This is confirmed, not speculative — nothing to
re-run.** The one open item noted in that doc: NL1's SSH access hadn't
been re-verified very recently as of that writing, so confirm the SSH
command above still connects before relying on it.

## Explicitly out of scope for this task
- Do not touch Dasabo's mirrored site blocks, MariaDB, or OpenVPN config
  on NL1 — see "Already running" above.
- Do not modify DNS for any other domain on this account.
- Do not add a database, backend, or contact-form processing — this page
  is static by design; if a future task asks for a working contact form,
  that's a separate task with its own security review, not an extension
  of this one.
- Do not regenerate or "improve" the HTML content — it's approved copy;
  only fix something in it if there's a genuine deployment-breaking bug
  (e.g. a bad relative path), and say what you changed and why if you do.

## Report back with
- Final live URL confirmation (https://totat.my.id)
- What you actually found running on NL1 vs. what this doc predicted —
  call out any mismatch explicitly, don't just silently proceed
- Whether hardening was already in place (expected) or something was
  missing (unexpected — flag it)
- Confirmation Caddy's automatic HTTPS is live and has a valid cert
