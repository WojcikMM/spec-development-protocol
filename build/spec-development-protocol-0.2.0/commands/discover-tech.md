---
description: Trigger Discover Agent to scan an existing codebase and draft TECH.md from real evidence.
argument-hint: "Point to the legacy repo scope and constraints so TECH.md can be drafted from existing code and config."
agent: sdp.discover
---

## Before You Start

This prompt is for **existing projects** that do not yet have a `.github/TECH.md`, or where TECH.md needs updating to reflect the actual codebase.

For new greenfield projects, skip this — fill in `TECH.md` manually instead.

## What Happens

The `sdp.discover` agent will:
1. Scan the repository for evidence of the tech stack (package manifests, configs, CI pipelines, IaC files).
2. Draft a `TECH.md` aligned to the SDP template structure.
3. Mark unknowns as `<define>` and provide a review checklist.
4. **Not guess** — only document what is evidenced in the repository.

## Next Gate

After reviewing and approving `TECH.md` → run `create-prd` to start specifying your first feature or change.

