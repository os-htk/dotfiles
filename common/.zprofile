# Login shells only, sourced after .zshenv. On macOS, /etc/zprofile runs
# path_helper in between and moves system dirs ahead of the ones .zshenv added,
# so put them back in front. `typeset -U path` in .zshenv keeps the first copy.
path=("$HOME/.local/bin" ${HOMEBREW_PREFIX:+$HOMEBREW_PREFIX/bin} ${HOMEBREW_PREFIX:+$HOMEBREW_PREFIX/sbin} $path)
