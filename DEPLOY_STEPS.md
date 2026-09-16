# TOTAT Landing Page — VPS Deployment Guide

This is a **static HTML file**. No database, no app server, no build step.
That is deliberate — it minimizes attack surface. The security of this
deployment depends almost entirely on VPS/server hardening, not on the
page's code.

Recommended target from your existing fleet: **NL1** (4 core / 8GB,
DeluxHost, already has DNS patterns via Cloudflare) or **Dasabo EU3**
(smaller, already earmarked for lightweight static work).

---

## 1. DNS (do this first — propagation takes time)

In Cloudflare, add an A record:
```
totat.my.id      A     <your VPS IP>      (proxied or DNS-only, your choice)
www.totat.my.id  A     <your VPS IP>
```
If using Cloudflare proxy (orange cloud), you get free DDoS mitigation and
can skip the local firewall rate-limiting steps below — Cloudflare absorbs
most of it before it reaches your VPS.

**If proxied, two things to set correctly (both easy to forget):**
1. In Cloudflare → SSL/TLS → Overview, set the mode to **Full** or
   **Full (strict)** once Certbot has issued a real cert on the origin
   (step 4). Leaving it on "Flexible" causes a redirect loop between
   Cloudflare and nginx once HTTPS-only redirect is on at the origin.
2. `deploy/cloudflare-realip.conf` (in this repo) restores the real
   visitor IP from Cloudflare's `CF-Connecting-IP` header — otherwise
   nginx logs will just show Cloudflare's edge IPs. Deploy it alongside
   the site config (step 3). It's a no-op if you choose DNS-only.

---

## 2. Upload the file

From your local machine (note `assets/` now ships alongside `index.html` —
it holds the language-toggle script, moved out of an inline `<script>` so
the nginx CSP can drop `'unsafe-inline'` on `script-src`):
```bash
scp -r index.html assets youruser@<VPS_IP>:/tmp/
```

On the VPS:
```bash
sudo mkdir -p /var/www/totat.my.id
sudo mv /tmp/index.html /tmp/assets /var/www/totat.my.id/
sudo chown -R www-data:www-data /var/www/totat.my.id
sudo chmod -R 755 /var/www/totat.my.id
```

---

## 3. nginx config

Copy both `deploy/totat.my.id.conf` and `deploy/cloudflare-realip.conf`
from this repo to the VPS:
```bash
scp deploy/totat.my.id.conf deploy/cloudflare-realip.conf youruser@<VPS_IP>:/tmp/
```

On the VPS:
```bash
sudo mv /tmp/totat.my.id.conf /etc/nginx/sites-available/totat.my.id
sudo mv /tmp/cloudflare-realip.conf /etc/nginx/conf.d/cloudflare-realip.conf
sudo ln -s /etc/nginx/sites-available/totat.my.id /etc/nginx/sites-enabled/
sudo nginx -t          # test config before reloading — always do this
sudo systemctl reload nginx
```

Before relying on `cloudflare-realip.conf`, double check its IP ranges
against https://www.cloudflare.com/ips/ — Cloudflare's edge ranges
occasionally change and the file says so at the top.

Visit `http://totat.my.id` — it should load over plain HTTP first.

---

## 4. HTTPS via Certbot (Let's Encrypt — free, auto-renewing)

If Certbot isn't installed yet:
```bash
sudo apt update
sudo apt install certbot python3-certbot-nginx -y
```

Then:
```bash
sudo certbot --nginx -d totat.my.id -d www.totat.my.id
```
Certbot will detect the nginx config, ask for an email (for renewal
notices), and offer to auto-redirect HTTP → HTTPS. **Say yes to the
redirect.** It rewrites the config automatically — you don't need to
hand-edit the file afterward.

Certbot sets up auto-renewal via systemd timer by default. Verify:
```bash
sudo systemctl status certbot.timer
```

**Manual follow-up Certbot doesn't do for you: HSTS.** After confirming
`https://totat.my.id` works reliably (give it a few days in case a
rollback is ever needed — HSTS is hard for visitors' browsers to
un-remember), add this line inside the `server { listen 443 ... }` block
Certbot created, then `nginx -t && systemctl reload nginx`:
```
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
```

---

## 5. Baseline VPS hardening checklist (do this once per box, not per site)

If any of these are already true on this VPS from prior setup, skip them —
this is a checklist, not a script to blindly re-run.

- [ ] SSH: key-based auth only, password auth disabled
      (`/etc/ssh/sshd_config` → `PasswordAuthentication no`)
- [ ] SSH: consider moving off port 22 if this box is internet-facing
      and not already behind Cloudflare proxy
- [ ] Firewall: `ufw allow 80,443,22` then `ufw enable` — deny everything
      else by default
- [ ] `fail2ban` installed and running (blocks brute-force SSH attempts)
- [ ] Unattended security upgrades enabled:
      `sudo apt install unattended-upgrades -y`
- [ ] nginx version is current (`nginx -v`, compare to latest stable)

None of this is TOTAT-specific — it's the same checklist that should
already apply to every box in the fleet. If NL1 or Dasabo EU3 already
has this done from earlier work, nothing further needed here.

---

## 6. What this setup does NOT need (and why)

- **No WAF / reverse proxy app** — there's no app logic to protect;
  static files have no injection surface.
- **No database backup routine** — there's no database. The source of
  truth for this page is the `index.html` file itself (and this Claude
  project's memory, which has the content).
- **No dependency scanning** — zero npm/pip packages are used by this
  page. Nothing to have a supply-chain vulnerability in.

If you later add a contact form that emails you, or any server-side
logic, that changes this picture — flag it and we'll revisit hardening
for that specific addition rather than assuming the same "static site"
risk profile still applies.
