#Requires -Version 7

# Windows / PowerShell counterpart of install.sh.
# Mirrors the Linux bootstrap flow: dependency checks, dependency install,
# Claude/Codex marketplaces, Claude + Copilot plugins, nb-catalog, design.md,
# and the helper scripts. The Wayland/X11 chrome-devtools wrapper is Linux-only
# and is intentionally skipped on Windows.

$ErrorActionPreference = 'Stop'

$RepoRoot = $PSScriptRoot
$MarketplaceRepo = 'sneverton/nimbou-skills'
$PluginName = 'nimbou-skills'
$CopilotPluginSource = Join-Path $RepoRoot "plugins\$PluginName"
$CodexWrapperScript = Join-Path $RepoRoot 'scripts\setup-codex-full-wrapper.ps1'
$VscodeCopilotChatScript = Join-Path $RepoRoot 'scripts\setup-vscode-copilot-chat.ps1'
$CodexSkillsScript = Join-Path $RepoRoot 'scripts\setup-codex-skills.ps1'
$PythonDocxScript = Join-Path $RepoRoot 'scripts\setup-python-docx.ps1'
$PluginManifest = Join-Path $RepoRoot "plugins\$PluginName\.claude-plugin\plugin.json"
$CodexMarketplaceDir = $RepoRoot
$PluginId = "$PluginName@$PluginName"
$NodeMinMajor = 20
$LocalPrefix = Join-Path $env:USERPROFILE '.local'

$PwshExe = (Get-Process -Id $PID).Path

function Fail {
  param([string]$Message)
  [Console]::Error.WriteLine($Message)
  exit 1
}

function Require-Command {
  param([string]$Name)
  if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
    Fail "Missing required command: $Name"
  }
}

function Read-PluginVersion {
  (Get-Content -LiteralPath $PluginManifest -Raw | ConvertFrom-Json).version
}

function Get-InstalledPluginVersion {
  $raw = claude plugin list --json 2>$null
  if (-not $raw) { return $null }
  try { $plugins = $raw | ConvertFrom-Json } catch { return $null }
  $match = $plugins | Where-Object { $_.id -eq $PluginId -and $_.scope -eq 'user' } | Select-Object -First 1
  if (-not $match) {
    $match = $plugins | Where-Object { $_.id -eq $PluginId } | Select-Object -First 1
  }
  if ($match) { return $match.version }
  return $null
}

function Get-InstalledCopilotPluginVersion {
  $lines = copilot plugin list 2>$null
  if (-not $lines) { return $null }
  $escaped = [regex]::Escape($PluginName)
  $pattern = "^\s*[" + [char]0x2022 + "-]\s*$escaped(?:@[^ ]+)?\s+\(v([^)]*)\)"
  foreach ($line in $lines) {
    $m = [regex]::Match($line, $pattern)
    if ($m.Success) { return $m.Groups[1].Value }
  }
  return $null
}

function Require-CodexMarketplaceSupport {
  if (-not (Get-Command codex -ErrorAction SilentlyContinue)) {
    Fail "Codex CLI not found. Install Codex rust-v0.121.0+ or newer, then rerun install.ps1."
  }
  codex plugin marketplace --help *> $null
  if ($LASTEXITCODE -ne 0) {
    Fail "Codex marketplace support is required. Install Codex rust-v0.121.0+ or newer, then rerun install.ps1."
  }
}

function Sync-MarketplaceCache {
  $cacheDir = Join-Path $env:USERPROFILE ".claude\plugins\marketplaces\$PluginName"
  if (Test-Path -LiteralPath $cacheDir) {
    Write-Host "Syncing local plugin to Claude marketplace cache..."
    $src = Join-Path $RepoRoot "plugins\$PluginName"
    $dst = Join-Path $cacheDir "plugins\$PluginName"
    # robocopy uses exit codes 0-7 for success; 8+ means real failures.
    robocopy $src $dst /MIR /NJH /NJS /NFL /NDL /NP *> $null
    if ($LASTEXITCODE -ge 8) {
      Write-Warning "robocopy reported errors syncing the marketplace cache (exit $LASTEXITCODE)."
    }
    $global:LASTEXITCODE = 0
  }
}

function Add-ToUserPath {
  param([string]$Dir)

  $userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
  $parts = @()
  if ($userPath) { $parts = $userPath -split ';' | Where-Object { $_ -ne '' } }
  if ($parts -notcontains $Dir) {
    $newPath = (@($Dir) + $parts) -join ';'
    [Environment]::SetEnvironmentVariable('Path', $newPath, 'User')
    Write-Host "Added to user PATH: $Dir"
  }
  # Update the current process so the verification checks resolve immediately.
  if (($env:Path -split ';') -notcontains $Dir) {
    $env:Path = "$Dir;$env:Path"
  }
}

function Test-CommandOrShim {
  param([string]$Name, [string]$ShimName)
  if (Get-Command $Name -ErrorAction SilentlyContinue) { return $true }
  return (Test-Path -LiteralPath (Join-Path $LocalPrefix $ShimName))
}

Require-Command node
Require-Command claude
Require-Command copilot

$NodeMajor = [int](node -p "process.versions.node.split('.')[0]")
if ($NodeMajor -lt $NodeMinMajor) {
  Fail "Node >= $NodeMinMajor is required. Found $(node -v)."
}

Require-CodexMarketplaceSupport

Write-Host "Installing local dependencies in $RepoRoot..."
pnpm install --dir $RepoRoot
if ($LASTEXITCODE -ne 0) { Fail "pnpm install failed." }

