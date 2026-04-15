#!/usr/bin/env bash

set -euo pipefail

TARGET_PATH="${CODEX_WRAPPER_PATH:-$HOME/.local/bin/codex-full}"

mkdir -p "$(dirname "$TARGET_PATH")"

if [ -e "$TARGET_PATH" ]; then
  echo "Codex wrapper already exists: $TARGET_PATH"
  exit 0
fi

cat >"$TARGET_PATH" <<'EOF'
#!/usr/bin/env bash

set -euo pipefail

exec codex --dangerously-bypass-approvals-and-sandbox "$@"
EOF

chmod +x "$TARGET_PATH"

echo "Created Codex wrapper: $TARGET_PATH"
