#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$SCRIPT_DIR"
MARKETPLACE_REPO="sneverton/nimbou-skills"
PLUGIN_NAME="nimbou-skills"
CODEX_WRAPPER_SCRIPT="$REPO_ROOT/scripts/setup-codex-full-wrapper.sh"
CHROME_DEVTOOLS_WRAPPER_SCRIPT="$REPO_ROOT/scripts/setup-chrome-devtools-wrapper.sh"
PLUGIN_MANIFEST="$REPO_ROOT/plugins/$PLUGIN_NAME/.claude-plugin/plugin.json"
CODEX_MARKETPLACE_FILE="$REPO_ROOT/.agents/plugins/marketplace.json"
PLUGIN_ID="$PLUGIN_NAME@$PLUGIN_NAME"
NODE_MIN_MAJOR=20

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1" >&2
    exit 1
  fi
}

read_plugin_version() {
  node --input-type=module -e '
    import { readFileSync } from "node:fs";

    const manifestPath = process.argv[1];
    const manifest = JSON.parse(readFileSync(manifestPath, "utf8"));
    process.stdout.write(`${manifest.version}\n`);
  ' "$PLUGIN_MANIFEST"
}

get_installed_plugin_version() {
  claude plugin list --json | node --input-type=module -e '
    import fs from "node:fs";

    const [pluginId, scope] = process.argv.slice(1);
    const plugins = JSON.parse(fs.readFileSync(0, "utf8"));
    const match = plugins.find((plugin) => plugin.id === pluginId && plugin.scope === scope)
      ?? plugins.find((plugin) => plugin.id === pluginId);

    if (match?.version) {
      process.stdout.write(`${match.version}\n`);
    }
  ' "$PLUGIN_ID" "user"
}

require_codex_marketplace_support() {
  if ! command -v codex >/dev/null 2>&1; then
    echo "Codex CLI not found. Install Codex rust-v0.121.0+ or newer, then rerun install.sh." >&2
    exit 1
  fi

  if ! codex help 2>/dev/null | grep -q 'marketplace'; then
    echo "Codex marketplace support is required. Install Codex rust-v0.121.0+ or newer, then rerun install.sh." >&2
    exit 1
  fi
}

require_cmd node
require_cmd claude

NODE_MAJOR="$(node -p "process.versions.node.split('.')[0]")"
if [ "$NODE_MAJOR" -lt "$NODE_MIN_MAJOR" ]; then
  echo "Node >= $NODE_MIN_MAJOR is required. Found $(node -v)." >&2
  exit 1
fi

require_codex_marketplace_support

echo "Installing local dependencies in $REPO_ROOT..."
pnpm install --dir "$REPO_ROOT"

EXPECTED_PLUGIN_VERSION="$(read_plugin_version)"
INSTALLED_PLUGIN_VERSION="$(get_installed_plugin_version)"

codex marketplace add "$CODEX_MARKETPLACE_FILE" \
  && echo "Codex marketplace added: $CODEX_MARKETPLACE_FILE" \
  || {
    echo "Failed to register the Codex marketplace. Install Codex rust-v0.121.0+ or newer and rerun install.sh." >&2
    exit 1
  }

# Claude Code plugin via marketplace
echo "Registering Claude Code marketplace..."
claude plugin marketplace add "$MARKETPLACE_REPO" 2>/dev/null \
  && echo "Marketplace added: $MARKETPLACE_REPO" \
  || echo "Marketplace already registered or updated."

if [ "$INSTALLED_PLUGIN_VERSION" = "$EXPECTED_PLUGIN_VERSION" ]; then
  echo "Claude Code plugin already installed at version $INSTALLED_PLUGIN_VERSION; skipping reinstall."
else
  echo "Installing Claude Code plugin version $EXPECTED_PLUGIN_VERSION..."
  claude plugin install "$PLUGIN_NAME" --scope user 2>/dev/null \
    && echo "Plugin installed: $PLUGIN_NAME@$EXPECTED_PLUGIN_VERSION" \
    || echo "Plugin already installed or updated."
fi

# nb-catalog CLI
echo "Linking nb-catalog globally..."
sudo npm link

if ! command -v nb-catalog >/dev/null 2>&1; then
  echo "nb-catalog was not found in PATH after linking." >&2
  exit 1
fi

echo "Ensuring Codex wrapper exists..."
bash "$CODEX_WRAPPER_SCRIPT"

echo "Ensuring Chrome DevTools MCP wrapper exists..."
bash "$CHROME_DEVTOOLS_WRAPPER_SCRIPT"

echo ""
echo "Installation complete."
echo "  Codex marketplace: $CODEX_MARKETPLACE_FILE"
echo "  Claude plugin: $PLUGIN_NAME@$MARKETPLACE_REPO"
echo "  CLI:           $(command -v nb-catalog)"
echo "  Wrapper:       ${CODEX_WRAPPER_PATH:-$HOME/.local/bin/codex-full}"
echo "  DevTools MCP:  ${CHROME_DEVTOOLS_MCP_WRAPPER_PATH:-$HOME/.local/bin/chrome-devtools-mcp-wayland}"
echo ""
echo "Restart Claude Code and Codex to activate."
