# TOTAT repository security file map — PROPOSAL, not yet executed

**Prepared:** 2026-09-24
**Basis:** ChatGPT Work audit (`CLAUDE_CODE_GITHUB_SECURITY_HANDOFF_2026-09-23.md`, GDrive
`claude-shared-context/`) plus a direct read of every file listed below.
**Status:** Proposal only. No repository visibility change, no new repository, and no file
move has been made. This exists so BuLe can approve/adjust a concrete plan before anything
irreversible happens — see "What this does not decide" at the bottom.

## Why this exists

`kebowandira/TOTAT` is a **public** repository. It currently mixes two things that don't
belong at the same visibility level: (a) 13 Cloudflare Pages landing-page sources, which must
stay public for the current deployment pipeline to keep working, and (b) internal operational
detail (SSH ports, key filenames, server topology, backup schedules, phase/decision tracking)
that an outside reader has no reason to see. `PROJECT_STATUS.md` already flagged this as risk
#1 and open decision O-002; the ChatGPT audit independently reached the same conclusion.

## Classification

| File / path | Contains | Proposed treatment | Confidence |
|---|---|---|---|
| `sites/**` (13 folders incl. `_redirects`) | Static landing-page HTML, intended public content | **Keep public** — this is what the live Cloudflare Pages deployments build from | High |
| `CLAUDE.md` | SSH ports, NL1 IP (now corrected), Caddy paths, internal script paths, GDrive folder link | **Move to private repo/doc.** Public copy should shrink to: project name, "read PROJECT_STATUS.md first", and nothing else operational | High |
| `CLAUDE_CODE_TASK.md` | Old NL1 IP, SSH command, DNS instructions — self-described as historical | **Remove from active tree** (or move to private) — already superseded, no live reason to keep exposing old SSH usage patterns publicly | High |
| `DEPLOY_STEPS.md` | Old NL1 IP, SSH/SCP commands, Caddyfile paths — self-described SUPERSEDED | **Remove from active tree** (or move to private) — same reasoning as above | High |
| `worker.js.bak`, `wrangler.jsonc.bak` | Retired Worker routing config | **Remove**, after confirming (see verification step) no Cloudflare Pages project still references them | Medium — I have not independently re-verified this against the live Cloudflare dashboard |
| `claude-shared-context/AI_MASTER_GUIDE.md` | NL1 IP, SSH usage patterns, internal AI roster/ops detail | **Move to private** | High |
| `claude-shared-context/master-brief.md` | NL1 IP, self-host stack detail (§14-16), internal architecture | **Move to private** | High |
| `claude-shared-context/master-brief-short.md` | NL1 IP, hosting summary | **Move to private** | High |
| `PROJECT_STATUS.md` | Phase/decision tracker; deliberately avoids secrets per its own "never add credentials" rule, but does name real domains, repo topology, and internal risk items | **Split**: keep a public-safe summary (phase name, product status) in this repo; move the full risk/decision detail to the private context. This file is also the one every AI session is told to read first, so the split needs a working public → private handoff link, not just deletion | Medium — needs your call on how much phase detail is actually sensitive vs. just "internal-sounding" |
| `claude-shared-context/domain-structure.md` | Product/module descriptions for future landing pages (roster, gaji, kasbon, etc.) | **Can likely stay public** — read as product roadmap, not infrastructure. No IPs, keys, or credentials found | Medium |
| `claude-shared-context/AI_ROLES.md` | Session-role assignments ("planning and task scoping with BuLe," etc.) | **Can likely stay public** — no infra/credential content found | Medium |
| `AGENTS.md` | Coding conventions (stack, commit message format) | **Can likely stay public** — standard contributor doc, no infra/credential content found | Medium |
| `claude-shared-context/conventions.md`, `claude-shared-context/schema.sql` | Implementation conventions; proposed DB schema | **Can likely stay public** per prior review — schema is proposed, not a live-DB description, contains no data | Medium (schema.sql content not re-diffed this pass, relying on earlier review) |
| `claude-shared-context/per-ai-setup.md` | Multi-AI onboarding instructions (Claude/Gemini/ChatGPT/Jules/Copilot/Grok), no credentials | **Can likely stay public** on its own content, **but** it hardcodes public `raw.githubusercontent.com` URLs to `master-brief.md` and `CLAUDE.md` as the fetch mechanism every other AI platform uses. If those two files move private (as proposed above), this file's instructions silently break for every non-Claude-Code AI tool listed. Needs an explicit decision on the replacement mechanism (e.g., point at `context.totat.my.id` instead, which is already DECIDED public/no-auth for schema+conventions) before or alongside the move | High on content, but flags a real dependency the other rows don't |

## What this proposal does NOT decide

Per the earlier assessment: repo-visibility changes and new-repo creation are irreversible-*ish*
and affect a live deployment pipeline (13 Cloudflare Pages projects build directly from this
repo's `main`). Before any of the "move to private" rows above are executed, BuLe needs to
confirm:

1. **Option A vs B** — a separate private `totat-internal` repo holding the moved files, vs.
   making all of `TOTAT` private and standing up a new public repo containing only `sites/**`.
   Option A is lower-risk to the live Cloudflare builds (Root directory paths don't change).
2. Whether Cloudflare Pages' Git integration would need reconnecting if any repo boundary
   changes — this needs a check against the live Cloudflare dashboard, not assumed from this
   repo alone.
3. What replaces the public copies of `CLAUDE.md`/`PROJECT_STATUS.md` as the entry point AI
   sessions and contributors actually read — a stub pointing at the private repo, presumably,
   but the exact wording is a decision, not a default.

## Out of scope for this session

- `LinguaKid`'s claimed committed PIN, and the other five private repos named in the ChatGPT
  audit (`sentinel-trading-systems`, `BULE_Trading_Lab`, `helm-os`, `bule-ai-os`, `k-stack`) —
  this session only has GitHub access to `kebowandira/TOTAT`. None of those were read, touched,
  or verified here.
- Git history / prior commits on `main` — this proposal covers the current working tree only.
  A stale IP or path in an old commit is still fetchable by anyone via GitHub's API even after
  the file is deleted from `HEAD`; that's a separate, larger decision (BuLe approval needed per
  the audit's own caution against rewriting history without coordinating impact first).
