#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

if [[ "$(uname)" == "Darwin" ]]; then
  OS_PKG=macos
elif grep -qi "ubuntu\|debian" /etc/os-release 2>/dev/null; then
  OS_PKG=ubuntu
elif grep -qi "fedora" /etc/os-release 2>/dev/null; then
  OS_PKG=fedora
else
  echo "Unsupported OS. Only macOS, Ubuntu and Fedora are supported."
  exit 1
fi

# Homebrew may not be on PATH yet right after installing it, so probe its default prefixes.
for b in /opt/homebrew/bin/brew /home/linuxbrew/.linuxbrew/bin/brew /usr/local/bin/brew; do
  [[ -x "$b" ]] && eval "$("$b" shellenv bash)" && break
done
if ! command -v brew &>/dev/null; then
  echo "Homebrew not found. Install it, then re-run ./install.sh:"
  if [[ "$OS_PKG" == ubuntu ]]; then
    echo "  sudo apt install build-essential procps curl file git"
  elif [[ "$OS_PKG" == fedora ]]; then
    echo "  sudo dnf group install development-tools"
    echo "  sudo dnf install procps-ng curl file"
  fi
  echo '  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
  echo "Skip the installer's \"Next steps\" about brew shellenv; common/.zshenv already handles it."
  exit 1
fi

# Homebrew refuses formulae from non-official taps until they are trusted.
# Trust only the formulae the Brewfile uses, not their whole taps.
brew trust --formula oven-sh/bun/bun

# Installs stow too, so this runs before stowing.
echo "Installing Homebrew packages from common/.Brewfile ..."
brew bundle --file="$DOTFILES_DIR/common/.Brewfile"

# Toolchains the Brewfile installs managers for but not the tools themselves.
# rustup is keg-only, so call it by its full path.
"$(brew --prefix rustup)/bin/rustup" default stable
# Puts python/python3 in ~/.local/bin, ahead of the system Python on PATH.
uv python install 3.14 --default

stow_pkg() {
  local pkg="$1"
  echo "Stowing $pkg ..."
  # --no-folding keeps target dirs real so apps writing into a config dir
  # (e.g. an app's local DB) don't land inside the repo via a folded symlink.
  stow --dir="$DOTFILES_DIR" --target="$HOME" --no-folding --restow "$pkg"
}

stow_pkg common

if [[ "$OS_PKG" == ubuntu ]]; then
  echo "Manual steps required:"
  echo "  sudo apt install zsh"
  echo "  chsh -s \"\$(command -v zsh)\"   # set login shell to zsh, then re-login"
elif [[ "$OS_PKG" == fedora ]]; then
  echo "Manual steps required:"
  echo "  sudo dnf install zsh util-linux-user   # util-linux-user provides chsh"
  echo "  chsh -s \"\$(command -v zsh)\"   # set login shell to zsh, then re-login"
fi

echo "Done."
