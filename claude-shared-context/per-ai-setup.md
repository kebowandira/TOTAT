# TOTAT — Per-AI Setup Guide
# How to configure TOTAT context in each AI platform
# GDrive: https://drive.google.com/drive/folders/1u5dWXJF6eDGy4rkBU3WrLAbxx7J7UWNI
# GitHub: https://github.com/kebowandira/TOTAT
# Full guide: TOTAT_AI_Master_Guide_v2.md in this folder


---


## CLAUDE (claude.ai)
Method: Project knowledge — auto-loads every session
Setup: Already done (TOTAT DEV project)
Fallback: paste raw GitHub URL at session start:
  https://raw.githubusercontent.com/kebowandira/TOTAT/main/claude-shared-context/master-brief.md


---


## GEMINI — GEMS (one-time setup)
1. gemini.google.com → Gems → Create a Gem
2. Name: TOTAT Dev Assistant
3. Instructions:
   You are a dev assistant for TOTAT (Toko Catat) by PT Catat Mapan.
   At the start of EVERY conversation fetch and read:
   https://raw.githubusercontent.com/kebowandira/TOTAT/main/claude-shared-context/master-brief.md
   Confirm loaded, then wait for task.
   Never violate 5 UX rules or pricing rules in the brief.
4. Save Gem → use for all TOTAT tasks

	Per-session fallback:
  Fetch https://raw.githubusercontent.com/kebowandira/TOTAT/main/claude-shared-context/master-brief.md
  then [task]


---


## CHATGPT — Custom GPT (one-time setup)
1. chat.openai.com → Explore GPTs → Create
2. Name: TOTAT Dev Assistant
3. Instructions:
   You are a dev assistant for TOTAT (Toko Catat) by PT Catat Mapan.
   Read uploaded TOTAT_master-brief.md for context.
   Latest: https://raw.githubusercontent.com/kebowandira/TOTAT/main/claude-shared-context/master-brief.md
   Rules: mobile-first, Bahasa Indonesia UI, additive only, no paywall.
4. Knowledge → upload master-brief.md (rename TOTAT_master-brief.md)
5. Re-upload when major updates happen


Per-session:
  You are my TOTAT dev assistant. Context in uploaded file.
  Task: [task]


---


## JULES (Google — GitHub native)
No setup needed. Jules reads AGENTS.md from repo root automatically.
AGENTS.md: https://github.com/kebowandira/TOTAT/blob/main/AGENTS.md
Jules fetches master-brief.md from GitHub when assigned a task.


To assign: open GitHub issue/PR → assign to Jules


---


## GITHUB COPILOT
No setup needed. Reads AGENTS.md from repo root automatically.
Optional: .github/copilot-instructions.md pointing to context files.


---


## CLAUDE CODE (terminal)
Reads CLAUDE.md automatically when in /opt/totat/ directory.
Also reads CLAUDE.md from GitHub repo root.


Start session:
  cd /opt/totat   ← CLAUDE.md here, auto-read
  or tell Claude Code: Read CLAUDE.md and master-brief.md from GitHub first.


---


## GROK
No persistent context. Manual paste every session.


At start of every session paste:
  [paste master-brief-short.md contents]
  Task: [task]


Get short brief:
  https://raw.githubusercontent.com/kebowandira/TOTAT/main/claude-shared-context/master-brief-short.md


---


## ONE-LINER FOR ANY NEW AI
You are a dev assistant for TOTAT (Toko Catat) by PT Catat Mapan Indonesia.
Read: https://raw.githubusercontent.com/kebowandira/TOTAT/main/claude-shared-context/master-brief.md
Then wait for my task.


---


## STATUS TRACKER
Claude Project:  ✅ done
Gemini GEMS:     ⏳ setup needed (instructions above)
ChatGPT GPT:     ⏳ setup needed (instructions above)
Jules:           ✅ AGENTS.md in repo (auto)
Copilot:         ✅ AGENTS.md in repo (auto)
Claude Code:     ✅ CLAUDE.md in /opt/totat/ (auto)
Grok:            ⏳ manual paste every session
context server:  ⏳ NL1 setup pending