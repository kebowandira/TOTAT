# TOTAT — Project Status and Phase Handoff

> Canonical execution-status file for humans and AI agents.
>
> Last reviewed: 2026-09-21 (UTC)  
> Repository reviewed: `kebowandira/TOTAT` at `main@e1e32204c0183c2936942c9c604ef1d7513ad280`  
> Maintainer: BuLe / PT Catat Mapan

## Read order and authority

Before any TOTAT task, read these in order:

1. `PROJECT_STATUS.md` — current verified state, phase, blockers, and next actions.
2. `AGENTS.md` — non-negotiable working rules.
3. `claude-shared-context/master-brief.md` — product vision and approved principles.
4. `claude-shared-context/conventions.md` — implementation conventions.
5. `claude-shared-context/schema.sql` — proposed PostgreSQL/Supabase schema; it is not yet the live beta schema.

The owner's latest explicit decision overrides older documents. When two files conflict, do not guess: record the conflict here and ask BuLe before implementation.

## Status labels

- **VERIFIED** — confirmed from repository content, exported source/data, or a live check.
- **REPORTED** — recorded by BuLe or an earlier session but not independently verified in the current review.
- **DECIDED** — explicitly approved direction.
- **PROPOSED** — recommended but not yet approved or implemented.
- **SUPERSEDED** — historical only; do not execute.

## Current executive status

**Current phase: Phase 0 — continuity capture and governance.**

The Hercules beta produced a substantial TOTAT Warung application, but Hercules development credits are exhausted. The source archive and Convex snapshot were exported successfully. They are the recovery baseline, but the application source is not yet in GitHub and the snapshot must remain outside public Git history.

The next objective is not a rewrite. It is to preserve the working beta, establish a reproducible private development baseline, close critical gaps, and continue an invite-only cloud beta. The approved destination is a portable self-hosted live release after beta feedback has validated the product.

## Repository role — verified 2026-09-21

This public repository currently contains:

- 13 independent Cloudflare Pages landing-page folders under `sites/`.
- Shared product, AI, domain, schema, and infrastructure documentation.
- Retired Worker routing files kept as `.bak`.
- 40 tracked files in the reviewed `main` tree.

This repository currently does **not** contain:

- The React/Vite TOTAT Warung application source.
- `package.json`, `src/`, `convex/`, or PWA application assets.
- The Convex database snapshot or uploaded user images.

Do not place the database snapshot, exported user records, uploaded images, credentials, or environment files in this public repository.

## Recovered Hercules baseline

**VERIFIED from the exported application archive:**

- React 19, Vite, TypeScript, Tailwind v4, and shadcn/ui.
- Convex backend and `@usehercules/auth`.
- PWA manifest, icons, service worker, and offline page.
- Implemented areas: authentication, dashboard, opening cash, cashier, products, stock adjustments, stock purchasing, suppliers, customers, customer debt, reports, settings, QRIS, backup, and restore.
- Existing Convex export contains application records and file-storage images. Treat it as private user data.

**REPORTED, not live-verified in this audit:**

- Beta URL: `warungbeta.totat.my.id`.
- Hercules-hosted beta was operational before development credits were exhausted.

## Product invariants

These remain binding across every phase:

- Product: TOTAT (Toko Catat), beginning with TOTAT Warung.
- Primary product/UI tagline: **“Catat mudah, untung jelas.”**
- Company/mission line used in existing brand documents: **“Catat usahamu, mapankan hidupmu.”**
- Indonesian informal interface; use “kamu,” not “Anda.”
- Mobile-first; minimum 44 px touch targets; validate at 375 px width.
- Primary teal: `#2A9D8F`.
- One visible action per tap; important actions must not be hidden.
- Errors must explain what the merchant can do next.
- Free core functionality remains complete; premium is for added complexity such as multi-outlet or investor views.
- Never auto-send email or WhatsApp messages.
- Use native file input with `capture="environment"`; never use `getUserMedia`.
- Preserve working behavior. Changes are additive unless BuLe explicitly approves a refactor.

Offline-first remains the target requirement. The exported Hercules beta depends on cloud services, so full offline core operation is a known gap, not a completed capability.

## Confirmed decisions

