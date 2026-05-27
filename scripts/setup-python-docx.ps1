#Requires -Version 7

# Windows counterpart of setup-python-docx.sh.
# Ensures the `python-docx` library is available for the docx-builder-gen skill.
# The skill's extraction script (scripts/extract_docx.py) imports `docx`.
# Best-effort: a missing Python toolchain warns but never fails the overall
# install, since no other tool depends on it.

$ErrorActionPreference = 'Continue'

function Resolve-PythonCommand {
  if ($env:PYTHON_BIN -and (Get-Command $env:PYTHON_BIN -ErrorAction SilentlyContinue)) {
    return $env:PYTHON_BIN
  }
  foreach ($candidate in @('python', 'py')) {
    if (Get-Command $candidate -ErrorAction SilentlyContinue) {
      return $candidate
    }
  }
  return $null
}

$py = Resolve-PythonCommand
if (-not $py) {
  Write-Warning "python not found; skipping python-docx (needed only by the docx-builder-gen skill)."
  exit 0
}

& $py -c "import docx" *> $null
if ($LASTEXITCODE -eq 0) {
  Write-Host "python-docx already available."
  exit 0
}

Write-Host "Installing python-docx (docx-builder-gen skill dependency)..."

# Try a plain user install first, then fall back to --break-system-packages
# for the rare externally-managed interpreter (PEP 668).
& $py -m pip install --user python-docx *> $null
if ($LASTEXITCODE -ne 0) {
  & $py -m pip install --user --break-system-packages python-docx *> $null
}

if ($LASTEXITCODE -ne 0) {
  Write-Warning "Could not install python-docx automatically."
  Write-Host "Install it manually for the docx-builder-gen skill, e.g.:"
  Write-Host "  $py -m pip install --user python-docx"
  exit 0
}

& $py -c "import docx" *> $null
if ($LASTEXITCODE -eq 0) {
  Write-Host "Verified: python-docx import works."
} else {
  Write-Warning "python-docx installed but not importable by $py; check your PATH/venv."
}

exit 0
