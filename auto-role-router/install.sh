#!/bin/bash
# Auto Role Router - Installation Script
# Installs hooks into ~/.claude/settings.json
#
# Usage:
#   ./install.sh              # Install
#   ./install.sh --dry-run    # Show what would change without writing
#   ./install.sh --legacy     # Install the smaller "legacy" hook payload
#   ./install.sh --uninstall  # Remove auto-role-router hooks

set -euo pipefail

MODE="install"
VARIANT="default"
for arg in "$@"; do
    case "$arg" in
        --dry-run)   MODE="dry-run" ;;
        --uninstall) MODE="uninstall" ;;
        --legacy)    VARIANT="legacy" ;;
        -h|--help)
            cat <<HELP
Auto Role Router installer

Options:
  --dry-run     Preview changes, do not modify settings.json
  --legacy      Use the smaller basic hook payload instead of the pre-activation default
  --uninstall   Remove auto-role-router hooks and keep other hooks intact
  -h, --help    Show this help

Reads from a hook config in the same directory as this script:
  hooks-config.json         (default, pre-activation mode)
  hooks-config-legacy.json  (used with --legacy)
HELP
            exit 0 ;;
        *)
            echo "Unknown argument: $arg (try --help)" >&2
            exit 2 ;;
    esac
done

echo "Auto Role Router installer"
echo "  mode:    $MODE"
echo "  variant: $VARIANT"
echo

if ! command -v jq &> /dev/null; then
    echo "Error: jq is required. Install with:" >&2
    echo "  macOS:  brew install jq" >&2
    echo "  Linux:  apt-get install jq   (or your distro equivalent)" >&2
    exit 1
fi

SETTINGS_FILE="$HOME/.claude/settings.json"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ "$VARIANT" = "legacy" ]; then
    HOOKS_FILE="$SCRIPT_DIR/hooks-config-legacy.json"
else
    HOOKS_FILE="$SCRIPT_DIR/hooks-config.json"
fi

# When run via `curl | bash`, the script isn't on disk — fetch the config over HTTP
if [ ! -f "$HOOKS_FILE" ]; then
    if [ "$VARIANT" = "legacy" ]; then
        REMOTE_URL="https://raw.githubusercontent.com/AlexPlum405/skills/main/auto-role-router/hooks-config-legacy.json"
    else
        REMOTE_URL="https://raw.githubusercontent.com/AlexPlum405/skills/main/auto-role-router/hooks-config.json"
    fi
    HOOKS_FILE="$(mktemp -t auto-role-router.XXXXXX.json)"
    trap 'rm -f "$HOOKS_FILE"' EXIT
    echo "Fetching hook config from $REMOTE_URL"
    if command -v curl &> /dev/null; then
        curl -sSfL "$REMOTE_URL" -o "$HOOKS_FILE"
    else
        wget -q "$REMOTE_URL" -O "$HOOKS_FILE"
    fi
fi

# Ensure settings.json exists
if [ ! -f "$SETTINGS_FILE" ]; then
    echo "No $SETTINGS_FILE — creating a minimal one."
    [ "$MODE" = "dry-run" ] || { mkdir -p "$(dirname "$SETTINGS_FILE")"; echo '{}' > "$SETTINGS_FILE"; }
fi

EXISTING_JSON="$([ -f "$SETTINGS_FILE" ] && cat "$SETTINGS_FILE" || echo '{}')"

case "$MODE" in
install|dry-run)
    # jq's `*` operator deep-merges objects but *replaces* arrays — which
    # would blow away any other hook the user has under the same event.
    # We need: per-event, concatenate the two hook group arrays instead.
    NEW_JSON="$(echo "$EXISTING_JSON" | jq --slurpfile new "$HOOKS_FILE" '
      . as $orig
      | ($new[0].hooks // {}) as $newHooks
      | .hooks = (
          ($orig.hooks // {}) as $oldHooks
          | ($oldHooks * $newHooks)
          | to_entries
          | map(
              .key as $event
              | .value = (
                  (($oldHooks[$event] // []) + ($newHooks[$event] // []))
                )
            )
          | from_entries
        )
    ')"
    ;;
uninstall)
    # Drop our hooks — recognised by the literal [auto-role-router] marker
    # we embed in every payload. Using a narrow marker avoids clobbering any
    # unrelated hook whose description happens to mention this skill.
    NEW_JSON="$(echo "$EXISTING_JSON" | jq '
      if has("hooks") then
        .hooks |= (
          with_entries(
            .value |= (
              map(.hooks |= map(select(
                (.command // "") | contains("[auto-role-router]") | not
              )))
              | map(select(.hooks | length > 0))
            )
          )
          | with_entries(select(.value | length > 0))
        )
        | if .hooks == {} then del(.hooks) else . end
      else . end
    ')"
    ;;
esac

if [ "$MODE" = "dry-run" ]; then
    echo "--- Proposed settings.json (diff) ---"
    diff <(echo "$EXISTING_JSON" | jq -S .) <(echo "$NEW_JSON" | jq -S .) || true
    echo "--- End of diff. No changes written. ---"
    exit 0
fi

# Real write — back up first
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
BACKUP_FILE="${SETTINGS_FILE}.backup.${TIMESTAMP}"
cp "$SETTINGS_FILE" "$BACKUP_FILE"
echo "$NEW_JSON" > "$SETTINGS_FILE"

case "$MODE" in
install)
    echo
    echo "Installed. Restart Claude Code for hooks to take effect."
    echo
    echo "To roll back:"
    echo "  cp \"$BACKUP_FILE\" \"$SETTINGS_FILE\""
    echo
    echo "To uninstall cleanly later:"
    echo "  $SCRIPT_DIR/install.sh --uninstall"
    ;;
uninstall)
    echo
    echo "Removed auto-role-router hooks from settings.json."
    echo "Backup saved at: $BACKUP_FILE"
    ;;
esac
