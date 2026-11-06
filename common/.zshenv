# .zshenv is sourced for every zsh (login, interactive, and scripts), so keep it
# to environment that all contexts need — interactive-only config lives in .zshrc.

# Keep PATH/path entries unique even when shells nest and re-source this file.
typeset -U path PATH

# Homebrew (macOS ARM, Linux, macOS Intel). Set up before ~/.local/bin so that
# personal binaries still take precedence.
for _brew in /opt/homebrew/bin/brew /home/linuxbrew/.linuxbrew/bin/brew /usr/local/bin/brew; do
  [[ -x $_brew ]] && eval "$($_brew shellenv zsh)" && break
done
unset _brew

# Rust: rustup is keg-only in Homebrew, so its rustc/cargo proxies need adding
# by hand. ~/.cargo/bin holds binaries from `cargo install`.
path=("$HOME/.cargo/bin" ${HOMEBREW_PREFIX:+$HOMEBREW_PREFIX/opt/rustup/bin} $path)

# Binaries from `bun add -g`.
path=("$HOME/.bun/bin" $path)

# Personal binaries (pip --user, pipx, cargo shims, ad-hoc scripts).
path=("$HOME/.local/bin" $path)

# Machine-specific environment (secrets, extra PATH); not tracked in the repo.
[[ -f ~/.zshenv.local ]] && source ~/.zshenv.local