$ExpectedPluginVersion = Read-PluginVersion
$InstalledPluginVersion = Get-InstalledPluginVersion
$InstalledCopilotPluginVersion = Get-InstalledCopilotPluginVersion

# Codex marketplace
codex plugin marketplace add $CodexMarketplaceDir *> $null
if ($LASTEXITCODE -eq 0) {
  Write-Host "Codex marketplace added: $CodexMarketplaceDir"
} else {
  Fail "Failed to register the Codex marketplace. Install Codex rust-v0.121.0+ or newer and rerun install.ps1."
}

# Claude Code plugin via marketplace
Write-Host "Registering Claude Code marketplace..."
claude plugin marketplace add $MarketplaceRepo *> $null
if ($LASTEXITCODE -eq 0) {
  Write-Host "Marketplace added: $MarketplaceRepo"
} else {
  Write-Host "Marketplace already registered or updated."
}

Sync-MarketplaceCache

if ($InstalledPluginVersion -eq $ExpectedPluginVersion) {
  Write-Host "Claude Code plugin already installed at version $InstalledPluginVersion; reinstalling to refresh marketplace copy."
}

Write-Host "Installing Claude Code plugin version $ExpectedPluginVersion..."
if ($InstalledPluginVersion) {
  claude plugin uninstall $PluginName --scope user *> $null
}
claude plugin install $PluginName --scope user *> $null
if ($LASTEXITCODE -eq 0) {
  Write-Host "Plugin installed: $PluginName@$ExpectedPluginVersion"
} else {
  Write-Host "Plugin install failed."
}

# GitHub Copilot plugin
if ($InstalledCopilotPluginVersion -eq $ExpectedPluginVersion) {
  Write-Host "Copilot plugin already installed at version $InstalledCopilotPluginVersion; skipping reinstall."
} else {
  Write-Host "Installing Copilot plugin version $ExpectedPluginVersion..."
  copilot plugin install $CopilotPluginSource
  if ($LASTEXITCODE -eq 0) {
    Write-Host "Plugin installed: $PluginName@$ExpectedPluginVersion"
  } else {
    Write-Host "Plugin already installed or updated."
  }
}

# nb-catalog CLI
Write-Host "Linking nb-catalog globally..."
$env:npm_config_prefix = $LocalPrefix
npm link
if ($LASTEXITCODE -ne 0) { Fail "npm link failed for nb-catalog." }

Add-ToUserPath $LocalPrefix

if (-not (Test-CommandOrShim -Name 'nb-catalog' -ShimName 'nb-catalog.cmd')) {
  Fail "nb-catalog was not found in PATH after linking."
}

# Google DESIGN.md CLI
Write-Host "Installing @google/design.md globally..."
$env:npm_config_prefix = $LocalPrefix
npm install -g '@google/design.md'
if ($LASTEXITCODE -ne 0) { Fail "npm install -g @google/design.md failed." }

if (-not (Test-CommandOrShim -Name 'design.md' -ShimName 'design.md.cmd')) {
  Fail "@google/design.md was not found in PATH after installation."
}

Write-Host "Ensuring Codex wrapper exists..."
& $PwshExe -NoProfile -File $CodexWrapperScript

Write-Host "Ensuring VS Code Copilot Chat links exist..."
& $PwshExe -NoProfile -File $VscodeCopilotChatScript

Write-Host "Ensuring Codex skills links exist..."
& $PwshExe -NoProfile -File $CodexSkillsScript

Write-Host "Ensuring python-docx is available (docx-builder-gen skill)..."
& $PwshExe -NoProfile -File $PythonDocxScript

$CodexWrapperPath = if ($env:CODEX_WRAPPER_PATH) { $env:CODEX_WRAPPER_PATH } else { Join-Path $LocalPrefix 'codex-full.cmd' }
$CodexSkillsDir = if ($env:CODEX_SKILLS_DIR) { $env:CODEX_SKILLS_DIR } else { Join-Path $env:USERPROFILE '.codex\skills' }
$CopilotChatSkillsDir = if ($env:COPILOT_CHAT_SKILLS_DIR) { $env:COPILOT_CHAT_SKILLS_DIR } else { Join-Path $env:USERPROFILE '.copilot\skills' }
$VscodeUserPromptsDir = if ($env:VSCODE_USER_PROMPTS_DIR) { $env:VSCODE_USER_PROMPTS_DIR } else { Join-Path $env:APPDATA 'Code\User\prompts' }

$nbCatalogPath = (Get-Command nb-catalog -ErrorAction SilentlyContinue).Source
$designMdPath = (Get-Command 'design.md' -ErrorAction SilentlyContinue).Source

Write-Host ""
Write-Host "Installation complete."
Write-Host "  Codex marketplace: $CodexMarketplaceDir"
Write-Host "  Claude plugin: $PluginName@$MarketplaceRepo"
Write-Host "  Copilot plugin:  $CopilotPluginSource"
Write-Host "  CLI:           $(if ($nbCatalogPath) { $nbCatalogPath } else { Join-Path $LocalPrefix 'nb-catalog.cmd' })"
Write-Host "  DESIGN CLI:    $(if ($designMdPath) { $designMdPath } else { Join-Path $LocalPrefix 'design.md.cmd' })"
Write-Host "  Wrapper:       $CodexWrapperPath"
Write-Host "  Codex skills:  $CodexSkillsDir"
Write-Host "  VS Code Copilot Chat skills: $CopilotChatSkillsDir"
Write-Host "  VS Code prompts: $VscodeUserPromptsDir"
Write-Host ""
Write-Host "Restart Claude Code, Codex, and VS Code to activate."
Write-Host "Open a new terminal so the updated PATH ($LocalPrefix) takes effect."
