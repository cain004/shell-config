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
# Install zsh (Linux only)
# ----------------------------------------------------------------------------
if ! command -v zsh >/dev/null 2>&1; then
  if [ "$OS" = "linux" ]; then
    info "Installing zsh..."
    sudo apt-get update -qq && sudo apt-get install -y -qq zsh
  else
    error "zsh not found. Install it with: brew install zsh"
  fi
fi

# ----------------------------------------------------------------------------
# Install git if missing
# ----------------------------------------------------------------------------
if ! command -v git >/dev/null 2>&1; then
  if [ "$OS" = "linux" ]; then
    info "Installing git..."
    sudo apt-get update -qq && sudo apt-get install -y -qq git
  else
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
