# TOTAT — AI Collaboration Master Guide
# Version: 2.0 UNIFIED | Sep 2026
# Owner: BuLe (PT Catat Mapan) — one-man-show
# ============================================================
#
# SHARE THIS FILE TO ANYONE WHO NEEDS IT:
# GDrive: https://drive.google.com/drive/folders/1u5dWXJF6eDGy4rkBU3WrLAbxx7J7UWNI
# GitHub: https://github.com/kebowandira/TOTAT
# File:   TOTAT_AI_Master_Guide.md
#
# ============================================================


---


## SECTION 1 — WHERE EVERYTHING LIVES


### Source of Truth (in priority order)
```
1. GitHub (primary)
   https://github.com/kebowandira/TOTAT
   └── PROJECT_STATUS.md                         ← read first: current phase, blockers, decisions
   └── claude-shared-context/master-brief.md    ← full context
   └── claude-shared-context/schema.sql         ← DB schema
   └── claude-shared-context/conventions.md     ← code rules
   └── claude-shared-context/per-ai-setup.md    ← per-AI guide
   └── AGENTS.md                                ← for Jules/Copilot
   └── CLAUDE.md                                ← for Claude Code


2. GDrive (edit here, sync to GitHub)
   https://drive.google.com/drive/folders/1u5dWXJF6eDGy4rkBU3WrLAbxx7J7UWNI
   Same files — edit in Google Docs, sync via Claude Code


3. context.totat.my.id (mirror, after NL1 setup)
   https://context.totat.my.id/master-brief.md
   https://context.totat.my.id/schema.sql
   https://context.totat.my.id/api.json
   Auto-synced from GitHub main branch
```


### Raw GitHub URLs (use these in AI prompts)
```
Project status (read first):
https://raw.githubusercontent.com/kebowandira/TOTAT/main/PROJECT_STATUS.md

Master brief (full):
https://raw.githubusercontent.com/kebowandira/TOTAT/main/claude-shared-context/master-brief.md


Master brief (short):
https://raw.githubusercontent.com/kebowandira/TOTAT/main/claude-shared-context/master-brief-short.md


Schema:
https://raw.githubusercontent.com/kebowandira/TOTAT/main/claude-shared-context/schema.sql


Conventions:
https://raw.githubusercontent.com/kebowandira/TOTAT/main/claude-shared-context/conventions.md


AGENTS.md:
https://raw.githubusercontent.com/kebowandira/TOTAT/main/AGENTS.md
```


---


## SECTION 2 — BRANCH RULES


```
main                  ← stable, reviewed, production-ready
claude/[branch-name]  ← Claude Code works here
                         PR → main when batch ready
                         BuLe approves PR before merge


NEVER push directly to main without BuLe approval.
```


---


## SECTION 3 — WHAT TO TELL EACH AI


### Copy-paste the exact text below for each AI platform.


---


### 3A — CLAUDE (claude.ai Project)
STATUS: Already configured. Auto-loads every session.
If starting fresh or sharing with someone else:


```
You are a development assistant for TOTAT (Toko Catat) by PT Catat Mapan.
Fetch and read this before starting:
https://raw.githubusercontent.com/kebowandira/TOTAT/main/claude-shared-context/master-brief.md


Then confirm you've read it and wait for the task.
```


---


### 3B — GEMINI (GEMS setup — do this once)
Go to: gemini.google.com → Gems → Create a Gem
Name: TOTAT Dev Assistant
Paste as Instructions:


```
You are a development assistant for TOTAT (Toko Catat) by PT Catat Mapan.
Owner: BuLe (one-man-show — owner, developer, and operator).


At the start of EVERY conversation, fetch and read:
https://raw.githubusercontent.com/kebowandira/TOTAT/main/claude-shared-context/master-brief.md


Then confirm: "✅ TOTAT context loaded from GitHub"
Wait for BuLe's task. Follow all rules in the brief.
Never violate the 5 UX rules or pricing rules.
Respond in the same language as BuLe (Bahasa Indonesia or English).


GitHub repo: https://github.com/kebowandira/TOTAT
GDrive foundation: https://drive.google.com/drive/folders/1u5dWXJF6eDGy4rkBU3WrLAbxx7J7UWNI
```


