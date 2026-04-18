#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SHARED_SKILLS_DIR="$REPO_ROOT/plugins/nimbou-skills/skills"
CODEX_COMMAND_SKILLS_DIR="$REPO_ROOT/.codex/skills"
AGENTS_DIR="$REPO_ROOT/plugins/nimbou-skills/agents"
COPILOT_CHAT_SKILLS_DIR="${COPILOT_CHAT_SKILLS_DIR:-$HOME/.copilot/skills}"
VSCODE_USER_PROMPTS_DIR="${VSCODE_USER_PROMPTS_DIR:-$HOME/.config/Code/User/prompts}"
VSCODE_USER_AGENTS_DIR="${VSCODE_USER_AGENTS_DIR:-$VSCODE_USER_PROMPTS_DIR/agents}"

link_path() {
  local source="$1"
  local target="$2"
  local label="$3"

  mkdir -p "$(dirname "$target")"

  if [ -L "$target" ]; then
    ln -sfn "$source" "$target"
    echo "$label already linked: $target"
    return 0
  fi

  if [ -e "$target" ]; then
    echo "Skipping existing $label: $target" >&2
    return 0
  fi

  ln -s "$source" "$target"
  echo "Linked $label: $target"
}

mkdir -p "$COPILOT_CHAT_SKILLS_DIR" "$VSCODE_USER_PROMPTS_DIR" "$VSCODE_USER_AGENTS_DIR"

for skills_dir in "$SHARED_SKILLS_DIR" "$CODEX_COMMAND_SKILLS_DIR"; do
  [ -d "$skills_dir" ] || continue

  for source in "$skills_dir"/*; do
    [ -d "$source" ] || continue
    link_path "$source" "$COPILOT_CHAT_SKILLS_DIR/$(basename "$source")" "Copilot Chat skill"
  done
done

if [ -d "$AGENTS_DIR" ]; then
  for source in "$AGENTS_DIR"/*.md; do
    [ -f "$source" ] || continue

    name="$(basename "$source" .md)"
    link_path "$source" "$VSCODE_USER_PROMPTS_DIR/$name.agent.md" "VS Code agent"
    link_path "$source" "$VSCODE_USER_AGENTS_DIR/$name.agent.md" "VS Code agent"
  done
fi

echo "Configured VS Code Copilot Chat skill links: $COPILOT_CHAT_SKILLS_DIR"
echo "Configured VS Code prompts: $VSCODE_USER_PROMPTS_DIR"
echo "Configured VS Code agents: $VSCODE_USER_AGENTS_DIR"
