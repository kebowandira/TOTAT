# TOTAT — Project Status (public summary)

> This is the public-safe summary. The full phase/decision tracker, with
> infrastructure detail and internal risk register, lives in the private
> `kebowandira/totat-internal` repository.
>
> Last reviewed: 2026-09-24 (UTC)
> Maintainer: BuLe / PT Catat Mapan

## Current phase

**Phase 0 — continuity capture and governance.**

The Hercules beta produced a substantial TOTAT Warung application. The
current objective is to preserve that working beta, establish a reproducible
private development baseline, and continue an invite-only cloud beta. The
approved long-term destination is a portable self-hosted release once beta
feedback has validated the product.

## What's public here vs. private

This repository (`kebowandira/TOTAT`) contains only:

- 13 independent Cloudflare Pages landing-page folders under `sites/`.
- General contributor docs: `AGENTS.md`, `claude-shared-context/conventions.md`,
  `claude-shared-context/schema.sql` (proposed schema, not a live-DB
  description), `claude-shared-context/domain-structure.md`,
  `claude-shared-context/AI_ROLES.md`.

It does **not** contain and never should: the TOTAT Warung application
source, server/infrastructure addresses, SSH access detail, the Convex
database snapshot, uploaded user images, credentials, or environment files.

## Product invariants

- Product: TOTAT (Toko Catat), beginning with TOTAT Warung.
- Primary product/UI tagline: **"Catat mudah, untung jelas."**
- Indonesian informal interface; use "kamu," not "Anda."
- Mobile-first; minimum 44 px touch targets; validate at 375 px width.
- Primary teal: `#2A9D8F`.
- One visible action per tap; important actions must not be hidden.
- Free core functionality remains complete; premium is for added complexity
  such as multi-outlet or investor views.
- Preserve working behavior. Changes are additive unless BuLe explicitly
  approves a refactor.

## Working rules for this repository

- Use GitHub pull requests; do not push directly to `main`. BuLe approves
  merges.
- Treat any file that would name a server address, SSH port/key, or internal
  deployment path as **not belonging in this repository** — that content
  lives in `kebowandira/totat-internal`. If you don't have access to it and
  need infrastructure context, ask BuLe rather than reconstructing it from
  an old commit in this repo's history.

## Change log

- **2026-09-24 — DECIDED:** internal operational docs split out to private
  `kebowandira/totat-internal` per a repository security review. This file
  replaces the previous full version, which is now maintained privately.
