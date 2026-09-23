# Infrastructure Summary — for handoff to other Claude sessions

**Last updated:** 2026-09-18
**Purpose:** Point any new Claude Code session at this file so it has working knowledge of existing servers before planning new work (e.g., where to deploy a new app) — avoids the exact mistake of a context-free session suggesting `ssh root@...` against a hardened box.

## Location — this file lives in two places, on purpose

- **Local (this machine, user `yohanes.budi`):** `D:\CLAUDE\REBUILD\INFRASTRUCTURE_SUMMARY.md`
- **Google Drive:** `claude-shared-context/INFRASTRUCTURE_SUMMARY.md` (same Drive account the VPS backups use, in its own separate folder — not mixed in with `vps-id1-backups/`)

**Whichever copy you're reading, say so explicitly** when referencing this doc to the user or to another session — don't just say "the infra doc," name which path you actually read, since the two can drift out of sync between edits.

**Mandatory: any edit to this file must be pushed to both locations before the edit is considered done.** A local-only edit is not finished — a cloud/claude.ai-hosted session (no local filesystem access) can only ever see the Drive copy, so an un-synced local edit is invisible to exactly the sessions this file exists to serve. If you have local shell access: write the local file, then `sftp`/`scp` it to a box with a working `rclone` (Dasabo does) and run `rclone copy` to `gdrive:claude-shared-context/`. If you only have Drive access: edit the Drive copy directly and note in your response that the local copy is now stale until someone with local access reconciles it.

## Servers

| Name | IP | Role | Specs |
|---|---|---|---|
| Dasabo (EU3) | 43.240.149.38 (changed 2026-09-2x, was 102.215.228.85) | **Live production** — 3 websites | 1 vCPU / 1GB RAM (no swap) / 10GB disk — **being decommissioned, see below** |
| DeluxHost NL1 | 62.105.222.90 (changed 2026-09-20/21, was 92.112.126.231) | **Warm standby** for Dasabo's sites + OpenVPN, also hosts LinguaKid + the Hermes/TOTAT ops agent | 4 vCPU / 8GB RAM / 80GB disk |
| MassiveGrid | 185.44.64.182 | OpenVPN-only endpoint | 1 vCPU / 961MB RAM (1GB swap) / 30GB disk |
| MAIL1 (EU2) | 43.240.149.83 (changed 2026-09-2x, was 45.146.202.198) | **Live production** — Mailu mail server (`mail1.gord.my.id`, hosts `bule.my.id` mail incl. `iam@bule.my.id`) | 1 vCPU / 1GB RAM / 10GB disk — same provider account as Dasabo, **being decommissioned, see below** |

### Dasabo + MAIL1 planned decommission (owner decision, 2026-09-2x)

Dasabo's renewal price increased from EUR18/year to EUR30/year — owner considers this too expensive and will **not renew**. Plan: let both Dasabo and MAIL1 lapse, then **restore/recreate both the CMS and mail server around early 2027** (presumably on cheaper replacement infrastructure, not yet chosen). This makes the backup system for both boxes genuinely load-bearing, not routine — **treat any backup gap on either box as high-priority** until the actual migration happens. If a future session is asked to help with "the 2027 restore," start by pulling the latest backups from `gdrive:vps-id1-backups/` (Dasabo/CMS) and wherever MAIL1's backup ends up (see below, being set up 2026-09-2x) rather than assuming either original server is still reachable.

All four: Ubuntu, hardened (key-only SSH, root login disabled). MAIL1 confirmed 133+ days uptime as of 2026-09-18.

**Resource note for new app deployment decisions:** Dasabo is the tightest box — already running 3 sites + MariaDB + OpenVPN, ~468MB RAM available with no swap. NL1 has the most spare headroom by far. Prefer NL1 for anything new unless there's a specific reason to colocate with the existing sites.

## SSH access

- User `bule` on all three, sudo-enabled, key-only (password auth and root login disabled everywhere)
- Dasabo: port **2298**. NL1: port **2299**. MassiveGrid: port **2300**.
- Personal key for Dasabo: `id1_v3` (in `~/.ssh/`) — current as of 2026-09-14.
- **Personal key for NL1: `~/.ssh/nl1_new` — confirmed working 2026-09-23**. Use directly (note the new IP, see incident below):
  `ssh -p 2299 -i ~/.ssh/nl1_new bule@62.105.222.90`
