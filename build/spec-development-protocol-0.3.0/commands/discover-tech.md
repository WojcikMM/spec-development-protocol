---
description: Scan a legacy codebase to draft a TECH.md file.
argument-hint: "Point to the legacy repo scope so TECH.md can be drafted from code and config."
agent: sdp.discover
---

The `sdp.discover` agent will:
1. Scan the repository for evidence of the tech stack.
2. Draft a `TECH.md` file based on its findings.
3. Mark any unknown values as `<define>` for you to fill in.

This is for **existing projects** without a `TECH.md`. For new projects, fill it in manually.

