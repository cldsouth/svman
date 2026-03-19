#!/usr/bin/env bash
# install.sh — svman installer

set -e

BIN_DIR="$HOME/.local/bin"
SVMAN_URL="https://raw.githubusercontent.com/cldsouth/svman/main/svman"

R='\033[0;31m'
G='\033[0;32m'
Y='\033[0;33m'
D='\033[2m'
N='\033[0m'

_ok()   { printf "  ${G}[+]${N} %s\n" "$*"; }
_err()  { printf "  ${R}[!]${N} %s\n" "$*" >&2; exit 1; }
_info() { printf "  ${D}[>]${N} %s\n" "$*"; }
_warn() { printf "  ${Y}[!]${N} %s\n" "$*"; }

# ── detect shell rc ────────────────────────────────────────────────────────────

if [[ -n "$ZSH_VERSION" ]]; then
    SHELL_RC="$HOME/.zshrc"
elif [[ -n "$BASH_VERSION" ]]; then
    SHELL_RC="$HOME/.bashrc"
else
    SHELL_RC="$HOME/.profile"
fi

# ── check dependencies ─────────────────────────────────────────────────────────

_info "checking dependencies..."

for dep in curl git; do
    if ! command -v "$dep" &>/dev/null; then
        _err "'$dep' is required but not installed."
    fi
done

_ok "dependencies ok."

# ── install ────────────────────────────────────────────────────────────────────

mkdir -p "$BIN_DIR"

_info "downloading svman..."
curl -fsSL "$SVMAN_URL" -o "$BIN_DIR/svman"
chmod +x "$BIN_DIR/svman"
_ok "svman installed to $BIN_DIR/svman"

# ── path ───────────────────────────────────────────────────────────────────────

if ! grep -q "$BIN_DIR" "$SHELL_RC" 2>/dev/null; then
    echo "export PATH=\"$BIN_DIR:\$PATH\"" >> "$SHELL_RC"
    _ok "PATH updated in $SHELL_RC"
else
    _info "PATH already set in $SHELL_RC"
fi

export PATH="$BIN_DIR:$PATH"

# ── done ───────────────────────────────────────────────────────────────────────

echo ""
_ok "svman $(svman --version) installed successfully."
_info "restart your shell or run: source $SHELL_RC"