For each new session (if Gem doesn't auto-load):
```
Fetch https://raw.githubusercontent.com/kebowandira/TOTAT/main/claude-shared-context/master-brief.md
then [your task here]
```


---


### 3C — CHATGPT (Custom GPT — do this once)
Go to: chat.openai.com → Explore GPTs → Create
Name: TOTAT Dev Assistant
Paste as Instructions:


```
You are a development assistant for TOTAT (Toko Catat) by PT Catat Mapan.
Owner: BuLe (one-man-show).


Read the uploaded TOTAT_master-brief.md file for full context.
Also check: https://raw.githubusercontent.com/kebowandira/TOTAT/main/claude-shared-context/master-brief.md
for the latest version.


Rules:
- Never violate the 5 UX rules or pricing rules in the brief
- All UI copy in Bahasa Indonesia (informal)
- Mobile-first React PWA
- Additive only — never refactor working features
- Free tier = truly full function, no paywall


GitHub: https://github.com/kebowandira/TOTAT
```


Knowledge tab → Upload file:
Download master-brief.md from GDrive → upload as TOTAT_master-brief.md
Re-upload when major updates happen.


For each new chat (ChatGPT doesn't auto-load):
```
You are my TOTAT dev assistant. Context is in the uploaded file.
Task: [your task here]
```


---


### 3D — JULES (Google — GitHub native)
No setup needed beyond pushing AGENTS.md to repo root.
Jules reads AGENTS.md automatically when assigned a task.


To assign Jules a task:
1. Open GitHub issue or PR
2. Assign to Jules
3. Jules reads AGENTS.md → fetches master-brief.md → works


AGENTS.md location: https://github.com/kebowandira/TOTAT/blob/main/AGENTS.md
Jules will fetch: https://raw.githubusercontent.com/kebowandira/TOTAT/main/claude-shared-context/master-brief.md


---


### 3E — GITHUB COPILOT
No setup needed beyond pushing AGENTS.md to repo root.
Copilot reads AGENTS.md and .github/copilot-instructions.md automatically.


Optional: add .github/copilot-instructions.md pointing to context files.


---


### 3F — CLAUDE CODE (terminal)
CLAUDE.md at /opt/totat/CLAUDE.md is read automatically.
Also place CLAUDE.md at GitHub repo root for any Claude Code session in repo.


Starting a Claude Code session in TOTAT project:
```
cd /opt/totat
# CLAUDE.md is here — Claude Code reads it automatically
```


Or tell Claude Code explicitly:
```
Read /opt/totat/CLAUDE.md and
https://raw.githubusercontent.com/kebowandira/TOTAT/main/claude-shared-context/master-brief.md
before starting.
```


---


### 3G — GROK
No persistent context. Manual paste every session.


Copy-paste at start of every Grok session:
```
[paste contents of master-brief-short.md here]
Task: [your task]
```


Get master-brief-short.md from:
https://raw.githubusercontent.com/kebowandira/TOTAT/main/claude-shared-context/master-brief-short.md


---


## SECTION 4 — WORKFLOW


### Daily development flow
```
1. Open Claude (Project TOTAT DEV) — context auto-loaded
2. Plan task → Claude helps scope it
3. Tell Claude Code: execute task on GitHub branch claude/[name]
4. Claude Code reads CLAUDE.md + fetches master-brief from GitHub
5. Work done on branch
6. PR created: claude/[branch] → main
7. BuLe reviews + approves → merge
8. context.totat.my.id auto-syncs from main (after NL1 setup)
```


### When foundation files change
```
1. Edit in GDrive (comfortable Google Docs interface)
2. Tell Claude Code:
   "Sync TOTAT foundation from GDrive to GitHub
    Source: https://drive.google.com/drive/folders/1u5dWXJF6eDGy4rkBU3WrLAbxx7J7UWNI
    Target: github.com/kebowandira/TOTAT / claude-shared-context/
    Branch: claude/foundation-update
    Create PR to main when done."
3. BuLe approves PR
4. GitHub main updated → all AI get new context via raw URL
5. context.totat.my.id auto-syncs (after NL1 setup)
```


### Adding a new AI to the team
```
1. Check Section 3 for that AI's setup instructions
2. Give them this file location:
   GitHub: https://github.com/kebowandira/TOTAT
   GDrive: https://drive.google.com/drive/folders/1u5dWXJF6eDGy4rkBU3WrLAbxx7J7UWNI
3. Point to master-brief.md raw URL
4. They're ready
```


---


## SECTION 5 — NL1 SETUP (context.totat.my.id)


### Prerequisites — check before running
```
NL1 IP:    92.112.126.231
SSH user:  bule
OS:        Ubuntu 24.04
Caddy:     systemd-managed, ALREADY RUNNING other sites
           NEVER start second Caddy instance
           ALWAYS use: sudo systemctl reload caddy
```


### Paste to Claude Code for NL1 setup:
```
You are TOTAT infrastructure assistant. NL1: 92.112.126.231, user: bule.


STEP 0 — Read context first
Fetch: https://raw.githubusercontent.com/kebowandira/TOTAT/main/claude-shared-context/master-brief.md
Fetch: https://raw.githubusercontent.com/kebowandira/TOTAT/main/CLAUDE.md
Confirm both read before continuing.


STEP 1 — Diagnose NL1 (report all before proceeding)
  ls /opt/totat/ 2>/dev/null && echo EXISTS || echo NEW
  systemctl status caddy | grep Active
  sudo systemctl cat caddy | grep ExecStart
  sudo cat [caddy-config-path] | head -30


STEP 2 — If NEW: create folder structure
  mkdir -p /opt/totat/{caddy,sites/{main,warung,cafe,sewa,tamu,jasa,talent,kanal,kirim,jaringan,investor,karir},apps,context/screen-flows,scripts,backups,logs}
  chown -R bule:bule /opt/totat/


STEP 3 — Clone foundation from GitHub
  git clone https://github.com/kebowandira/TOTAT /tmp/totat-repo
  cp /tmp/totat-repo/claude-shared-context/* /opt/totat/context/
  cp /tmp/totat-repo/AGENTS.md /opt/totat/AGENTS.md
  cp /tmp/totat-repo/CLAUDE.md /opt/totat/CLAUDE.md


STEP 4 — Caddy: SAFE merge only
  4a. Find existing config: sudo systemctl cat caddy | grep ExecStart
  4b. Read it: sudo cat [config-path]
  4c. Confirm no totat.my.id conflicts
  4d. Show me the totat-blocks to add — I will review before appending
  4e. After my approval: sudo cat /opt/totat/caddy/totat-blocks.caddy >> [config]
  4f. Validate: sudo caddy validate --config [config-path]
      STOP if validation fails. Do not reload.
  4g. If valid: sudo systemctl reload caddy
  4h. Verify: curl https://context.totat.my.id/api.json


STEP 5 — Setup auto-sync from GitHub
  Create /opt/totat/scripts/sync-from-github.sh:
  #!/bin/bash
  cd /tmp/totat-repo && git pull origin main
  cp claude-shared-context/* /opt/totat/context/
  echo "Synced $(date)" >> /opt/totat/context/.sync-log


  Add cron: 0 * * * * bash /opt/totat/scripts/sync-from-github.sh
  (syncs every hour from GitHub main)


STEP 6 — Verify all
  curl -s https://context.totat.my.id/api.json
  curl -s https://context.totat.my.id/master-brief.md | head -3
  curl -s https://totat.my.id | grep title


STEP 7 — Print summary with all URLs.


IMPORTANT RULES:
- NEVER: caddy start, caddy stop, caddy restart
- ALWAYS: sudo systemctl reload caddy
- NEVER touch /opt/totat/apps/warung/ (future production)
- ALWAYS validate Caddy config before reload
- context.totat.my.id = PUBLIC (no auth, safe — no user data)
```


---


## SECTION 6 — QUICK REFERENCE CARD
(Print or keep open when working)


```
GITHUB REPO:   https://github.com/kebowandira/TOTAT
GDRIVE:        https://drive.google.com/drive/folders/1u5dWXJF6eDGy4rkBU3WrLAbxx7J7UWNI
CONTEXT URL:   https://context.totat.my.id/ (after NL1 setup)
APP BETA:      https://warungbeta.totat.my.id
TESTER FORM:   https://tally.so/r/Bzr1qN
FEEDBACK:      https://tally.so/r/Y51OEv
WA COMMUNITY:  https://chat.whatsapp.com/GLmk1xTigpO6uGLoDk4z8z
NL1:           92.112.126.231 | user: bule


RAW CONTEXT:
https://raw.githubusercontent.com/kebowandira/TOTAT/main/claude-shared-context/master-brief.md


AI SETUP STATUS:
✅ Claude Project  → auto-loaded
⏳ Gemini GEMS     → create Gem (Section 3B)
⏳ ChatGPT GPT     → create Custom GPT (Section 3C)
✅ Jules           → reads AGENTS.md from repo (push needed)
✅ Copilot        → reads AGENTS.md from repo (auto)
✅ Claude Code     → reads CLAUDE.md from /opt/totat/
⏳ Grok:          → manual paste every session
⏳ context server  → NL1 setup needed (Section 5)


BRANCH RULE:
claude/[branch] → PR → main (BuLe approves)


UPDATE FLOW:
Edit GDrive → Claude Code sync to GitHub → all AI auto-update
```


---


## SECTION 7 — TELLING A NEW AI ABOUT TOTAT


When onboarding ANY new AI, give them this one-liner:


```
You are a dev assistant for TOTAT (Toko Catat) by PT Catat Mapan Indonesia.
Full context: https://raw.githubusercontent.com/kebowandira/TOTAT/main/claude-shared-context/master-brief.md
Read it first, then wait for my task.
```


That's it. Everything else is in the brief.


---
TOTAT AI Master Guide v2.0 | PT Catat Mapan | Sep 2026
Maintained by BuLe | Update via Claude Code → GitHub PR → main