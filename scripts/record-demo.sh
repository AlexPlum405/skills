#!/bin/bash
# Record a demo GIF of auto-role-router in action.
#
# Requirements:
#   - vhs (https://github.com/charmbracelet/vhs)  — brew install vhs
#   - auto-role-router already installed          — ./install.sh
#
# Output:
#   demo.gif in the repo root
#
# Tweak demo.tape below to change the script.

set -euo pipefail

if ! command -v vhs >/dev/null 2>&1; then
    echo "Error: vhs is not installed."
    echo "  macOS: brew install vhs"
    echo "  Linux: see https://github.com/charmbracelet/vhs#installation"
    exit 1
fi

cd "$(dirname "${BASH_SOURCE[0]}")/.."

cat > demo.tape <<'TAPE'
Output demo.gif

Set FontSize 16
Set Width 1100
Set Height 650
Set Theme "Dracula"
Set TypingSpeed 40ms

Type "claude"
Enter
Sleep 1.5s

# Question 1 — Rust lifetime
Type "how do I fix this Rust lifetime error in my async function?"
Sleep 500ms
Enter
Sleep 3s

# Scroll so the role declaration is visible
Sleep 2s

# Question 2 — domain switch
Type "now how do I cache the result in Redis?"
Sleep 500ms
Enter
Sleep 3s

Sleep 2s
TAPE

echo "Running vhs demo.tape … this takes ~30 seconds."
vhs demo.tape
echo
echo "Output: $(pwd)/demo.gif"
