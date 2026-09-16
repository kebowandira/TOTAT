# TOTAT Landing Page — VPS Deployment Guide

This is a **static HTML file**. No database, no app server, no build step.
That is deliberate — it minimizes attack surface. The security of this
deployment depends almost entirely on VPS/server hardening, not on the
page's code.

Target: **NL1** (DeluxHost, 92.112.126.231) — confirmed by
`claude-shared-context/INFRASTRUCTURE_SUMMARY.md` (Google Drive) to have
the most free RAM/CPU/disk of the fleet.

**Read this before anything else: what "NL1" actually runs is disputed
between documents.** The infra summary says NL1 runs **Caddy**, already
serving as a warm-standby mirror of Dasabo's WordPress/Grav sites
(`globalenglish-academy.com`, `bule.my.id`) — no mention of nginx, and no
mention of TOTAT. A separate, earlier brief claimed NL1 runs "a FastAPI
heartbeat/dashboard service" instead. Neither claim should be trusted
blind. **Before touching anything, run on NL1 itself:**
```bash
sudo systemctl list-units --type=service --state=running
sudo ss -tlnp
ls /opt/totat 2>/dev/null
sudo caddy list-modules >/dev/null 2>&1 && echo "caddy present"
```
Reconcile what you actually see against this doc before proceeding — this
guide assumes Caddy is real and current, but verify first.

---

## 0. SSH access

Per `claude-shared-context/INFRASTRUCTURE_SUMMARY.md`:
```bash
ssh -p 2299 -i ~/.ssh/nl1_new bule@92.112.126.231
```
- User `bule`, sudo-enabled, key-only auth (password auth and root login
  are already disabled at the OS level).
- **Never `cat`, open, or paste a private key's contents into a chat
  session for any reason** — reference it by path only and let the `ssh`
  binary read it directly. (This exact mistake has burned keys on this
  project before.)

---

## 1. DNS (do this first — propagation takes time)

In Cloudflare, add an A record:
```
totat.my.id      A     92.112.126.231      (proxied or DNS-only, your choice)
www.totat.my.id  A     92.112.126.231
```
If using Cloudflare proxy (orange cloud), you get free DDoS mitigation and
can skip local firewall rate-limiting — Cloudflare absorbs most of it
before it reaches the VPS.

**If proxied:** once Caddy has issued its automatic cert (step 4 — no
Certbot involved, see below), set Cloudflare → SSL/TLS → Overview to
**Full** or **Full (strict)**. Leaving it on "Flexible" causes a redirect
loop once Caddy's HTTP→HTTPS redirect is live.

---

## 2. Upload the site files

From your local machine (`assets/` ships alongside `index.html` — it
holds the language-toggle script, moved out of an inline `<script>` so
the CSP below can drop `'unsafe-inline'` on `script-src`):
```bash
scp -P 2299 -i ~/.ssh/nl1_new -r index.html assets bule@92.112.126.231:/tmp/
```

On the VPS:
```bash
sudo mkdir -p /var/www/totat.my.id
sudo mv /tmp/index.html /tmp/assets /var/www/totat.my.id/
sudo chown -R www-data:www-data /var/www/totat.my.id
sudo chmod -R 755 /var/www/totat.my.id
```
(`www-data` ownership is standard even under Caddy, which by default
runs as its own user but only needs read access to this directory.)

---

## 3. Caddy site block (NOT nginx — see the warning at the top)

NL1 already runs Caddy for other sites. Do not install nginx — a second
web server fighting Caddy for ports 80/443 is the exact mistake this repo
made earlier before the real infra doc was found. Instead, **append** the
block in `deploy/Caddyfile.totat-site` (this repo) to NL1's existing
Caddyfile.

Find the live Caddyfile first — its path isn't documented, don't assume:
```bash
sudo systemctl show caddy -p FragmentPath
# or: ps aux | grep 'caddy run' , or check /etc/caddy/, /opt/*/Caddyfile
```

Then, on the VPS, open that file and paste in the contents of
`deploy/Caddyfile.totat-site` (copy it over first: `scp -P 2299 -i
~/.ssh/nl1_new deploy/Caddyfile.totat-site bule@92.112.126.231:/tmp/`).
**Do not touch the other site blocks already in that file** — Dasabo's
mirrored sites are live production traffic on this same box.

**If `nl1-setup.sh` (from the GDrive foundation folder) has already run
on this box:** it writes its own `totat.my.id { ... }` block into
`/opt/totat/caddy/totat-blocks.caddy`, pointing at `/opt/totat/sites/main`
with no CSP/HSTS headers and no `www.totat.my.id` handling. **Skip that
specific block when merging** — use `deploy/Caddyfile.totat-site` from
this repo for `totat.my.id`/`www.totat.my.id` instead, since it's the
more complete definition (hardened headers, both hostnames). The rest of
`totat-blocks.caddy` (the other subdomains, `context.totat.my.id`,
`app.totat.my.id`) doesn't conflict with anything in this repo and can be
merged as-is. Applying both `totat.my.id` blocks together will make Caddy
either reject the duplicate site address on `caddy validate`, or have one
silently shadow the other — don't merge both.

Validate and reload:
```bash
sudo caddy validate --config <path-to-Caddyfile>
sudo systemctl reload caddy
```

Visit `http://totat.my.id` — Caddy should already be redirecting to
HTTPS by this point (see step 4).

---

## 4. HTTPS — handled automatically by Caddy

Unlike nginx+Certbot, **Caddy provisions and renews Let's Encrypt certs
on its own** the moment a domain in its config resolves to this server —
there is no separate install step, no `certbot` command, and no cron/timer
to verify. As long as DNS (step 1) resolves to NL1 before you reload
Caddy, HTTPS should just work.

HSTS is already included in `deploy/Caddyfile.totat-site`'s header block
(`Strict-Transport-Security`), unlike the old nginx plan where it needed a
manual post-Certbot step.

If HTTPS doesn't come up: check `sudo journalctl -u caddy -n 50` for ACME
errors (common causes: DNS not yet propagated, or Cloudflare proxy
blocking the ACME challenge — try DNS-only temporarily to confirm, then
re-enable proxy).

---

## 5. Baseline VPS hardening — already confirmed done fleet-wide

Per `claude-shared-context/INFRASTRUCTURE_SUMMARY.md`, all three fleet
boxes (including NL1) are already: Ubuntu 24.04 LTS, UFW + Fail2Ban +
unattended-upgrades active, SSH key-only with root login disabled, SSH
moved to a non-default port (2299 for NL1). **Nothing to do here** —
this is confirmed current as of 2026-09-16, not speculative.

The one thing worth a live check per the infra doc's own "known open
items": NL1's SSH access hadn't been re-verified very recently as of that
writing. Confirm `ssh -p 2299 -i ~/.ssh/nl1_new bule@92.112.126.231` still
works before relying on it for this deployment.

---

## 6. What this setup does NOT need (and why)

- **No WAF / reverse proxy app** — there's no app logic to protect;
  static files have no injection surface.
- **No database backup routine** — there's no database. The source of
  truth for this page is the `index.html` file itself, tracked in git.
- **No dependency scanning** — zero npm/pip packages are used by this
  page. Nothing to have a supply-chain vulnerability in.
- **No Certbot** — Caddy's built-in ACME client replaces it entirely.

If you later add a contact form that emails you, or any server-side
logic, that changes this picture — flag it and revisit hardening for that
specific addition rather than assuming the same "static site" risk
profile still applies.
