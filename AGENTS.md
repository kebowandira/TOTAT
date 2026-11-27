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

<!-- BEGIN bule-ai-os:save-claude-usage (source: kebowandira/bule-ai-os agy/AGENTS_BLOCK.md; do not edit here) -->
## Agent rules: save Claude usage (owner, 2026-11-27)

Applies to every agent working in this repository: Claude Code, agy, ask-gemini, Gemini, Jules and Colab
notebooks. Full text: the "Save Claude usage" host rule in `kebowandira/bule-ai-os` `agy/CLAUDE_HOST_RULES.md`.

1. Graphify first. Query the cross-repo graph (MCP `graphify-cross-repo` on DE1, backup on NL2, or
   `graphify query "<question>"`), then read only the files and lines it points to. No full-repository rereads.
2. Fresh graph. The graph is rebuilt after each merge to `main`. Run `graphify-fresh check` before starting;
   if it reports the graph stale, say so (until 2026-12-04 a warning, after that a stop).
3. Role split. agy (or Jules when the owner asks) builds from a spec made with
   `agy/templates/SPEC_TEMPLATE.md` in bule-ai-os: 1 to 3 files, tests written and committed first. Claude
   writes the spec and reviews only the diff and the test output.
4. Machines check first. Tests, lint and data checks run on the VPS (`scripts/agent-preflight.sh` where this
   repository has one). Claude reviews only work that shows `PREFLIGHT PASSED <sha>`.
5. Colab only for heavy CPU jobs (over about 30 minutes on one core); everything else runs on NL1, NL2 or DE1.
6. Model ladder. ask-gemini for the first-pass review, Claude Sonnet for the review, Claude Opus only for hard
   design calls.
7. Usage is logged per Claude session from 2026-11-28 to 2026-12-11 (`claude-usage-log`) to confirm the savings.

Live trading is read-only. Draft pull requests only. No secrets in any file.
<!-- END bule-ai-os:save-claude-usage -->
