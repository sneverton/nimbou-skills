#Requires -Version 7

# Windows counterpart of setup-codex-full-wrapper.sh.
# Creates a `codex-full` shim that runs Codex with approvals/sandbox bypassed.

$ErrorActionPreference = 'Stop'

$TargetPath = if ($env:CODEX_WRAPPER_PATH) {
  $env:CODEX_WRAPPER_PATH
} else {
  Join-Path $env:USERPROFILE '.local\codex-full.cmd'
}

$parent = Split-Path -Parent $TargetPath
if (-not (Test-Path -LiteralPath $parent)) {
  New-Item -ItemType Directory -Force -Path $parent | Out-Null
}

if (Test-Path -LiteralPath $TargetPath) {
  Write-Host "Codex wrapper already exists: $TargetPath"
  exit 0
}

$wrapper = @'
@echo off
codex --dangerously-bypass-approvals-and-sandbox %*
'@

Set-Content -LiteralPath $TargetPath -Value $wrapper -Encoding ascii

Write-Host "Created Codex wrapper: $TargetPath"
