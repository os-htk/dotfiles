# dotfiles

Home directory configuration managed with GNU Stow symlinks.

## Layout

```
common/                        # Shared by macOS, Ubuntu and Fedora
  .Brewfile                    # Homebrew packages; macOS-only entries under `if OS.mac?`
  .claude/
    CLAUDE.md
    settings.json
  .config/
    gh/config.yml              # GitHub CLI
  .gitconfig
  .gitignore_global
  .zprofile                    # restores PATH order after macOS path_helper
  .zshenv                      # PATH / env for all shells
  .zshrc                       # interactive shell config
```

## Setup

```bash
git clone https://github.com/os-htk/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

`install.sh` supports macOS, Ubuntu and Fedora. [Homebrew](https://brew.sh) must be installed first. The script then:

1. Installs everything in `common/.Brewfile` with `brew bundle`, including `stow`.
2. Stows `common/` into `$HOME`.
3. On Ubuntu and Fedora, prints the remaining manual steps: installing zsh with apt or dnf, and `chsh`.

GUI apps are Homebrew casks on macOS only; on Linux, install them from their official distribution. VS Code extensions are left to VS Code Settings Sync.

## Machine-specific files

These live only on each machine and are not tracked here.

- `~/.claude/machine.md` holds notes about this machine's hardware, packages and quirks. `common/.claude/CLAUDE.md` imports it with `@~/.claude/machine.md`. On a new machine, create it by hand with these headings:

  ```markdown
  # Machine Context

  ## Environment

  ## Package Management

  ## Installed Tools

  ## Notes
  ```

- `~/.zshenv.local` and `~/.zshrc.local` hold machine-specific environment and shell config. `.zshenv` and `.zshrc` source them when they exist.

## Adding a new file

1. Place it under `dotfiles/common/` preserving its path relative to `$HOME`.
2. `stow --dir=~/dotfiles --target=$HOME --no-folding --restow common`
3. Commit and push.
