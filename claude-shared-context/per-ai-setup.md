# TOTAT — Per-AI Setup Guide
# How to configure TOTAT context in each AI platform
# GitHub: https://github.com/kebowandira/TOTAT (public, landing pages only)

## 2026-09-24 — read this first: context moved to a private repo

`master-brief.md`, `master-brief-short.md`, and `AI_MASTER_GUIDE.md` moved
from this public repo to the private `kebowandira/totat-internal` repo (see
`SECURITY_FILE_MAP_PROPOSAL.md`, now also in that private repo). The public
`raw.githubusercontent.com` URLs this file used to hand out for those files
**no longer resolve** — a private repo's raw URL 404s for an unauthenticated
fetch.

Each platform below needs its own fix before its instructions work again:

- **Claude (claude.ai) / Claude Code:** unaffected if using GitHub access
  already granted to `totat-internal` (Project knowledge, or a session with
  that repo in scope). No public URL involved.
- **Gemini GEMS, ChatGPT Custom GPT, Grok:** these fetch/paste a public raw
  URL with no auth step. Until one of the following is set up, their
  instructions below are **stale and will fail silently** (empty/404
  fetch, or a stale uploaded copy for ChatGPT):
  1. Grant that platform's GitHub connector/OAuth read access to
     `totat-internal` specifically (preferred — matches the "own
     GitHub App or OAuth connection per service" access model from the
     2026-09-23 security review), or
  2. Manually re-paste/re-upload the relevant file's content each session
     instead of fetching by URL (works today, no setup, doesn't scale), or
  3. Mirror a sanitized subset of `master-brief.md` (no infra addresses) to
     `context.totat.my.id`, which is already public/no-auth by design, and
     point these tools there instead. **Not done yet** — needs an NL1
     session to implement.
- **Jules, GitHub Copilot:** unaffected — both only read `AGENTS.md`, which
  stayed in this public repo.

Until one of the above is chosen, treat every instruction below that
references `master-brief*.md` or `AI_MASTER_GUIDE.md` via a public raw URL
as **not currently working**.

---

## CLAUDE (claude.ai)
Method: Project knowledge — auto-loads every session
Setup: Already done (TOTAT DEV project); ensure `totat-internal` is in its
knowledge source, not the old public raw URL.

---

## GEMINI — GEMS (one-time setup)
1. gemini.google.com → Gems → Create a Gem
2. Name: TOTAT Dev Assistant
3. Instructions:
   You are a dev assistant for TOTAT (Toko Catat) by PT Catat Mapan.
   At the start of EVERY conversation fetch and read master-brief.md
   (see "context moved" note above for the current source).
   Confirm loaded, then wait for task.
   Never violate 5 UX rules or pricing rules in the brief.
4. Save Gem → use for all TOTAT tasks

---

## CHATGPT — Custom GPT (one-time setup)
1. chat.openai.com → Explore GPTs → Create
2. Name: TOTAT Dev Assistant
3. Instructions:
   You are a dev assistant for TOTAT (Toko Catat) by PT Catat Mapan.
   Read uploaded TOTAT_master-brief.md for context.
   Rules: mobile-first, Bahasa Indonesia UI, additive only, no paywall.
4. Knowledge → upload master-brief.md (rename TOTAT_master-brief.md) —
   download it from `totat-internal` (requires access) rather than the old
   public raw URL.
5. Re-upload when major updates happen

---

## JULES (Google — GitHub native)
No setup needed. Jules reads AGENTS.md from repo root automatically.
AGENTS.md: https://github.com/kebowandira/TOTAT/blob/main/AGENTS.md
(Jules no longer needs master-brief.md from this repo — that file moved.)

To assign: open GitHub issue/PR → assign to Jules

---

## GITHUB COPILOT
No setup needed. Reads AGENTS.md from repo root automatically.
Optional: .github/copilot-instructions.md pointing to context files.

---

## CLAUDE CODE (terminal)
Reads CLAUDE.md automatically when in /opt/totat/ directory, and from this
public repo's root for any session scoped only to `TOTAT`. A session that
also needs infrastructure/phase detail must have `totat-internal` added to
its GitHub scope explicitly — it is not auto-discoverable from this repo.

---

## GROK
No persistent context. Manual paste every session — see "context moved"
note above; the old raw-URL fetch for master-brief-short.md no longer
resolves.

---

## ONE-LINER FOR ANY NEW AI
You are a dev assistant for TOTAT (Toko Catat) by PT Catat Mapan Indonesia.
Ask BuLe for access to the relevant context (public `kebowandira/TOTAT` for
landing-page work, private `kebowandira/totat-internal` for anything else).
Then wait for the task.

---

## STATUS TRACKER
Claude Project:  ⚠️ verify it points at totat-internal, not the old raw URL
Gemini GEMS:     ⚠️ broken until access/mirror is set up (see note above)
ChatGPT GPT:     ⚠️ broken until access/re-upload is set up (see note above)
Jules:           ✅ AGENTS.md in repo (auto, unaffected by the split)
Copilot:         ✅ AGENTS.md in repo (auto, unaffected by the split)
Claude Code:     ⚠️ needs totat-internal added to scope for full context
Grok:            ⚠️ broken until manual paste or mirror is set up
context server:  ⏳ NL1 setup pending; also the eventual fix for Gemini/GPT/Grok
