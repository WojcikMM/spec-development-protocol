# Changelog

All notable changes to the Spec Development Protocol (SDP) are documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

---

## [Unreleased]

### Added
- `apm.json` — Agent Package Manager manifest defining package metadata, components (agents, skills, prompts, templates), and installers
- `package.json` — npm ecosystem compatibility manifest with scoped package name `@wojcikmm/spec-development-protocol`
- APM installation method documented in `README.md` (Method 2)
- APM Package Structure section in `README.md` explaining manifest structure and distribution model
- `sdp.developer.agent.md` — new `Approve plan and proceed to implementation` handoff entry in frontmatter, providing a one-click option to approve the plan produced by `/plan-task` and immediately move to implement mode (alternative to manually invoking `/implement`)
- `install.ps1` — PowerShell installer for Windows users (PowerShell 5.1+/7+), feature-parity with `install.sh`: same environment variables (`SDP_BRANCH`, `SDP_FORCE`, `SDP_TECH_MODE`, `SDP_TARGET`), TECH.md modes, commit-SHA versioning for branch installs, and `spec/` directory creation
- `README.md` — Windows Quick Install section with PowerShell one-liner (`iwr … | iex`), execution-policy note, and PowerShell examples for all install scenarios

### Changed
- `install.sh` — versioning now appends the short commit SHA when installing from a branch (e.g., `main@a1b2c3d`), making branch-based installs comparable and traceable; tag-based installs continue to use the tag name unchanged
- `src/skills/` restructured to comply with the [Agent Skills open standard](https://agentskills.io): each skill is now a subfolder (`<skill-name>/`) containing a `SKILL.md` file instead of a flat `sdp.skill.<name>.md` file
  - `sdp.skill.write-tests.md` → `write-tests/SKILL.md`
  - `sdp.skill.create-api-endpoint.md` → `create-api-endpoint/SKILL.md`
  - `sdp.skill.create-ui-component.md` → `create-ui-component/SKILL.md`
  - `sdp.skill.database-migration.md` → `database-migration/SKILL.md`
  - `sdp.skill.error-handling.md` → `error-handling/SKILL.md`
- All skill frontmatter updated to include both `name` and `description` fields (required by the Agent Skills standard)
- `README.md` — Skills section updated: table now lists skill folders instead of flat files; Customization and Project Structure sections updated to reflect the new layout

### Added
- `src/skills/` directory with 5 web-focused skill files:
  - `write-tests/SKILL.md` — unit and integration test guidance (AAA, TDD, behavior-based testing)
  - `create-api-endpoint/SKILL.md` — REST API endpoint design, validation, auth, error handling
  - `create-ui-component/SKILL.md` — frontend component structure, accessibility, state, testing
  - `database-migration/SKILL.md` — safe schema migrations, rollback patterns, zero-downtime techniques
  - `error-handling/SKILL.md` — error classification, structured logging, safe API responses, retries
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
