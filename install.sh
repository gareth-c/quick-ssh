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
    mkdir -p "$HOME/.local/bin"
    echo "$HOME/.local/bin"
}

# Detect the user's shell profile file
detect_profile() {
    local shell
    shell="$(basename "${SHELL:-}")"
    case "$shell" in
        zsh)  echo "$HOME/.zshrc" ;;
        bash) echo "$HOME/.bashrc" ;;
        *)    echo "$HOME/.profile" ;;
    esac
}

INSTALL_DIR="$(pick_dir)"
DEST="$INSTALL_DIR/$INSTALL_NAME"
SRC="$SCRIPT_DIR/quick-ssh"

if [[ ! -f "$SRC" ]]; then
    echo "error: $SRC not found" >&2
    exit 1
fi

cp "$SRC" "$DEST"
chmod 755 "$DEST"
echo "Installed: $DEST"

# Add to PATH in shell profile if the export line isn't already there
PROFILE="$(detect_profile)"
EXPORT_LINE="export PATH=\"$INSTALL_DIR:\$PATH\""

if ! grep -qF "$INSTALL_DIR" "$PROFILE" 2>/dev/null; then
    printf '\n# added by quick-ssh installer\n%s\n' "$EXPORT_LINE" >> "$PROFILE"
    echo "Added $INSTALL_DIR to PATH in $PROFILE"
    echo "Open a new terminal (or run: source $PROFILE) to apply."
else
    echo "$INSTALL_DIR already in $PROFILE — no changes needed."
fi

# Make it available in the current session too
export PATH="$INSTALL_DIR:$PATH"

echo ""
echo "Done. Run: quick-ssh"
