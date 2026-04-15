#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$SCRIPT_DIR"
MARKETPLACE_REPO="sneverton/nimbou-skills"
PLUGIN_NAME="nimbou-skills"
CODEX_SKILLS_DIR="$HOME/.agents/skills"
CODEX_SKILL_ROOT="$CODEX_SKILLS_DIR/$PLUGIN_NAME"
CODEX_WRAPPER_SCRIPT="$REPO_ROOT/scripts/setup-codex-full-wrapper.sh"
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

link_skill_tree() {
  local source_root="$1"

  if [ ! -d "$source_root" ]; then
    return 0
  fi

  find "$source_root" -mindepth 1 -maxdepth 1 -type d | sort | while IFS= read -r skill_dir; do
    local skill_name
    skill_name="$(basename "$skill_dir")"
    link_path "$skill_dir" "$CODEX_SKILL_ROOT/$skill_name"
  done
}

require_cmd node
require_cmd claude

NODE_MAJOR="$(node -p "process.versions.node.split('.')[0]")"
if [ "$NODE_MAJOR" -lt "$NODE_MIN_MAJOR" ]; then
  echo "Node >= $NODE_MIN_MAJOR is required. Found $(node -v)." >&2
  exit 1
fi

echo "Installing local dependencies in $REPO_ROOT..."
pnpm install --dir "$REPO_ROOT"

# Codex support
rm -rf "$CODEX_SKILL_ROOT"
mkdir -p "$CODEX_SKILL_ROOT"
link_skill_tree "$REPO_ROOT/plugins/$PLUGIN_NAME/skills"
link_skill_tree "$REPO_ROOT/.codex/skills"

# Claude Code plugin via marketplace
echo "Registering Claude Code marketplace..."
claude plugin marketplace add "$MARKETPLACE_REPO" 2>/dev/null \
  && echo "Marketplace added: $MARKETPLACE_REPO" \
  || echo "Marketplace already registered or updated."

echo "Installing Claude Code plugin..."
claude plugin install "$PLUGIN_NAME" --scope user 2>/dev/null \
  && echo "Plugin installed: $PLUGIN_NAME" \
  || echo "Plugin already installed."

# nb-catalog CLI
echo "Linking nb-catalog globally..."
sudo npm link

if ! command -v nb-catalog >/dev/null 2>&1; then
  echo "nb-catalog was not found in PATH after linking." >&2
  exit 1
fi

echo "Ensuring Codex wrapper exists..."
bash "$CODEX_WRAPPER_SCRIPT"

echo ""
echo "Installation complete."
echo "  Codex skills:  $CODEX_SKILL_ROOT"
echo "  Claude plugin: $PLUGIN_NAME@$MARKETPLACE_REPO"
echo "  CLI:           $(command -v nb-catalog)"
echo "  Wrapper:       ${CODEX_WRAPPER_PATH:-$HOME/.local/bin/codex-full}"
echo ""
echo "Restart Claude Code or run /reload-plugins to activate."