- MassiveGrid personal/agent keys from July 2026 have **not** been re-verified — assume they may need the same VNC-console recovery process Dasabo went through in Sept 2026, if login fails.
- **MAIL1: port 27194** (non-default, changed by the user at some point — not the 2298/2299/2300 pattern the other three follow). User `bule`. Personal key: `~/.ssh/mail1_ed25519` — confirmed working 2026-09-23 at the new IP:
  `ssh -p 27194 -i ~/.ssh/mail1_ed25519 bule@43.240.149.83`
  **Rotate this key when convenient** — the original credential was stored as a plaintext PuTTY (.ppk) key inside `VPS.xlsx`, and its contents passed through an assistant session's tool output on 2026-09-18 while being converted to OpenSSH format. Treat it as exposed, same class of incident as the Sept 2026 key burns. `VPS.xlsx` also has an inline root password and a "PRIVATE KEY"/"PUBLIC KEY" notes block (rows 9–13) for MAIL1 — same exposure risk, worth clearing out of the spreadsheet once rotated and moving to Bitwarden only.
- **Important pattern discovered 2026-09-14:** Claude's own *agent* keys (the ones an assistant generates for itself, as opposed to the user's personal key) get written into that session's temp scratchpad directory, which does not persist across sessions and does not carry over between different Claude Code sessions/windows even on the same machine. A user's own personal key (like `id1_new`, `nl1_new`) in `~/.ssh/` is a normal persistent file and *does* work across any Claude Code session on this machine — prefer pointing new sessions at the user's personal key rather than assuming an agent key still exists.
- All root/sudo passwords are in Bitwarden only — never in any file on disk or in chat. **Do not read, `cat`, open, or attach a private key file's contents in any chat session for any reason — always let the `ssh` binary (or an SSH library) reference it by path so the key material itself never appears in a transcript.** (Two of this project's keys were burned this exact way in Sept 2026 — see git history / prior conversation.)

## What's running where

**Dasabo:**
- Caddy (reverse proxy, auto-HTTPS) serving `globalenglish-academy.com` (WordPress), `bule.my.id` (Grav), `newsite.globalenglish-academy.com` (Grav redesign draft)
- MariaDB (WordPress DB only)
- PHP-FPM 8.3
- OpenVPN server (port 51194/udp, subnet 10.8.0.0/24) — road-warrior + site-to-site link from NL1
- Nightly backups to Google Drive (`gdrive:vps-id1-backups/`), pulled nightly by NL1 to stay in sync

