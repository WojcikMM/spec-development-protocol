#!/usr/bin/env bash
# =============================================================================
# SDP — Template Synchronization
# =============================================================================
# Keeps the canonical .apm/templates/ directory and its APM skill-asset mirror
# (.apm/skills/sdp-templates/assets/) byte-for-byte identical. APM 0.29 cannot
# pack an unrecognized .apm/templates/ directory directly, so the mirror is
# what actually ships inside packed bundles (see CHANGELOG.md).
#
# Usage:
#   scripts/sync-templates.sh            # regenerate the mirror from source
#   scripts/sync-templates.sh --check    # report drift without changing files
# =============================================================================
set -euo pipefail

MODE="sync"
case "${1:-}" in
  "") ;;
  --check) MODE="check" ;;
  --help|-h)
    printf 'Usage: %s [--check]\n' "$0"
    exit 0
    ;;
  *)
    printf 'Unknown argument: %s (expected --check or no argument)\n' "$1" >&2
    exit 2
    ;;
esac

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE_DIR="$REPO_ROOT/.apm/templates"
TARGET_DIR="$REPO_ROOT/.apm/skills/sdp-templates/assets"

if [[ ! -d "$SOURCE_DIR" ]]; then
  printf 'Canonical template directory not found: %s\n' "$SOURCE_DIR" >&2
  exit 1
fi

if [[ "$MODE" == "check" ]]; then
  if [[ ! -d "$TARGET_DIR" ]]; then
    printf 'APM template mirror missing: %s\nRun: scripts/sync-templates.sh\n' "$TARGET_DIR" >&2
    exit 1
  fi

  set +e
  git diff --no-index --quiet -- "$SOURCE_DIR" "$TARGET_DIR"
  diff_status=$?
  set -e

  case "$diff_status" in
    0)
      printf 'Templates are in sync (%s).\n' "$TARGET_DIR"
      exit 0
      ;;
    1)
      printf 'Template drift detected between:\n  %s\n  %s\n' "$SOURCE_DIR" "$TARGET_DIR" >&2
      git --no-pager diff --no-index --stat -- "$SOURCE_DIR" "$TARGET_DIR" >&2 || true
      printf 'Run: scripts/sync-templates.sh\n' >&2
      exit 1
      ;;
    *)
      printf 'git diff failed unexpectedly (exit %s)\n' "$diff_status" >&2
      exit "$diff_status"
      ;;
  esac
fi

rm -rf "$TARGET_DIR"
mkdir -p "$TARGET_DIR"
cp -R "$SOURCE_DIR"/. "$TARGET_DIR"/

FILE_COUNT="$(find "$TARGET_DIR" -type f | wc -l | tr -d '[:space:]')"
printf 'Synced %s template file(s) -> %s\n' "$FILE_COUNT" "$TARGET_DIR"
