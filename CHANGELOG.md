# Changelog

All notable changes to the Spec Development Protocol (SDP) are documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

---

## [Unreleased]

### Added
- `src/skills/` directory with 5 web-focused skill files:
  - `sdp.skill.write-tests.md` — unit and integration test guidance (AAA, TDD, behavior-based testing)
  - `sdp.skill.create-api-endpoint.md` — REST API endpoint design, validation, auth, error handling
  - `sdp.skill.create-ui-component.md` — frontend component structure, accessibility, state, testing
  - `sdp.skill.database-migration.md` — safe schema migrations, rollback patterns, zero-downtime techniques
  - `sdp.skill.error-handling.md` — error classification, structured logging, safe API responses, retries
- `src/templates/template.skill.md` — starter template for writing custom skills
- `src/prompts/qa-validate.prompt.md` — missing prompt for triggering the QA agent (Gate 6)
- `.github/sdp-version` file written by installer to track installed SDP version
- Feedback loops table in `sdlc-process.instructions.md` documenting return paths for each failure type
- Handoff sequence documentation in `sdp.reviewer.agent.md` and `sdp.qa.agent.md`

### Fixed
- `src/prompts/create-prd.prompt.md` was incorrectly set to `agent: sdp.analyst`; corrected to `agent: sdp.prd`
- `sdp.reviewer.agent.md` had duplicate content between `Responsibilities` and `Review Focus` sections; duplicate removed
- `sdp.developer.agent.md` had three concurrent Gate 6 handoffs (reviewer + security + QA simultaneously); now hands off only to `sdp.reviewer` to enforce the sequential Gate 6 flow

### Changed
- `src/templates/TECH.md` — replaced Azure-specific sections (Azure DevOps, Bicep, Azure Key Vault) with platform-agnostic equivalents covering any CI/CD system, hosting provider, and secrets manager; kept web-application focus
- All agent `Mandatory Context` sections updated: removed "Azure environment constraints" wording; now references "project-specific constraints" from `TECH.md`
- `src/agents/sdp.security.agent.md` — replaced Azure security baselines with OWASP Web Top 10 and generic web security checks (CSP, CORS, cookies, secrets manager agnostic)
- `src/agents/sdp.architect.agent.md` — added explicit output path `docs/architecture/DESIGN-<slug>.md`
- All prompts enriched with prerequisite checklists, descriptions of what will happen, and next-gate guidance
- `README.md` — added Skills section, end-to-end Quick Start example table, feedback loops description, `sdp-version` mention; corrected "Agents hand off automatically" to "Agents suggest handoffs"

---

## [v0.1.0] — Initial release

### Added
- 6-gate SDLC process (`sdlc-process.instructions.md`)
- 8 agents: `sdp.prd`, `sdp.discover`, `sdp.analyst`, `sdp.architect`, `sdp.developer`, `sdp.reviewer`, `sdp.security`, `sdp.qa`
- 8 prompts covering all gates
- `copilot-instructions.md` with global coding standards
- `TECH.md` template
- `install.sh` with `SDP_BRANCH`, `SDP_FORCE`, `SDP_TECH_MODE`, `SDP_TARGET` options
- `template.agent.md` and `template.prompt.md`
