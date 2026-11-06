# Shared by macOS, Ubuntu and Fedora. install.sh applies it; stowed to ~/.Brewfile so
# `brew bundle --global` works afterwards too.
# VS Code extensions are managed by VS Code Settings Sync, not here.

tap "oven-sh/bun"

# CLI
brew "oven-sh/bun/bun"
brew "fastfetch"
brew "ffmpeg"
brew "fzf"
brew "gh"
brew "ripgrep"
brew "rustup"
brew "stow"
brew "uv"
brew "zsh-autosuggestions"
brew "zsh-syntax-highlighting"

# Claude Code: upgraded by itself via CLAUDE_CODE_PACKAGE_MANAGER_AUTO_UPDATE
# (set in common/.claude/settings.json)
cask "claude-code@latest"

# uv tools
uv "ruff"

if OS.mac?
  # gdircolors for .zshrc completion colors. Not on Linux, where Homebrew's
  # coreutils installs unprefixed and shadows the system's GNU coreutils.
  brew "coreutils"

  # Antigravity CLI (agy): updates itself. Casks are macOS-only, so Linux uses
  # the official install script instead.
  cask "antigravity-cli"

  # GUI apps (update themselves; brew only installs them on a new machine).
  # On Linux, GUI apps come from their official distribution instead.
  cask "google-chrome"
  cask "obsidian"
  cask "visual-studio-code"
end