| ID | Decision | Status |
|---|---|---|
| D-001 | Use a managed cloud deployment for the invite-only beta to collect real merchant feedback. | DECIDED |
| D-002 | Move to a self-hosted live/stable release after the beta is validated. | DECIDED |
| D-003 | Keep the architecture portable so the cloud beta does not create an avoidable second rewrite for self-hosting. | DECIDED |
| D-004 | Do not publish the beta or broaden access without BuLe's approval. | DECIDED |
| D-005 | Never commit the Convex snapshot or uploaded user files to the public repository. | DECIDED |
| D-006 | Keep TOTAT Warung as the priority; later product-family modules do not outrank completion of the Warung core. | DECIDED |
| D-007 | Use GitHub pull requests; do not push directly to `main`. BuLe approves merges. | DECIDED |

## Open decisions

| ID | Decision required | Why it is open |
|---|---|---|
| O-001 | Keep Convex for the continued beta or migrate the beta backend now. | The export is Convex-native, while the live target must be self-hostable and portable. Audit cost and migration risk first. |
| O-002 | Create a separate private application repository or add a protected private application repository alongside this public landing repository. | The current repository is public and drives 13 landing-page deployments. Application source and private migration work need a safer boundary. |
| O-003 | Final self-hosted backend packaging: self-hosted Supabase, plain PostgreSQL plus an API, or another approved stack. | Existing documents assume Supabase cloud in places; BuLe's latest decision is self-hosted live. |
| O-004 | Canonical production URL and final cutover date. | Older documents contain multiple URLs and a Sep 2027 target that must not be treated as a current commitment without confirmation. |
| O-005 | Final public/company tagline hierarchy. | Existing assets use both approved phrases. This file distinguishes their present roles without deleting either. |

## Phase plan and gates

### Phase 0 — Continuity capture and governance (**CURRENT**)

Goal: make the project recoverable and prevent AI sessions from acting on stale or conflicting instructions.

Completed:

- Hercules application source exported.
- Convex database and file snapshot exported.
- All 40 files on GitHub `main` reviewed.
- Existing application modules and database collections inventoried.
- Current conflicts and exposure risks identified.
- Canonical status/handoff file prepared.

Remaining gate:

- Merge this status file and AI-entrypoint links.
- Decide the private application-repository boundary.
- Review public operational details and invitation links for sanitization or rotation.
- Record where encrypted/private backups are held; never put secrets or user data in this file.

Exit condition: a new AI can identify the current phase, authoritative files, private-data boundary, and next task without relying on chat history.

### Phase 1 — Recover and stabilize the beta baseline (**NEXT**)

Goal: turn the Hercules export into a reproducible, testable development baseline without changing working behavior unnecessarily.

Work:

- Place application source in the approved private repository.
- Preserve the original export on a tagged archival branch or release.
- Install dependencies and reproduce a clean build.
- Run existing tests and record failures.
- Build a feature matrix: working, partial, broken, unverified.
- Replace only the Hercules-specific pieces required to continue development.
- Validate authentication, tenant isolation, uploads, backup/restore, and financial calculations.
- Validate the critical 375 px mobile flows.
- Define a safe import/mapping plan for the Convex snapshot.

Exit condition: clean build, documented tests, repeatable local setup, no secrets in Git, and an owner-approved beta-backend decision.

### Phase 2 — Invite-only managed cloud beta

Goal: put a controlled beta in selected merchants' hands and collect actionable evidence.

Work:

- Deploy the approved beta stack in managed cloud infrastructure.
- Restrict access to approved testers.
- Import only approved beta data through a reversible migration.
- Add backups, restore verification, error reporting, and privacy-respecting usage measurements.
- Validate the end-to-end merchant journey: opening cash, sale, stock, supplier purchase, customer debt/payment, reports, settings, and daily close.
- Route feedback through the approved tester and feedback channels.
- Keep a release log linked to GitHub versions.

Exit condition: critical flows work on representative mobile devices, recovery is tested, tenant data isolation is verified, and no severity-1 defect remains open.

### Phase 3 — Feedback hardening

Goal: convert beta feedback into a stable Warung product rather than expanding scope prematurely.

Work:

