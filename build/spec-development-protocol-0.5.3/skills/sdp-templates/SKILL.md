---
name: sdp-templates
description: Canonical SDP artifact and customization templates packaged as APM-compatible skill assets.
---

# SDP Templates

Use the files in `assets/` when the SDP process instructions select this skill directory as `SDP_TEMPLATE_ROOT`.

These generated assets mirror `.apm/templates/`, which is the only authoring
source. Do not edit assets directly or load both copies into context. Maintainers
regenerate the mirror with `scripts/sync-templates.sh` for APM packaging.