**NL1:**
- Same stack as Dasabo (Caddy/PHP-FPM/MariaDB), holding a restored mirror of the same 2 production sites as a warm standby (self-signed cert until actually promoted — see `FAILOVER_RUNBOOK.md`)
- OpenVPN server (port 51195/udp, subnet 10.9.0.0/24)
- Currently has the most free RAM/CPU/disk of the three boxes
- **Caddy already has the Cloudflare DNS-01 ACME module built in, with an API token already configured** — any new site added to NL1 on a Cloudflare-managed domain can get a real Let's Encrypt cert via DNS-01 immediately, no self-signed `tls internal` workaround needed and no new Cloudflare token setup required. Give the new site its own Caddy site-block file (imported by both `Caddyfile` and `Caddyfile.promoted`) so a Dasabo-failover promotion doesn't wipe it. Still requires the actual DNS A record to be created at the registrar/Cloudflare (outside SSH, the user's own step). **Currently in use by:** the LinguaKid project (`linguakid.bule.my.id`) — see that project's own docs for its specific deployment notes.

**MassiveGrid:**
- OpenVPN only (port 51196/udp, subnet 10.10.0.0/24) — no web stack, this box hosts nothing else

**MAIL1:**
- Mailu (docker-compose stack at `/mailu/docker-compose.yml`): `admin`, `smtp` (postfix), `imap` (dovecot), `antispam` (rspamd), `webmail`, `front` (nginx), `redis` containers
- User `bule` is in the `docker` group — no sudo needed for `docker`/`docker-compose` commands
- Password changes via CLI: `docker-compose exec -T admin flask mailu password <localpart> <domain> '<newpassword>'` (run from `/mailu`) — pass the password through a temp file piped in rather than as a literal CLI arg where possible, to keep it out of shell history/process list
- `iam@bule.my.id` password was rotated 2026-09-18 by an assistant session; new value handed to the user directly, not stored in this doc or in chat

## Key documents already on disk

- `D:\CLAUDE\REBUILD\FAILOVER_RUNBOOK.md` — how to promote NL1 if Dasabo goes down
- `D:\CLAUDE\REBUILD\openvpn-clients\` — `.ovpn` client profiles for laptop/mobile, one pair per server
- `SERVER_ID1_REBUILD.md`, `SITE_RECORD_*.md` — original rebuild planning docs (historical, mostly superseded now that both sites are live)

## Cloudflare CLI / plugin / MCP (this Windows machine, user `yohanes.budi`)

**As of 2026-09-16**, unrelated to the VPS servers above, but added to this handoff doc since another session asked "where's the Cloudflare setup" and this is the shared cross-session pointer file:

- No admin access on this machine — Node.js LTS, npm, and the `claude` CLI were installed **user-scope only** (`winget install --scope user`, npm global into that user-writable Node install). Portable Git already existed at `D:\PortableGit\mingw64\bin` and was added to the user `PATH` so the CLI could find `git`.
- Claude Code plugin marketplace `cloudflare/skills` added, and the `cloudflare@cloudflare` plugin installed (user scope) — bundles ~13 Cloudflare skills (wrangler, workers-best-practices, agents-sdk, durable-objects, nextjs-on-cloudflare, sandbox-stable/next/migrate, cloudflare-one + migrations, cloudflare-email-service, turnstile-spin, web-perf, product-discovery).
- That plugin also registers Cloudflare's official remote MCP server, `plugin:cloudflare:cloudflare` → `https://mcp.cloudflare.com/mcp`, which **is authenticated and connected** to the user's real Cloudflare account (confirmed via `claude mcp list` → `✓ Connected`).
- Any Claude Code session running on this same machine/user account already has access to all of this (same `~/.claude` config, same user PATH) — no extra setup needed. A session elsewhere (different machine/account) would need to redo the install + `claude mcp login "plugin:cloudflare:cloudflare"` (must be run in a real interactive terminal tab, not a scripted/non-interactive shell — the OAuth callback needs a live TTY).

## Backup system (updated 2026-09-18 — read this before assuming backups are running)

**Incident:** between 2026-09-16 and 2026-09-18, both Dasabo's and NL1's rclone configs AND crontabs went missing entirely (cause unknown — not caused by any known session's actions; discovered while working on an unrelated project). Nightly backups had silently stopped. Fixed as follows:

- **rclone configs recreated** on both boxes: Dasabo now has TWO working configs — `/root/.config/rclone/rclone.conf` (used by the backup/restore scripts below) and `/home/bule/.config/rclone/rclone.conf` (used for this doc's own shared-context sync, and other `bule`-run tasks). **These are separate remotes for separate purposes — don't assume they're interchangeable or merge the workflows.** NL1's config was rebuilt by copying Dasabo's working one over (same method as the original setup, no fresh OAuth needed).
- **Backup cadence changed from 7-daily/4-weekly to weekly(4) for everything**, per owner's explicit choice on 2026-09-18. `backup-wp-files.sh` was already weekly/keep-4; `backup-grav.sh` and `backup-wp-db.sh` had their `KEEP=7` changed to `KEEP=4` to match. All three now run via root's crontab on Dasabo, Sundays 02:00/02:10/02:20 WIB (staggered). NL1's `restore-grav.sh`/`restore-wp.sh` (pull the latest backup down to keep the warm-standby mirror current) run via root's crontab on NL1, Sundays 03:00/03:15 WIB (staggered to run after Dasabo's uploads finish).
- **Security fix:** `restore-wp.sh` on NL1 had the MySQL root password **hardcoded in plaintext** (`mysql -u root -p'...'`) since the original build — a direct violation of this project's very first rule (no secrets on disk outside Bitwarden). Fixed: password moved to `/root/.restore_my.cnf` (600, root-owned, mirroring Dasabo's own `/root/.backup_my.cnf` pattern), script now uses `--defaults-extra-file`. A timestamped `.bak` of the original script was kept on NL1 (`/usr/local/bin/restore-wp.sh.bak-<timestamp>`). Verified the new credentials file authenticates correctly before trusting it. **If you ever read an old copy of `restore-wp.sh` from before 2026-09-18, do not reuse the password shown in it — checked whether Dasabo's or NL1's live MySQL passwords should also be rotated is still an open question, not yet decided.**

## NL1 IP address change (2026-09-20/21) — read this if anything still references the old IP

DeluxHost had a provider-side routing incident affecting subnet `92.112.124.0/22` (NL1's old IP `92.112.126.231` fell inside it), causing intermittent unreachability from certain networks starting ~2026-09-20. DeluxHost's fix was to **permanently replace the affected IPv4 address** rather than just fix routing — NL1's public IP is now **`62.105.222.90`**. Per DeluxHost: disk/OS/config unchanged, only the public IP changed. Confirmed via SSH host-key comparison (identical key at both IPs) that this is genuinely the same server, not a different box.

What was checked/fixed as of 2026-09-23:
- SSH access: works fine at the new IP once its host key is added to `known_hosts` (was previously only known for the old IP) — use `ssh-keyscan -p 2299 -t ed25519,rsa,ecdsa 62.105.222.90` to add it if a session hits "Host key verification failed."
- DNS: `agent.totat.my.id` and `linguakid.bule.my.id` (both on the `totat.my.id`/Cloudflare-managed zones) were **already updated to the new IP by the time this was checked** — no action needed, someone/something (possibly another session, possibly the owner) beat this session to it.
- OpenVPN client profiles (`D:\CLAUDE\REBUILD\openvpn-clients\nl1-laptop.ovpn`, `nl1-mobile.ovpn`): updated `remote 92.112.126.231 51195` → `remote 62.105.222.90 51195`. Re-deliver these two files to the user's devices if they're actually used for road-warrior access — the ones on disk are now correct but a phone/laptop that imported the old file won't auto-update.
- NL1 itself never rebooted or lost data (`uptime` showed continuous runtime spanning the whole incident) — this was purely a network-path problem, not a server outage.
- **Not yet checked:** whether NL1's own outbound OpenVPN client (`openvpn-client@dasabo-link`, connects NL1 → Dasabo) needs anything touched — it shouldn't, since it's an outbound connection to Dasabo's IP (unaffected) and doesn't care about NL1's own public IP, but worth a health check next time someone's in there.
- **Also discovered while investigating this:** Dasabo (102.215.228.85) is separately showing the *same symptom pattern* (SSH/ping unreachable, but the actual live sites at globalenglish-academy.com/bule.my.id respond fine over HTTPS) — see the entry below. Unclear yet if this is the same root cause (Cogent/transit routing near Amsterdam) or a coincidence.

## Dasabo + MAIL1 IP change (2026-09-2x) — resolved, same cause as NL1's incident

Both Dasabo and MAIL1 hit the same provider-side routing/IP-replacement issue as NL1 (see NL1 section above) — confirmed by the owner, not a coincidence. Old → new:
- Dasabo: `102.215.228.85` → `43.240.149.38` (`eu3.bule.my.id`)
- MAIL1: `45.146.202.198` → `43.240.149.83` (`mail1.gord.my.id`)

Both confirmed reachable via SSH at their new IPs, both up continuously since before the change (no reboot, pure IP reassignment — same pattern as NL1). DNS for `bule.my.id`, `globalenglish-academy.com`, and `mail1.gord.my.id` was **already correctly pointing to the new IPs** by the time this was checked (2026-09-23) — no DNS action was needed. (Earlier same-day notes in this file describing Dasabo as mysteriously unreachable were this exact issue, not a separate unexplained problem — since resolved.)

## MAIL1 credentials + full backup (2026-09-23)

- **MAIL1's `bule` sudo password was reset via VNC console** on 2026-09-23 (owner suspected it was still an old/pre-hardening password — confirmed and fixed). New password is in Bitwarden only, not written here. If a future session's cached/remembered password fails on MAIL1, this is why — don't assume the key itself is broken, check whether the sudo password was rotated.
- **Full one-off backup of MAIL1's Mailu stack** taken 2026-09-23, ahead of the planned 2027 decommission (see IP-change section above) — this is a complete `/mailu/` tarball (certs, admin data, DKIM keys, mail — 493MB of actual mailbox data — mailu.env, overrides, webmail; deliberately excluding the transient `mailqueue` and `redis` cache dirs), transferred to `gdrive:mail1-backups/` via a direct mail1→NL1 SSH pipe (NL1 has a working rclone config; MAIL1 itself has never had one set up). This is a **new backup location** — separate from `gdrive:vps-id1-backups/` (Dasabo/CMS) and `gdrive:claude-shared-context/` (docs). Not yet on a recurring schedule — this was a manual one-off; **set up a real recurring backup for MAIL1 before relying on this long-term**, especially given the 2027 restore plan.
- **DKIM gap on `gord.my.id` — found and fixed 2026-09-23.** MX/SPF/DMARC were already correct, and the mail-serving A records are correctly DNS-only. DKIM keys exist on the server for 5 domains (`gord.my.id`, `bule.my.id`, `budilelono.web.id`, `cepekdulu.com`, `globalenglish-academy.com` — all in `/mailu/dkim/` on MAIL1), but `gord.my.id` had no matching DKIM TXT record published. **Fixed:** derived the public key from `/mailu/dkim/gord.my.id.dkim.key` (`openssl pkey -pubout`, safe — public key only, private key never left the server) and published `dkim._domainkey.gord.my.id` as a TXT record via the Cloudflare API. Selector confirmed as `dkim` (Mailu's default — no override found in `mailu.env` or `/mailu/overrides/`) by cross-checking against `bule.my.id`'s DKIM record, which was **already correctly published since 2025-04-01** and whose content exactly matches a fresh derivation from its own key file — strong confirmation the method and selector are right. `budilelono.web.id`, `cepekdulu.com`, `globalenglish-academy.com` have NOT been checked yet (each may be on yet another Cloudflare account) — worth a follow-up pass.
- **Cloudflare access for `gord.my.id` and `bule.my.id` — solved via scoped API tokens, not a second MCP connector.** Both domains are on Cloudflare accounts the existing MCP connector (`Satusatu@gmail.com`, used for `totat.my.id`) can't reach. Owner created two single-zone, DNS:Edit-only tokens instead: `CLOUDFLARE_API_TOKEN_BULE` (zone `bule.my.id`, account "Wandirakebo@gmail.com's Account", zone id `2955efb97b5e0d15d6fd22c6c10e7233`) and `CLOUDFLARE_API_TOKEN_GORD` (zone `gord.my.id`, account "Yohanes.lelono@ipmi.ac.id's Account", zone id `f226275893ef4fc6d4f231654babb21e`) — both stored in `/etc/caddy/cloudflare.env` on NL1 alongside the existing `CLOUDFLARE_API_TOKEN`/`CLOUDFLARE_API_TOKEN_TOTAT`. Used via direct `curl` + Bearer auth from NL1 (source the env file, call `api.cloudflare.com/client/v4/...`), not through the MCP connector. **Three separate Cloudflare accounts now in play across this project's domains** — always check which token/zone-id matches which domain before making a DNS change; don't assume one token covers more than its one named zone.

## Cross-server SSH access via agent forwarding (set up 2026-09-23)

Owner asked to be able to manage all VPS from one place (NL1) without concentrating private keys there (which would make NL1 a much bigger target if ever compromised). Implemented via **SSH agent forwarding**, not key copying:
- `~/.ssh/config` on NL1 now has short aliases: `dasabo` (43.240.149.38:2298), `mail1` (43.240.149.83:27194), `nl1` (62.105.222.90:2299) — hostnames/ports only, **no private keys involved, safe to leave in place permanently**.
- To use it: load the relevant private keys into a local ssh-agent (`eval $(ssh-agent -s)`, then `ssh-add` each key — id1_v3 for Dasabo, nl1_new for NL1, mail1_ed25519 for MAIL1), then connect with `ssh -A -p 2299 -i ~/.ssh/nl1_new bule@62.105.222.90`. From inside that session, `ssh dasabo` / `ssh mail1` work directly using the forwarded agent — the keys themselves never touch NL1's disk.
- **Important for future sessions/scripts:** `eval $(ssh-agent -s)` sets environment variables (`SSH_AUTH_SOCK`) that only persist within the SAME shell/process — if your tool invokes each command as a fresh subprocess (no persistent shell state), you must start the agent, add keys, AND run the forwarded SSH command all within one single invocation, or the forwarding silently fails with "Permission denied."
- MassiveGrid was NOT included in this setup — no local key found under an obvious name (`mg_*`/`massivegrid_*` in `~/.ssh/`); its access hasn't been re-verified since July 2026 per the existing open item below. Add it once that key is located/confirmed.

## Known open items (as of this writing)

- NL1 and MassiveGrid SSH access hasn't been re-verified since a scratchpad clear cost Dasabo's keys (recovered 2026-09-14). Worth a quick check before relying on them.
- `newsite.globalenglish-academy.com` is a draft redesign awaiting the site owner's (Rose's) review — not yet the production GEA site.
- Root cause of the 2026-09-16→18 rclone/crontab disappearance on both boxes was never identified — worth keeping an eye out in case it recurs.
- Whether to rotate the MySQL root password that was found hardcoded in `restore-wp.sh` (see Backup system section above) — not yet decided as of 2026-09-18.
- MAIL1's SSH key needs rotation (see SSH access section above) — plaintext key exposure via `VPS.xlsx` conversion, 2026-09-18.
- Two servers mentioned by the user on 2026-09-18 are still **not documented anywhere on disk**: a MassiveGrid box described as "New York, 1 core/1GB/32GB Ubuntu 24.04, idle, test/spare" (possibly the same MassiveGrid as above with a different IP than recorded, or a second MassiveGrid instance — unconfirmed), and **bulefx1** (DigitalKu/Hetzner Germany, 144.76.96.58, Windows RDP, FORGE/MT5 candidate, "Active"). Neither appears in `VPS.xlsx` or any `.md` file. Needs the user to clarify/provide access details before either can be added here.
