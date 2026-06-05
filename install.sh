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

# Add to PATH in shell profile if not already present
if ! echo "$PATH" | tr ':' '\n' | grep -qxF "$INSTALL_DIR"; then
    PROFILE="$(detect_profile)"
    EXPORT_LINE="export PATH=\"$INSTALL_DIR:\$PATH\""

    # Don't add the line twice if the profile already contains it
    if ! grep -qxF "$EXPORT_LINE" "$PROFILE" 2>/dev/null; then
        printf '\n# added by quick-ssh installer\n%s\n' "$EXPORT_LINE" >> "$PROFILE"
        echo "Added $INSTALL_DIR to PATH in $PROFILE"
    fi

    # Make it available in the current session too
    export PATH="$INSTALL_DIR:$PATH"
    echo "PATH updated for this session."
    echo "Open a new terminal (or run: source $PROFILE) to make it permanent."
fi

echo ""
echo "Done. Run: quick-ssh"
