# TOTAT — AGENTS.md
# Place at GitHub repo root — read automatically by Jules, Copilot, Codex
# GDrive: https://drive.google.com/drive/folders/1u5dWXJF6eDGy4rkBU3WrLAbxx7J7UWNI


## Project
TOTAT (Toko Catat) — Free POS PWA for Indonesian warung owners
Company: PT Catat Mapan | Owner: BuLe (one-man-show)


## Current Execution Status — Read First
Raw: https://raw.githubusercontent.com/kebowandira/TOTAT/main/PROJECT_STATUS.md

This file is the canonical current phase, blocker, decision, and next-action record. If an older document conflicts with it, stop and follow the precedence rules in `PROJECT_STATUS.md`.


## Full Context
Fetch before any task:
https://context.totat.my.id/master-brief.md

**Caveat as of 2026-09-24:** the full `master-brief.md` now lives in the
private `kebowandira/totat-internal` repo (see `CLAUDE.md`'s "Repository
split" section) and must not be synced to this public endpoint as-is — it
contains server addresses and infra detail. If this URL doesn't resolve, or
returns something other than a sanitized (schema/conventions-only) summary,
treat it as not yet set up rather than assuming it's current.


## Code-graph tool (owner standing order, 2026-11-19)

The owner has a fleet-wide standing order to prefer querying a code-graph
tool ("graphify") over manual grep when it's reachable, across every
Claude session. This repo's own CLAUDE.md rule applies here too: no server
addresses, ports, or account names in this public repo, so the actual
connection details are **not** listed here — see `kebowandira/totat-internal`'s
`claude-shared-context/INFRASTRUCTURE_SUMMARY.md` (private) for where it's
actually running. If you don't have access to that file or to wherever the
tool is installed, say so and fall back to normal search — don't guess at
an address or install it yourself in this repo.

## Tech Stack
React 19 + Vite + TypeScript + Tailwind v4 + shadcn/ui
Database: Supabase PostgreSQL (prod) / Convex (beta Hercules)
Auth: Google OAuth | Hosting: NL1 via Caddy | totat.my.id


## Critical Rules — Never Violate
1. Mobile-first. Min touch 44px. Test at 375px.
2. All UI copy Bahasa Indonesia informal
3. Never getUserMedia — use <input type="file" capture="environment">
4. Never auto-send email/WA — user triggers manually
5. Offline-first — core features work without internet
6. Free = truly full function, no feature gating
7. Use existing shadcn/ui — never create new UI primitives
8. Additive only — never refactor working features


## Schema
https://context.totat.my.id/schema.sql


## Before Every PR
- [ ] Mobile tested 375px
- [ ] Bahasa Indonesia UI copy
- [ ] No new npm packages without approval
- [ ] Schema changes → update context.totat.my.id/schema.sql
- [ ] Additive only


## Commit Convention
feat(modul): description
fix(modul): description
chore: description