# TOTAT — CLAUDE.md (public repo entrypoint)
# Claude Code reads this automatically in every session in this directory

## Project
TOTAT (Toko Catat) | PT Catat Mapan | Owner: BuLe

## This repository's scope

`kebowandira/TOTAT` (public) holds only the 13 Cloudflare Pages landing-page
sources under `sites/`, plus general contributor docs (`AGENTS.md`,
`claude-shared-context/conventions.md`, `claude-shared-context/schema.sql`,
`claude-shared-context/domain-structure.md`, `claude-shared-context/AI_ROLES.md`).
Nothing here should ever include server addresses, SSH details, credentials,
or internal phase/decision tracking — see "Repository split" below.

## Current status

See `PROJECT_STATUS.md` in this repo for the public-safe summary. Full
phase/decision detail, server infrastructure, and AI-ops context live in the
private `kebowandira/totat-internal` repository — request access from BuLe if
your session needs it. Do not guess at infrastructure detail (server
addresses, SSH ports, deployment paths) from memory or from an old commit in
this repo's history; ask for `totat-internal` access instead.

## Repository split (2026-09-24)

This public repo previously carried internal operational docs (`CLAUDE.md`'s
full version, `PROJECT_STATUS.md`'s full version, `master-brief*.md`,
`AI_MASTER_GUIDE.md`, and two historical deployment guides). Those moved to
`kebowandira/totat-internal` (private) after a repository security review
found they exposed server topology and SSH access patterns publicly with no
product reason to. This repo's git **history** still contains the pre-split
versions of those files — that is a separate, not-yet-decided cleanup.

## Landing page architecture: 13 Cloudflare Pages Classic projects

Each subdomain is its own independent Cloudflare Pages project connected to
this repo (`kebowandira/TOTAT`, branch `main`), Root directory pointed at its
own `sites/[modul]` folder, no build command, no Functions.

| Domain | Root directory |
|---|---|
| totat.my.id (+www) | `sites/main` |
| warung.totat.my.id | `sites/warung` |
| cafe.totat.my.id | `sites/cafe` |
| sewa.totat.my.id | `sites/sewa` |
| tamu.totat.my.id | `sites/tamu` |
| jasa.totat.my.id | `sites/jasa` |
| talent.totat.my.id | `sites/talent` |
| kanal.totat.my.id | `sites/kanal` |
| kirim.totat.my.id | `sites/kirim` |
| jaringan.totat.my.id | `sites/jaringan` |
| investor.totat.my.id | `sites/investor` |
| distribusi.totat.my.id | `sites/distribusi` |
| karir.totat.my.id | `sites/karir` |

(Exact Cloudflare project names vary slightly from `sites/` folder names —
check the Cloudflare dashboard for the authoritative project list.)

**Adding a new module:** create one more Pages project the same way (Import
Git repo → Root directory `sites/[modul]` → attach `[modul].totat.my.id`).
There is no shared routing file — each subdomain is fully independent.

## context.totat.my.id — Auth

DECIDED: PUBLIC — no auth required. Schema + conventions only, no user data,
no infrastructure detail.
