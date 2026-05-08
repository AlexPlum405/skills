#!/bin/bash
# Auto Role Router - Installation Script
# Installs hooks to ~/.claude/settings.json

set -e

echo "🚀 Installing Auto Role Router..."

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "❌ Error: jq is not installed. Please install it first:"
    echo "   macOS: brew install jq"
    echo "   Linux: sudo apt-get install jq"
    exit 1
fi

# Backup existing settings
SETTINGS_FILE="$HOME/.claude/settings.json"
BACKUP_FILE="$HOME/.claude/settings.json.backup.$(date +%Y%m%d_%H%M%S)"

if [ -f "$SETTINGS_FILE" ]; then
    echo "📦 Backing up existing settings to $BACKUP_FILE"
    cp "$SETTINGS_FILE" "$BACKUP_FILE"
else
    echo "⚠️  No existing settings.json found. Creating new one."
    mkdir -p "$HOME/.claude"
    echo '{}' > "$SETTINGS_FILE"
fi

# Download hooks configuration
HOOKS_URL="https://raw.githubusercontent.com/AlexPlum405/skills/main/auto-role-router/hooks-config.json"
TEMP_HOOKS="/tmp/auto-role-router-hooks.json"

echo "📥 Downloading hooks configuration..."
if command -v curl &> /dev/null; then
    curl -sL "$HOOKS_URL" -o "$TEMP_HOOKS"
elif command -v wget &> /dev/null; then
    wget -q "$HOOKS_URL" -O "$TEMP_HOOKS"
else
    echo "❌ Error: Neither curl nor wget is installed."
    exit 1
fi

# Merge hooks into settings.json
echo "🔧 Merging hooks into settings.json..."
jq -s '.[0] * .[1]' "$SETTINGS_FILE" "$TEMP_HOOKS" > "$SETTINGS_FILE.tmp"
mv "$SETTINGS_FILE.tmp" "$SETTINGS_FILE"

# Cleanup
rm "$TEMP_HOOKS"

echo "✅ Installation complete!"
echo ""
echo "📝 Next steps:"
echo "   1. Restart Claude Code (or your AI assistant)"
echo "   2. Start a new conversation"
echo "   3. Ask any technical question and see the role declaration"
echo ""
echo "💡 To uninstall, restore from backup:"
echo "   cp $BACKUP_FILE $SETTINGS_FILE"
