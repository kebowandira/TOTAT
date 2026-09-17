# TOTAT — AI Roles
# Who does what, derived from AI_MASTER_GUIDE.md and per-ai-setup.md.
# NOTE: this file does not exist in the GDrive foundation folder as of
# this writing — it's synthesized from those two documents' existing
# content, not a transcription of a Drive source. Replace/correct it
# there if BuLe wants a different canonical version.

## Claude (claude.ai Project)
Role: planning and task scoping with BuLe. Not code execution.
Context: auto-loaded via Project knowledge.
Scope: help define a task, then hand off to Claude Code to execute.

## Claude Code (terminal / repo sessions)
Role: the only AI that writes code and touches infrastructure directly.
Context: reads `CLAUDE.md` (root or `/opt/totat/`) automatically, plus
`claude-shared-context/master-brief.md`.
Scope: executes tasks on a `claude/[branch]`, opens a PR to `main`.
Never pushes directly to `main` without BuLe's approval (Section 2,
AI_MASTER_GUIDE.md). Owns NL1 infrastructure changes — subject to the
Caddy safety rules (never `caddy start`/`stop`/`restart`; reload only,
always validate first; never touch `/opt/totat/apps/warung/`).

## Jules (Google, GitHub-native)
Role: autonomous coding agent, assigned via GitHub issue/PR.
Context: reads `AGENTS.md` from repo root automatically, then fetches
`master-brief.md`.
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
Context: manual — fetch `master-brief.md` via raw GitHub URL at the
start of a session (Gemini), or via an uploaded `TOTAT_master-brief.md`
file re-uploaded on major updates (ChatGPT).
Scope: same rules as Claude Code's brief (5 UX rules, pricing rules,
Bahasa Indonesia UI) apply to whatever they draft, but they do not push
code themselves — output gets handed to Claude Code for execution.

## Grok
Role: ad hoc assistant, no persistent setup.
Context: manual paste of `master-brief-short.md` at the start of every
session — nothing persists between sessions.
Scope: same as Gemini/ChatGPT — advisory, not an execution agent.

## Context server (context.totat.my.id)
Not an AI — the shared read endpoint every AI above can fetch from
instead of needing repo access. Status: NL1 setup pending (Task 5,
`TOTAT_ClaudeCode_Master_v5.md`). Auth: DECIDED — PUBLIC, no auth
required (Sep 2026, confirmed in `TOTAT_ClaudeCode_Master_v5.md`
Task 1). `CLAUDE.md` and `AI_MASTER_GUIDE.md` in this bundle now both
reflect this.
