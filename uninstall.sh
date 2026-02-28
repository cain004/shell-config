#!/bin/sh
set -e

INSTALL_DIR="$HOME/.shell-config"

# ----------------------------------------------------------------------------
# Helpers
# ----------------------------------------------------------------------------
info() { printf "\033[1;34m==>\033[0m %s\n" "$1"; }
warn() { printf "\033[1;33m==>\033[0m %s\n" "$1"; }
error() { printf "\033[1;31m==>\033[0m %s\n" "$1"; exit 1; }

printf "\n"
printf "\033[1;36m  shell-config uninstaller\033[0m\n"
printf "\n"

# ----------------------------------------------------------------------------
# Remove symlinks and restore backups
# ----------------------------------------------------------------------------
remove_link() {
  target="$1"
  if [ -L "$target" ]; then
    link_dest="$(readlink "$target")"
    case "$link_dest" in
      "$INSTALL_DIR"/*)
        rm "$target"
        info "Removed $target"
        if [ -f "$target.bak" ]; then
          mv "$target.bak" "$target"
          info "Restored $target from backup"
        fi
        ;;
      *)
        warn "Skipping $target (symlink does not point to $INSTALL_DIR)"
        ;;
    esac
  else
    warn "Skipping $target (not a symlink)"
  fi
}

remove_link "$HOME/.aliases"
remove_link "$HOME/.zshrc"
remove_link "$HOME/.bashrc"
remove_link "$HOME/.tmux.conf"
remove_link "$HOME/.gitconfig"
remove_link "$HOME/.config/starship.toml"

# ----------------------------------------------------------------------------
# Optionally remove the repo
# ----------------------------------------------------------------------------
if [ -d "$INSTALL_DIR" ]; then
  printf "\n"
  printf "Remove %s? [y/N] " "$INSTALL_DIR"
  read -r answer
  case "$answer" in
    [yY]*)
      rm -rf "$INSTALL_DIR"
      info "Removed $INSTALL_DIR"
      ;;
    *)
      info "Kept $INSTALL_DIR"
      ;;
  esac
fi

# ----------------------------------------------------------------------------
# Done
# ----------------------------------------------------------------------------
printf "\n"
info "Done! Restart your shell or run: exec \$SHELL"
