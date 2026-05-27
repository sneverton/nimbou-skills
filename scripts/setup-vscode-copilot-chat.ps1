#Requires -Version 7

# Windows counterpart of setup-vscode-copilot-chat.sh.
# Links the shared skills and Codex command mirrors into the Copilot Chat skills
# directory (directory junctions), and copies the review/auditing agents into the
# VS Code user prompts directories. Agents are copied rather than linked because
# junctions only work for directories, not individual files.

$ErrorActionPreference = 'Stop'

$ScriptDir = $PSScriptRoot
$RepoRoot = Split-Path -Parent $ScriptDir
$SharedSkillsDir = Join-Path $RepoRoot 'plugins\nimbou-skills\skills'
$CodexCommandSkillsDir = Join-Path $RepoRoot '.codex\skills'
$AgentsDir = Join-Path $RepoRoot 'plugins\nimbou-skills\agents'
$CopilotChatSkillsDir = if ($env:COPILOT_CHAT_SKILLS_DIR) {
  $env:COPILOT_CHAT_SKILLS_DIR
} else {
  Join-Path $env:USERPROFILE '.copilot\skills'
}
$VscodeUserPromptsDir = if ($env:VSCODE_USER_PROMPTS_DIR) {
  $env:VSCODE_USER_PROMPTS_DIR
} else {
  Join-Path $env:APPDATA 'Code\User\prompts'
}
$VscodeUserAgentsDir = if ($env:VSCODE_USER_AGENTS_DIR) {
  $env:VSCODE_USER_AGENTS_DIR
} else {
  Join-Path $VscodeUserPromptsDir 'agents'
}

function Set-DirJunction {
  param(
    [string]$Source,
    [string]$Target,
    [string]$Label
  )

  $parent = Split-Path -Parent $Target
  if (-not (Test-Path -LiteralPath $parent)) {
    New-Item -ItemType Directory -Force -Path $parent | Out-Null
  }

  $item = Get-Item -LiteralPath $Target -Force -ErrorAction SilentlyContinue
  if ($item -and $item.LinkType -eq 'Junction') {
    # Delete only the reparse point, never the target contents.
    [System.IO.Directory]::Delete($Target, $false)
    New-Item -ItemType Junction -Path $Target -Value $Source | Out-Null
    Write-Host "$Label already linked: $Target"
    return
  }

  if ($item) {
    Write-Warning "Skipping existing ${Label}: $Target"
    return
  }

  New-Item -ItemType Junction -Path $Target -Value $Source | Out-Null
  Write-Host "Linked ${Label}: $Target"
}

function Copy-AgentFile {
  param(
    [string]$Source,
    [string]$Target,
    [string]$Label
  )

  $parent = Split-Path -Parent $Target
  if (-not (Test-Path -LiteralPath $parent)) {
    New-Item -ItemType Directory -Force -Path $parent | Out-Null
  }

  Copy-Item -LiteralPath $Source -Destination $Target -Force
  Write-Host "Copied ${Label}: $Target"
}

New-Item -ItemType Directory -Force -Path $CopilotChatSkillsDir, $VscodeUserPromptsDir, $VscodeUserAgentsDir | Out-Null

foreach ($skillsDir in @($SharedSkillsDir, $CodexCommandSkillsDir)) {
  if (-not (Test-Path -LiteralPath $skillsDir)) { continue }

  Get-ChildItem -LiteralPath $skillsDir -Directory | ForEach-Object {
    Set-DirJunction -Source $_.FullName -Target (Join-Path $CopilotChatSkillsDir $_.Name) -Label 'Copilot Chat skill'
  }
}

if (Test-Path -LiteralPath $AgentsDir) {
  Get-ChildItem -LiteralPath $AgentsDir -Filter '*.md' -File | ForEach-Object {
    $name = $_.BaseName
    Copy-AgentFile -Source $_.FullName -Target (Join-Path $VscodeUserPromptsDir "$name.agent.md") -Label 'VS Code agent'
    Copy-AgentFile -Source $_.FullName -Target (Join-Path $VscodeUserAgentsDir "$name.agent.md") -Label 'VS Code agent'
  }
}

Write-Host "Configured VS Code Copilot Chat skill links: $CopilotChatSkillsDir"
Write-Host "Configured VS Code prompts: $VscodeUserPromptsDir"
Write-Host "Configured VS Code agents: $VscodeUserAgentsDir"