- Triage feedback by frequency, severity, and business impact.
- Fix data-loss, cash, stock, debt, and authentication issues first.
- Improve onboarding and error recovery.
- Complete the offline-first strategy and conflict rules.
- Freeze the live schema and migration contract.
- Define the go/no-go criteria for self-hosting.

Exit condition: owner approves the stable feature set and migration contract; beta reliability and usability meet the documented go/no-go thresholds.

### Phase 4 — Self-host readiness

Goal: prove that the validated beta can operate safely on owner-controlled infrastructure.

Work:

- Validate server capacity and existing services before any installation.
- Package the application, API, PostgreSQL-compatible database, authentication, and object storage for repeatable deployment.
- Separate secrets from code and use least-privilege service accounts.
- Test backups, point-in-time or equivalent recovery, monitoring, alerting, upgrades, and rollback.
- Rehearse the full beta-to-self-host data migration.
- Preserve existing Caddy sites and follow the repository's validate-before-reload rule.

Exit condition: staging rehearsal succeeds, restore and rollback tests pass, and BuLe approves the production cutover plan.

### Phase 5 — Self-hosted live/stable release

Goal: launch the validated TOTAT Warung system on self-hosted infrastructure.

Work:

- Freeze writes or use the approved synchronization window.
- Perform the rehearsed migration.
- Verify record counts, balances, stock, debts, files, and user access.
- Cut over DNS only after health checks pass.
- Monitor closely and retain a tested rollback path.
- Publish only with BuLe's explicit approval.

Exit condition: production is stable, backups and monitoring are active, and post-cutover reconciliation is signed off.

### Phase 6 — Product-family expansion

Goal: expand only after TOTAT Warung is operationally stable.

Candidate modules remain documented in `domain-structure.md`. Their older calendar dates are planning references, not current delivery commitments. Each module requires a separate scope, evidence of demand, and capacity decision.

## Known conflicts and risks

1. **Public operational exposure:** the public repository includes infrastructure addresses, SSH details, internal paths, service topology, external folder links, and an active-looking community invitation. No obvious raw API key, password, or private key was found in the reviewed `main` tree, but the public metadata still needs an owner-approved sanitation review.
2. **Application source missing from GitHub:** the landing/context repository must not be mistaken for the application repository.
3. **Status drift:** several documents say “live,” “build next,” “pending,” and “Sep 2027” for the same components. This file controls current execution status.
4. **Hosting contradiction:** older files mix Hercules, Cloudflare Pages, Supabase cloud, and NL1 responsibilities. Landing pages are separate from the Warung application.
5. **Offline contradiction:** offline-first is a product requirement, while the current beta is cloud-dependent.
6. **Schema status:** `schema.sql` is a proposed PostgreSQL/Supabase migration schema, not proof of a deployed production database.
7. **Historical instructions:** `DEPLOY_STEPS.md`, `CLAUDE_CODE_TASK.md`, `worker.js.bak`, and `wrangler.jsonc.bak` are explicitly superseded or retired.
8. **Branch protection:** the reviewed `main` branch is not protected. The documented PR-only rule therefore depends on agent discipline until repository settings enforce it.

## Immediate next actions

1. Merge the status/handoff PR after BuLe reviews it.
2. Decide O-002: private application repository boundary.
3. Import the Hercules source only; keep the Convex snapshot and images in private backup storage.
4. Reproduce the build and produce a feature/gap/test report.
5. Decide O-001 using evidence from that audit.
6. Continue the invite-only beta only after the privacy, backup, and data-isolation gates are satisfied.

## Update protocol

Update this file in the same pull request whenever any of these changes:

- Current phase or phase exit gate.
- Deployment or domain status.
- Backend, authentication, storage, or repository decision.
- Data migration or backup status.
- A blocker is opened or resolved.
- A reported claim becomes verified or disproven.

Each update must include the date, evidence or link, and status label. Never add credentials, private keys, tokens, personal data, database dumps, or private backup locations.

## Change log

- **2026-09-21 — VERIFIED/DECIDED:** full GitHub repository audit; Hercules source and Convex export recognized as the unfinished application baseline; cloud-beta-to-self-hosted-live direction recorded; phase and handoff tracker created.
