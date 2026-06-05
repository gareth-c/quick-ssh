#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_NAME="quick-ssh"
INSTALL_DIRS=("$HOME/.local/bin" "/usr/local/bin")

# Pick install location — prefer ~/.local/bin (no sudo needed)
pick_dir() {
    for dir in "${INSTALL_DIRS[@]}"; do
        if [[ -d "$dir" && -w "$dir" ]]; then
            echo "$dir"
            return
        fi
    done
    # ~/.local/bin doesn't exist yet — create it
    mkdir -p "$HOME/.local/bin"
    echo "$HOME/.local/bin"
}

INSTALL_DIR="$(pick_dir)"
DEST="$INSTALL_DIR/$INSTALL_NAME"
SRC="$SCRIPT_DIR/quick-ssh"

# Validate source exists
if [[ ! -f "$SRC" ]]; then
    echo "error: $SRC not found" >&2
    exit 1
fi

# Copy and set permissions
cp "$SRC" "$DEST"
chmod 755 "$DEST"

echo "Installed: $DEST"

# Warn if the install dir isn't on PATH
if ! echo "$PATH" | tr ':' '\n' | grep -qxF "$INSTALL_DIR"; then
    echo ""
    echo "Note: $INSTALL_DIR is not on your PATH."
    echo "Add this to your shell profile (~/.zshrc or ~/.bashrc):"
    echo ""
    echo "  export PATH=\"$INSTALL_DIR:\$PATH\""
fi
