#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$SCRIPT_DIR"
CODEX_SKILLS_DIR="$HOME/.agents/skills"
CLAUDE_CACHE_DIR="$HOME/.claude/plugins/cache/claude-plugins-official/nimbou-skills/0.1.0"
CLAUDE_PLUGINS_FILE="$HOME/.claude/plugins/installed_plugins.json"
PLUGIN_KEY="nimbou-skills@claude-plugins-official"
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

install_claude_plugin() {
  local src="$1"
  local dest="$2"
  local plugins_file="$3"
  local plugin_key="$4"

  # Copy plugin components to Claude cache
  rm -rf "$dest"
  mkdir -p "$dest/.claude-plugin"
  cp "$src/.claude-plugin/plugin.json" "$dest/.claude-plugin/"
  cp -r "$src/commands" "$dest/commands"
  cp -r "$src/skills" "$dest/skills"

  # Register in installed_plugins.json
  mkdir -p "$(dirname "$plugins_file")"
  if [ ! -f "$plugins_file" ]; then
    echo '{"version":2,"plugins":{}}' > "$plugins_file"
  fi

  local now
  now="$(date -u +%Y-%m-%dT%H:%M:%S.000Z)"

  local entry
  entry=$(cat <<EOF
[{"scope":"user","installPath":"$dest","version":"0.1.0","installedAt":"$now","lastUpdated":"$now"}]
EOF
  )

  jq --arg key "$plugin_key" --argjson entry "$entry" \
    '.plugins[$key] = $entry' "$plugins_file" > "${plugins_file}.tmp" \
    && mv "${plugins_file}.tmp" "$plugins_file"

  echo "Installed Claude plugin: $plugin_key -> $dest"
}

require_cmd node
require_cmd jq

NODE_MAJOR="$(node -p "process.versions.node.split('.')[0]")"
if [ "$NODE_MAJOR" -lt "$NODE_MIN_MAJOR" ]; then
  echo "Node >= $NODE_MIN_MAJOR is required. Found $(node -v)." >&2
  exit 1
fi

echo "Installing local dependencies in $REPO_ROOT..."
pnpm install --dir "$REPO_ROOT"

link_path "$REPO_ROOT/skills" "$CODEX_SKILLS_DIR/nimbou-skills"

install_claude_plugin "$REPO_ROOT" "$CLAUDE_CACHE_DIR" "$CLAUDE_PLUGINS_FILE" "$PLUGIN_KEY"

echo "Linking nb-catalog globally..."
sudo npm link

if ! command -v nb-catalog >/dev/null 2>&1; then
  echo "nb-catalog was not found in PATH after linking. Check your global bin configuration." >&2
  exit 1
fi

echo ""
echo "Installation complete."
echo "  Codex skills:  $CODEX_SKILLS_DIR/nimbou-skills"
echo "  Claude plugin: $CLAUDE_CACHE_DIR"
echo "  CLI:           $(command -v nb-catalog)"
echo ""
echo "Restart Claude Code or run /reload-plugins to activate."
