# TOTAT — AI Roles
# Who does what, derived from per-ai-setup.md.
# NOTE: this file does not exist in the GDrive foundation folder as of
# this writing — it's synthesized from other documents' existing
# content, not a transcription of a Drive source. Replace/correct it
# there if BuLe wants a different canonical version.
#
# 2026-09-24: AI_MASTER_GUIDE.md and master-brief*.md, previously cited
# throughout this file, moved to the private kebowandira/totat-internal
# repo (see CLAUDE.md's "Repository split" section). References below
# are updated accordingly — anything that used to fetch master-brief.md
# by public raw URL needs totat-internal access instead; see
# per-ai-setup.md's "context moved" note for the current state per
# platform (some are broken until that access is granted).

## Claude (claude.ai Project)
Role: planning and task scoping with BuLe. Not code execution.
Context: auto-loaded via Project knowledge — should point at
`totat-internal`, not the old public raw URL.
Scope: help define a task, then hand off to Claude Code to execute.

## Claude Code (terminal / repo sessions)
Role: the only AI that writes code and touches infrastructure directly.
Context: reads `CLAUDE.md` (root or `/opt/totat/`) automatically. Full
product/infra context (`master-brief.md`) now requires `totat-internal`
in the session's GitHub scope — not auto-discoverable from this repo.
Scope: executes tasks on a `claude/[branch]`, opens a PR to `main`.
Never pushes directly to `main` without BuLe's approval. Owns NL1
infrastructure changes — subject to the Caddy safety rules (never
`caddy start`/`stop`/`restart`; reload only, always validate first;
never touch `/opt/totat/apps/warung/`).

## Jules (Google, GitHub-native)
Role: autonomous coding agent, assigned via GitHub issue/PR.
Context: reads `AGENTS.md` from repo root automatically. `AGENTS.md`
no longer depends on `master-brief.md` from this repo — see AGENTS.md.
Scope: implementation tasks assigned directly on GitHub. No manual
per-session setup needed once `AGENTS.md` is pushed.

## GitHub Copilot
Role: inline code suggestions within the repo.
Context: reads `AGENTS.md` (and optionally
`.github/copilot-instructions.md`) automatically.
Scope: in-editor assistance, not a task-taking agent in the same sense
as Claude Code or Jules.

## Gemini (Gems) / ChatGPT (Custom GPT)
Role: secondary dev assistants for planning/discussion, one-time setup
per platform (see per-ai-setup.md Section 3B/3C for exact instructions).
Context: manual — previously fetched `master-brief.md` via public raw
URL; that no longer resolves since the split. **Currently broken** until
one of per-ai-setup.md's fix options (scoped access, manual re-paste, or
a sanitized context.totat.my.id mirror) is implemented.
Scope: same rules as Claude Code's brief (5 UX rules, pricing rules,
Bahasa Indonesia UI) apply to whatever they draft, but they do not push
code themselves — output gets handed to Claude Code for execution.

## Grok
Role: ad hoc assistant, no persistent setup.
Context: manual paste of `master-brief-short.md` — same broken-until-fixed
state as Gemini/ChatGPT above; see per-ai-setup.md.
Scope: same as Gemini/ChatGPT — advisory, not an execution agent.

## Context server (context.totat.my.id)
Not an AI — the shared read endpoint every AI above can fetch from
instead of needing repo access. Status: NL1 setup pending — not
confirmed live as of this writing. Auth: DECIDED — PUBLIC, no auth
required, **schema + conventions only**. Do not serve `master-brief.md`,
`AI_MASTER_GUIDE.md`, or anything else now living in `totat-internal`
from this endpoint — see `domain-structure.md`'s NL1 folder map.
