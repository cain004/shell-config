#!/bin/sh
set -e

REPO="https://github.com/cain004/shell-config.git"
INSTALL_DIR="$HOME/.shell-config"

# ----------------------------------------------------------------------------
# Helpers
# ----------------------------------------------------------------------------
info() { printf "\033[1;34m==>\033[0m %s\n" "$1"; }
warn() { printf "\033[1;33m==>\033[0m %s\n" "$1"; }
error() { printf "\033[1;31m==>\033[0m %s\n" "$1"; exit 1; }

backup() {
  if [ -f "$1" ] && [ ! -L "$1" ]; then
    warn "Backing up $1 -> $1.bak"
    cp "$1" "$1.bak"
  fi
}

# Use sudo only if not root
if [ "$(id -u)" -eq 0 ]; then
  SUDO=""
else
  SUDO="sudo"
fi

# ----------------------------------------------------------------------------
# Detect OS
# ----------------------------------------------------------------------------
OS="$(uname -s)"
case "$OS" in
  Linux*)  OS="linux" ;;
  Darwin*) OS="mac" ;;
  *)       error "Unsupported OS: $OS" ;;
esac

info "Detected OS: $OS"

# ----------------------------------------------------------------------------
# Install apt packages (Linux only)
# ----------------------------------------------------------------------------
if [ "$OS" = "linux" ]; then
  NEEDS_UPDATE=0
  for cmd in git zsh; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
      if [ "$NEEDS_UPDATE" -eq 0 ]; then
        info "Updating package list..."
        $SUDO apt-get update -qq
        NEEDS_UPDATE=1
      fi
      info "Installing $cmd..."
      $SUDO apt-get install -y -qq "$cmd"
    fi
  done
else
  if ! command -v git >/dev/null 2>&1; then
    error "git not found. Install it with: brew install git"
  fi
fi

# ----------------------------------------------------------------------------
# Install starship
# ----------------------------------------------------------------------------
if ! command -v starship >/dev/null 2>&1; then
  info "Installing starship..."
  if [ "$OS" = "mac" ]; then
    if command -v brew >/dev/null 2>&1; then
      brew install starship
    else
      curl -sS https://starship.rs/install.sh | sh
    fi
  else
    curl -sS https://starship.rs/install.sh | sh -s -- -y
  fi
fi

# ----------------------------------------------------------------------------
# Clone or update repo
# ----------------------------------------------------------------------------
if [ -d "$INSTALL_DIR" ]; then
  info "Updating shell-config..."
  git -C "$INSTALL_DIR" pull --quiet
else
  info "Cloning shell-config..."
  git clone --quiet "$REPO" "$INSTALL_DIR"
fi

# ----------------------------------------------------------------------------
# Symlink dotfiles
# ----------------------------------------------------------------------------
info "Linking dotfiles..."

backup "$HOME/.aliases"
ln -sf "$INSTALL_DIR/.aliases" "$HOME/.aliases"
info "Linked .aliases"

CURRENT_SHELL="$(basename "$SHELL")"

if [ "$CURRENT_SHELL" = "zsh" ] || [ "$OS" = "mac" ]; then
  backup "$HOME/.zshrc"
  ln -sf "$INSTALL_DIR/.zshrc" "$HOME/.zshrc"
  info "Linked .zshrc"
fi

backup "$HOME/.bashrc"
ln -sf "$INSTALL_DIR/.bashrc" "$HOME/.bashrc"
info "Linked .bashrc"

# ----------------------------------------------------------------------------
# Set default shell to zsh (Linux only, if not already)
# ----------------------------------------------------------------------------
if [ "$OS" = "linux" ] && [ "$CURRENT_SHELL" != "zsh" ]; then
  info "Changing default shell to zsh..."
  chsh -s "$(which zsh)"
fi

# ----------------------------------------------------------------------------
# Done
# ----------------------------------------------------------------------------
printf "\n"
info "Done! Restart your shell or run: exec \$SHELL"
