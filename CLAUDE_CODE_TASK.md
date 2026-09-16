# TASK: Deploy TOTAT landing page to NL1

## Context for Claude Code
This is a static HTML deployment task on an existing VPS (NL1) that
already runs other services. Read this whole file before doing anything
— the "do not touch" section matters as much as the deploy steps.

## Target server
- Name: NL1 (DeluxHost)
- IP: 92.112.126.231
- Existing hostname: nl1.bule.my.id
- Specs: 4 cores / 8GB RAM / 80GB disk
- **Already running:** a FastAPI heartbeat/dashboard service. Do not
  restart, reconfigure, or stop this service as part of this task. If
  you find it running on port 80 or 443 and conflicting with nginx,
  STOP and report back rather than modifying or killing it — ask BuLe
  first, since it may be intentionally bound there.
- Confirm what's actually running before assuming: run `sudo systemctl
  list-units --type=service --state=running`, check `sudo ss -tlnp`
  for ports 80/443/8000 before touching nginx config.

## Domain
- totat.my.id — already purchased, DNS provider is Cloudflare
  (matches the pattern used for bule.my.id, budilelono.web.id)
- Needs an A record pointed at 92.112.126.231 for both:
  - totat.my.id
  - www.totat.my.id
- If Cloudflare API access is available to you in this environment, set
  this directly. If not, tell BuLe the exact records to add manually
  and wait for confirmation before proceeding to nginx/Certbot steps
  (DNS must propagate before Certbot can issue a cert).

## Files to deploy
These live in the `kebowandira/TOTAT` git repo now (branch
`claude/keen-cannon-pxag51`) — pull from there rather than re-requesting
uploads. If anything below is missing from the repo, STOP and ask BuLe
rather than recreating it from scratch — the HTML content is the approved
final copy (bilingual ID/EN, TOTAT brand colors, contact links already
live) and should not be regenerated.

1. `index.html` — the landing page itself. Its only same-origin
   dependency is `assets/main.js` (the language-toggle script, moved out
   of an inline `<script>` so nginx's CSP can run `script-src 'self'`
   with no `'unsafe-inline'`) — no build step, no external JS beyond
   Google Fonts.
2. `assets/main.js` — the language-toggle script referenced above. Must
   be uploaded alongside `index.html` at the same relative path.
3. `deploy/totat.my.id.conf` — nginx server block; security headers
   (CSP, X-Frame-Options, nosniff, referrer policy, HSTS follow-up noted
   inline) plus a Cloudflare real-IP include.
4. `deploy/cloudflare-realip.conf` — restores real visitor IPs when the
   Cloudflare DNS record is proxied (orange cloud); harmless no-op if
   DNS-only. Deploy to `/etc/nginx/conf.d/` alongside step 3's file.
   Verify its IP ranges against https://www.cloudflare.com/ips/ first.
5. `DEPLOY_STEPS.md` — the full manual walkthrough this brief is based
   on, updated to match the two new files above; use it as reference if
   any step here is ambiguous.

## What to actually do, in order

1. Verify nginx is installed on NL1. If not, install it
   (`sudo apt install nginx -y`).
2. Check for port conflicts with the existing FastAPI service (see
   "do not touch" above) before proceeding.
3. Create `/var/www/totat.my.id/` and upload `index.html` **and**
   `assets/` (keeping the relative path) into it. Set ownership to
   `www-data:www-data`, permissions `755`.
4. Place `deploy/totat.my.id.conf` at
   `/etc/nginx/sites-available/totat.my.id` and `deploy/cloudflare-realip.conf`
   at `/etc/nginx/conf.d/cloudflare-realip.conf`, symlink the site conf
   into `sites-enabled/`, run `nginx -t` to validate BEFORE reloading. If
   `nginx -t` fails, stop and report the error rather than force-reloading.
5. Reload nginx (`systemctl reload nginx`), confirm `http://totat.my.id`
   resolves and serves the page (once DNS has propagated).
6. Run Certbot for HTTPS:
   `sudo certbot --nginx -d totat.my.id -d www.totat.my.id`
   Accept the HTTP→HTTPS redirect prompt. Certbot will rewrite the
   nginx config automatically for the HTTPS block — do not hand-edit
   after this for the redirect itself.
7. Verify auto-renewal timer is active:
   `systemctl status certbot.timer`
8. Confirm final result by fetching `https://totat.my.id` and checking
   the response is 200 with the expected page title.
9. If the DNS record is Cloudflare-proxied (orange cloud), set
   Cloudflare SSL/TLS mode to Full or Full (strict) now that a real cert
   exists on the origin — see DEPLOY_STEPS.md step 1 for why.
10. A few days after confirming HTTPS is stable, add the HSTS header
    inside Certbot's new `listen 443` block (exact line in
    DEPLOY_STEPS.md step 4) and reload nginx. This is the one
    intentional exception to "don't hand-edit after Certbot" — it's a
    header addition, not a structural change to what Certbot manages.

## Baseline hardening — only if NOT already true on this box
NL1 may already have some of this from prior setup. Check before
re-running anything:
- SSH key-only auth (no password auth)
- ufw firewall allowing only 22, 80, 443
- fail2ban active
- unattended-upgrades enabled

If these are already configured (likely, since NL1 is an established
box in the fleet), skip and note that they were already in place.

## Explicitly out of scope for this task
- Do not touch the existing FastAPI heartbeat/dashboard service
- Do not modify DNS for any other domain on this account
- Do not add a database, backend, or contact-form processing — this
  page is static by design; if a future task asks for a working
  contact form, that's a separate task with its own security review,
  not an extension of this one
- Do not regenerate or "improve" the HTML content — it's approved
  copy; only fix something in it if there's a genuine deployment-
  breaking bug (e.g. a bad relative path), and say what you changed
  and why if you do

## Report back with
- Final live URL confirmation (https://totat.my.id)
- Whether any conflicts were found with the existing FastAPI service
- Whether hardening steps were already in place or newly applied
- Certbot renewal timer status
