#!/usr/bin/env bash
# =============================================================================
# Spec Development Protocol (SDP) — Installer
# =============================================================================
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/WojcikMM/spec-development-protocol/main/install.sh | bash
#
# Environment variables:
#   SDP_BRANCH   — branch or tag to install from         (default: main)
#   SDP_FORCE    — set to "true" to overwrite existing   (default: false)
#   SDP_TECH_MODE— TECH.md handling: init|overwrite|skip  (default: init)
#   SDP_TARGET   — target directory                      (default: current dir)
# =============================================================================
set -euo pipefail

REPO="WojcikMM/spec-development-protocol"
BRANCH="${SDP_BRANCH:-main}"
FORCE="${SDP_FORCE:-false}"
TECH_MODE="${SDP_TECH_MODE:-init}"
TARGET_DIR="${SDP_TARGET:-$(pwd)}"

EXTRACTED_SUBDIR="spec-development-protocol-${BRANCH}"

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

print_info()    { printf '\033[0;34m[SDP]\033[0m %s\n' "$*"; }
print_success() { printf '\033[0;32m[SDP]\033[0m %s\n' "$*"; }
print_warn()    { printf '\033[0;33m[SDP]\033[0m %s\n' "$*"; }
print_error()   { printf '\033[0;31m[SDP]\033[0m %s\n' "$*" >&2; }

require_cmd() {
  if ! command -v "$1" &>/dev/null; then
    print_error "Required command not found: $1"
    exit 1
  fi
}

# ---------------------------------------------------------------------------
# Preflight checks
# ---------------------------------------------------------------------------

require_cmd curl
require_cmd tar

if [[ ! -d "$TARGET_DIR" ]]; then
  print_error "Target directory does not exist: $TARGET_DIR"
  exit 1
fi

case "$TECH_MODE" in
  init|overwrite|skip) ;;
  *)
    print_error "Invalid SDP_TECH_MODE: ${TECH_MODE} (allowed: init, overwrite, skip)"
    exit 1
    ;;
esac

# ---------------------------------------------------------------------------
# Download and extract
# ---------------------------------------------------------------------------

WORK_DIR=$(mktemp -d)
trap 'rm -rf "$WORK_DIR"' EXIT

print_info "Installing SDP from branch '${BRANCH}' into: ${TARGET_DIR}"
print_info "Downloading archive..."

ARCHIVE_HEADS_URL="https://github.com/${REPO}/archive/refs/heads/${BRANCH}.tar.gz"
ARCHIVE_TAGS_URL="https://github.com/${REPO}/archive/refs/tags/${BRANCH}.tar.gz"

if ! curl -fsSL "$ARCHIVE_HEADS_URL" -o "$WORK_DIR/sdp.tar.gz"; then
  if ! curl -fsSL "$ARCHIVE_TAGS_URL" -o "$WORK_DIR/sdp.tar.gz"; then
    print_error "Failed to download archive for '${BRANCH}'"
    print_error "Tried branch URL: $ARCHIVE_HEADS_URL"
    print_error "Tried tag URL:    $ARCHIVE_TAGS_URL"
    exit 1
  fi
fi

tar -xzf "$WORK_DIR/sdp.tar.gz" -C "$WORK_DIR"

SRC_DIR="$WORK_DIR/${EXTRACTED_SUBDIR}/src"

if [[ ! -d "$SRC_DIR" ]]; then
  print_error "Expected src directory not found in archive."
  exit 1
fi

# ---------------------------------------------------------------------------
# Copy files
# ---------------------------------------------------------------------------

DEST_DIR="$TARGET_DIR/.github"
mkdir -p "$DEST_DIR"

copied=0
skipped=0
tech_initialized=0
tech_preserved=0
tech_overwritten=0
tech_skipped=0

copy_file() {
  local src="$1"
  local dest="$2"

  local dest_dir
  dest_dir="$(dirname "$dest")"
  mkdir -p "$dest_dir"

  if [[ -f "$dest" && "$FORCE" != "true" ]]; then
    skipped=$((skipped + 1))
    return
  fi

  cp "$src" "$dest"
  copied=$((copied + 1))
}

# Walk source tree and copy each file
while IFS= read -r -d '' src_file; do
  # Compute relative path from SRC_DIR
  rel_path="${src_file#"$SRC_DIR"/}"
  dest_file="$DEST_DIR/$rel_path"
  copy_file "$src_file" "$dest_file"
done < <(find "$SRC_DIR" -type f -print0)

# Ensure client TECH.md is initialized from template
TEMPLATE_TECH="$DEST_DIR/templates/TECH.md"
TARGET_TECH="$DEST_DIR/TECH.md"

if [[ -f "$TEMPLATE_TECH" ]]; then
  case "$TECH_MODE" in
    skip)
      tech_skipped=1
      ;;
    init)
      if [[ ! -f "$TARGET_TECH" ]]; then
        cp "$TEMPLATE_TECH" "$TARGET_TECH"
        tech_initialized=1
      else
        tech_preserved=1
      fi
      ;;
    overwrite)
      if [[ -f "$TARGET_TECH" ]]; then
        tech_overwritten=1
      else
        tech_initialized=1
      fi
      cp "$TEMPLATE_TECH" "$TARGET_TECH"
      ;;
  esac
fi

# ---------------------------------------------------------------------------
# Write version marker
# ---------------------------------------------------------------------------

printf '%s\n' "$BRANCH" > "$DEST_DIR/sdp-version"
print_info "  SDP version    : ${BRANCH}"

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------

print_success "Done."
print_info   "  Files copied : ${copied}"

if [[ $skipped -gt 0 ]]; then
  print_warn "  Files skipped (already exist): ${skipped}"
  print_warn "  Run with SDP_FORCE=true to overwrite existing files."
fi

if [[ $tech_initialized -eq 1 ]]; then
  print_info "  TECH.md initialized from template"
elif [[ $tech_overwritten -eq 1 ]]; then
  print_warn "  TECH.md overwritten from template (SDP_TECH_MODE=overwrite)"
elif [[ $tech_preserved -eq 1 ]]; then
  print_info "  Existing TECH.md preserved"
elif [[ $tech_skipped -eq 1 ]]; then
  print_info "  TECH.md update skipped (SDP_TECH_MODE=skip)"
fi

echo ""
print_info "Next step: fill in .github/TECH.md with your project stack and standards."
print_info "See README: https://github.com/${REPO}#readme"
