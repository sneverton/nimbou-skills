#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$SCRIPT_DIR"
CODEX_SKILLS_DIR="$HOME/.agents/skills"
CLAUDE_SKILLS_DIR="$HOME/.claude/skills"
CLAUDE_COMMANDS_DIR="$HOME/.claude/commands"
NODE_MIN_MAJOR=20

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1" >&2
    exit 1
  fi
}

link_path() {
  local source_path="$1"
  local target_path="$2"

  mkdir -p "$(dirname "$target_path")"
  rm -rf "$target_path"
  ln -s "$source_path" "$target_path"
  echo "Linked $target_path -> $source_path"
}

require_cmd node
require_cmd pnpm

NODE_MAJOR="$(node -p "process.versions.node.split('.')[0]")"
if [ "$NODE_MAJOR" -lt "$NODE_MIN_MAJOR" ]; then
  echo "Node >= $NODE_MIN_MAJOR is required. Found $(node -v)." >&2
  exit 1
fi

echo "Installing local dependencies in $REPO_ROOT..."
pnpm install --dir "$REPO_ROOT"

link_path "$REPO_ROOT/skills" "$CODEX_SKILLS_DIR/nimbou-skills"
link_path "$REPO_ROOT/skills" "$CLAUDE_SKILLS_DIR/nimbou-skills"
link_path "$REPO_ROOT/commands" "$CLAUDE_COMMANDS_DIR/nimbou-skills"

echo "Linking nb-catalog globally..."
pnpm link --global --dir "$REPO_ROOT"

if ! command -v nb-catalog >/dev/null 2>&1; then
  echo "nb-catalog was not found in PATH after linking. Check your pnpm global bin configuration." >&2
  exit 1
fi

echo "Installation complete."
echo "Codex skills:   $CODEX_SKILLS_DIR/nimbou-skills"
echo "Claude skills:  $CLAUDE_SKILLS_DIR/nimbou-skills"
echo "Claude commands:$CLAUDE_COMMANDS_DIR/nimbou-skills"
echo "CLI:            $(command -v nb-catalog)"
