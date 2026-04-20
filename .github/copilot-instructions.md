# Copilot Maintainer Instructions - SDP Library

You are maintaining the Spec Development Protocol (SDP) template repository.

## Repository Model

- Source files for distribution are stored in `src/`.
- Client projects must receive these files under `.github/` after running `install.sh`.
- This repository's own `.github/` folder is for maintainer workflow and automation only.

## Primary Goal

Keep the library consistent, versionable, and safe to reuse across projects.
Every change must preserve the contract:

- `src/*` is the canonical template source.
- Installer copies `src/*` to client `.github/*`.

## Change Flow (Required)

1. Identify the requested change and map it to one or more areas:
	 - Template content (`src/agents`, `src/prompts`, `src/instructions`, `src/templates`, `src/copilot-instructions.md`)
	 - Installation behavior (`install.sh`)
	 - User documentation (`README.md`)
2. Implement content changes in `src/` first (never in repository `.github/` as template source).
3. Update `install.sh` if source layout, copy logic, or install-time behavior changes.
4. Update `README.md` whenever behavior, structure, commands, or setup expectations change.
5. Validate and summarize what changed and why.

## Mandatory Sync Rules

When any of the following happens, updates are required:

- New file/folder added in `src/`:
	- Update `README.md` structure or usage sections if users should know about it.
	- Verify `install.sh` still copies it to client `.github/`.
- File/folder renamed/moved in `src/`:
	- Update `install.sh` assumptions if needed.
	- Update all affected paths in `README.md`.
- Install behavior changed:
	- Update `README.md` Quick Install/Options/Manual Install sections.
- Runtime expectations changed (for example, TECH initialization, force behavior, branch/tag behavior):
	- Update both `README.md` and `install.sh` comments/output.

Do not leave behavior and docs out of sync.

## Standards for New Files

- Use clear, explicit naming aligned with SDP terms.
- Keep templates generic and reusable across greenfield and legacy projects.
- Prefer practical instructions over vague principles.
- Preserve gate discipline and traceability across PRD -> backlog -> design -> plan -> implementation -> hardening.
- Use ASCII by default.

## Safety and Compatibility

- Do not delete or overwrite unrelated user files in client repositories.
- Default install behavior must remain non-destructive.
- Overwrite behavior must stay explicit (`SDP_FORCE=true`).
- Keep installer dependencies minimal (`curl`, `tar`, POSIX-friendly shell usage where possible).

## Validation Checklist (Run Before Finishing)

1. `bash -n install.sh` passes.
2. New/changed paths in `src/` are correctly reflected in documentation.
3. `README.md` examples match actual installer behavior.
4. If install behavior changed, output messages remain accurate.
5. If template structure changed, confirm installed destination is still `.github/` in client repositories.

## Output Expectations for Maintainer Tasks

When completing a change, always report:

- What changed in `src/`
- Whether `README.md` was updated
- Whether `install.sh` was updated
- Why each update was or was not required
