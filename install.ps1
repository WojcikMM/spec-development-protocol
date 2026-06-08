# =============================================================================
# Spec Development Protocol (SDP) — Installer (PowerShell)
# =============================================================================
# Usage:
#   iwr -useb https://raw.githubusercontent.com/WojcikMM/spec-development-protocol/main/install.ps1 | iex
#
# Environment variables:
#   $env:SDP_BRANCH    — branch or tag to install from          (default: main)
#   $env:SDP_FORCE     — set to "true" to overwrite existing    (default: false)
#   $env:SDP_TECH_MODE — TECH.md handling: init|overwrite|skip  (default: init)
#   $env:SDP_TARGET    — target directory                       (default: current dir)
# =============================================================================
#Requires -Version 5.1
[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------

$REPO      = 'WojcikMM/spec-development-protocol'
$BRANCH    = if ($env:SDP_BRANCH)    { $env:SDP_BRANCH }    else { 'main' }
$FORCE     = if ($env:SDP_FORCE)     { $env:SDP_FORCE }     else { 'false' }
$TECH_MODE = if ($env:SDP_TECH_MODE) { $env:SDP_TECH_MODE } else { 'init' }
$TARGET_DIR = if ($env:SDP_TARGET)   { $env:SDP_TARGET }    else { (Get-Location).Path }

$EXTRACTED_SUBDIR = "spec-development-protocol-$BRANCH"

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

function Write-SdpInfo    { param([string]$Msg) Write-Host "[SDP] $Msg" -ForegroundColor Cyan }
function Write-SdpSuccess { param([string]$Msg) Write-Host "[SDP] $Msg" -ForegroundColor Green }
function Write-SdpWarn    { param([string]$Msg) Write-Host "[SDP] $Msg" -ForegroundColor Yellow }
function Write-SdpError   { param([string]$Msg) Write-Host "[SDP] $Msg" -ForegroundColor Red }

# Ensure TLS 1.2+ is used for all web requests
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 -bor [Net.SecurityProtocolType]::Tls13

# ---------------------------------------------------------------------------
# Preflight checks
# ---------------------------------------------------------------------------

if (-not (Test-Path -LiteralPath $TARGET_DIR -PathType Container)) {
    Write-SdpError "Target directory does not exist: $TARGET_DIR"
    exit 1
}

if ($TECH_MODE -notin @('init', 'overwrite', 'skip')) {
    Write-SdpError "Invalid SDP_TECH_MODE: $TECH_MODE (allowed: init, overwrite, skip)"
    exit 1
}

# ---------------------------------------------------------------------------
# Download and extract
# ---------------------------------------------------------------------------

$WORK_DIR = Join-Path ([System.IO.Path]::GetTempPath()) ([System.IO.Path]::GetRandomFileName())
New-Item -ItemType Directory -Path $WORK_DIR | Out-Null

try {

$ARCHIVE_HEADS_URL = "https://github.com/$REPO/archive/refs/heads/$BRANCH.zip"
$ARCHIVE_TAGS_URL  = "https://github.com/$REPO/archive/refs/tags/$BRANCH.zip"
$ARCHIVE_PATH      = Join-Path $WORK_DIR 'sdp.zip'
$INSTALLED_FROM    = 'tag'  # assume tag; overwritten to "branch" if heads URL succeeds

Write-SdpInfo "Installing SDP from '$BRANCH' into: $TARGET_DIR"
Write-SdpInfo "Downloading archive..."

$downloaded = $false
try {
    Invoke-WebRequest -Uri $ARCHIVE_HEADS_URL -OutFile $ARCHIVE_PATH -UseBasicParsing
    $INSTALLED_FROM = 'branch'
    $downloaded = $true
} catch {
    # heads URL failed — try tags URL
}

if (-not $downloaded) {
    try {
        Invoke-WebRequest -Uri $ARCHIVE_TAGS_URL -OutFile $ARCHIVE_PATH -UseBasicParsing
        $downloaded = $true
    } catch {
        Write-SdpError "Failed to download archive for '$BRANCH'"
        Write-SdpError "Tried branch URL: $ARCHIVE_HEADS_URL"
        Write-SdpError "Tried tag URL:    $ARCHIVE_TAGS_URL"
        exit 1
    }
}

Expand-Archive -LiteralPath $ARCHIVE_PATH -DestinationPath $WORK_DIR -Force

$SRC_DIR = Join-Path $WORK_DIR "$EXTRACTED_SUBDIR\.apm"

if (-not (Test-Path -LiteralPath $SRC_DIR -PathType Container)) {
    Write-SdpError "Expected .apm directory not found in archive."
    exit 1
}

# ---------------------------------------------------------------------------
# Copy files
# ---------------------------------------------------------------------------

$DEST_DIR = Join-Path $TARGET_DIR '.github'
New-Item -ItemType Directory -Path $DEST_DIR -Force | Out-Null

$copied   = 0
$skipped  = 0

Get-ChildItem -LiteralPath $SRC_DIR -Recurse -File | ForEach-Object {
    $srcFile  = $_.FullName
    $relPath  = $srcFile.Substring($SRC_DIR.Length).TrimStart('\', '/')
    $destFile = Join-Path $DEST_DIR $relPath

    $destFileDir = Split-Path -Parent $destFile
    if (-not (Test-Path -LiteralPath $destFileDir)) {
        New-Item -ItemType Directory -Path $destFileDir -Force | Out-Null
    }

    if ((Test-Path -LiteralPath $destFile) -and ($FORCE -ne 'true')) {
        $skipped++
        return
    }

    Copy-Item -LiteralPath $srcFile -Destination $destFile -Force
    $copied++
}

# Ensure client TECH.md is initialized from template
$TEMPLATE_TECH = Join-Path $DEST_DIR 'templates\TECH.md'
$TARGET_TECH   = Join-Path $DEST_DIR 'TECH.md'

$techInitialized = $false
$techPreserved   = $false
$techOverwritten = $false
$techSkipped     = $false

if (Test-Path -LiteralPath $TEMPLATE_TECH) {
    switch ($TECH_MODE) {
        'skip' {
            $techSkipped = $true
        }
        'init' {
            if (-not (Test-Path -LiteralPath $TARGET_TECH)) {
                Copy-Item -LiteralPath $TEMPLATE_TECH -Destination $TARGET_TECH
                $techInitialized = $true
            } else {
                $techPreserved = $true
            }
        }
        'overwrite' {
            if (Test-Path -LiteralPath $TARGET_TECH) {
                $techOverwritten = $true
            } else {
                $techInitialized = $true
            }
            Copy-Item -LiteralPath $TEMPLATE_TECH -Destination $TARGET_TECH -Force
        }
    }
}

# ---------------------------------------------------------------------------
# Write version marker
# ---------------------------------------------------------------------------

$SDP_VERSION = $BRANCH

if ($INSTALLED_FROM -eq 'branch') {
    $COMMIT_SHA_URL = "https://api.github.com/repos/$REPO/commits/$BRANCH"
    try {
        $apiResponse = Invoke-RestMethod -Uri $COMMIT_SHA_URL `
            -Headers @{ Accept = 'application/vnd.github+json'; 'User-Agent' = 'sdp-installer' } `
            -UseBasicParsing
        $shortSha = $apiResponse.sha.Substring(0, 7)
        $SDP_VERSION = "${BRANCH}@${shortSha}"
    } catch {
        Write-SdpWarn "Could not resolve commit SHA for branch '$BRANCH'; version marker will use branch name only."
    }
}

Set-Content -LiteralPath (Join-Path $DEST_DIR 'sdp-version') -Value $SDP_VERSION
Write-SdpInfo "  SDP version    : $SDP_VERSION"

# ---------------------------------------------------------------------------
# Create spec/ directory for feature folders
# ---------------------------------------------------------------------------

$SPEC_DIR = Join-Path $TARGET_DIR 'spec'

if (-not (Test-Path -LiteralPath $SPEC_DIR -PathType Container)) {
    New-Item -ItemType Directory -Path $SPEC_DIR | Out-Null
    Write-SdpInfo "  spec/ directory created"
}

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------

Write-SdpSuccess "Done."
Write-SdpInfo   "  Files copied : $copied"

if ($skipped -gt 0) {
    Write-SdpWarn "  Files skipped (already exist): $skipped"
    Write-SdpWarn "  Run with `$env:SDP_FORCE='true' to overwrite existing files."
}

if ($techInitialized) {
    Write-SdpInfo "  TECH.md initialized from template"
} elseif ($techOverwritten) {
    Write-SdpWarn "  TECH.md overwritten from template (SDP_TECH_MODE=overwrite)"
} elseif ($techPreserved) {
    Write-SdpInfo "  Existing TECH.md preserved"
} elseif ($techSkipped) {
    Write-SdpInfo "  TECH.md update skipped (SDP_TECH_MODE=skip)"
}

Write-Host ""
Write-SdpInfo "Next step: fill in .github/TECH.md with your project stack and standards."
Write-SdpInfo "See README: https://github.com/$REPO#readme"

} finally {
    # Cleanup temp directory
    if (Test-Path -LiteralPath $WORK_DIR) {
        Remove-Item -LiteralPath $WORK_DIR -Recurse -Force -ErrorAction SilentlyContinue
    }
}
