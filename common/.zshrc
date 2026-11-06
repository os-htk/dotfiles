# === History ===
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY        # share history across sessions
setopt EXTENDED_HISTORY     # record timestamp for each command
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY          # expand history (!! etc.) into the buffer to edit, not run immediately

# === Options ===
setopt AUTO_CD   # type a directory name to cd into it
setopt GLOB_DOTS # include dotfiles in globs
setopt NO_BEEP
setopt INTERACTIVE_COMMENTS # treat '#' as a comment even in an interactive shell

# === Completion ===
zmodload zsh/complist
autoload -Uz compinit
# regenerate only if the dump is older than 24 hours
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi
zstyle ':completion:*' menu select
# Populate LS_COLORS for completion coloring. GNU coreutils ships dircolors;
# macOS needs `brew install coreutils` (provides gdircolors). Absent both, the
# zstyle below just gets an empty value — no error, no colors.
if (( $+commands[dircolors] )); then
  eval "$(dircolors -b)"
elif (( $+commands[gdircolors] )); then
  eval "$(gdircolors -b)"
fi
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'  # case-insensitive

# === Key bindings ===
zmodload zsh/terminfo
bindkey -e  # emacs-style (Ctrl-A/E/W/R etc.)
bindkey "${terminfo[kcuu1]}" history-beginning-search-backward
bindkey "${terminfo[kcud1]}" history-beginning-search-forward
# put the terminal in application cursor mode so the arrow keys emit the terminfo
# keycodes bound above (without this the history-search bindings don't fire on some terminals)
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
  autoload -Uz add-zle-hook-widget
  function _zle_app_mode_start { echoti smkx }
  function _zle_app_mode_end   { echoti rmkx }
  add-zle-hook-widget line-init   _zle_app_mode_start
  add-zle-hook-widget line-finish _zle_app_mode_end
fi

# === Prompt ===
autoload -Uz vcs_info
precmd_functions+=(vcs_info)
zstyle ':vcs_info:*' enable git   # disable non-git backends to speed up prompt rendering
zstyle ':vcs_info:git:*' formats ' (%b)'
setopt PROMPT_SUBST
PROMPT='%F{green}%n@%m%f:%F{blue}%~%f%F{yellow}${vcs_info_msg_0_}%f
%# '

# === Aliases ===
# GNU ls colors with --color, BSD (macOS) ls colors with -G.
# Probe against /dev/null so the cwd isn't scanned; use `command` to bypass any alias.
if command ls --color=auto /dev/null >/dev/null 2>&1; then
  alias ls='ls --color=auto'
else
  alias ls='ls -G'
fi
alias ll='ls -alF'
alias la='ls -A'
alias grep='grep --color=auto'

# === lesspipe ===
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# === Local ===
# machine-specific config; can extend $ZSH_PLUGIN_DIRS before plugins load
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# === fzf ===
# Ctrl-R fuzzy history, Ctrl-T file picker, Alt-C cd. Must come after `bindkey -e`,
# which resets the keymap. Older fzf without --zsh (< 0.48) prints nothing to source.
(( $+commands[fzf] )) && source <(fzf --zsh 2>/dev/null)

# === Plugins ===
# search Homebrew ($HOMEBREW_PREFIX from .zshenv) first, then apt (/usr/share).
# source nothing if not found, so startup never errors across OSes.
typeset -ga ZSH_PLUGIN_DIRS
ZSH_PLUGIN_DIRS+=(${HOMEBREW_PREFIX:+$HOMEBREW_PREFIX/share} /usr/share)
for _d in $ZSH_PLUGIN_DIRS; do
  [[ -r "$_d/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] &&
    source "$_d/zsh-autosuggestions/zsh-autosuggestions.zsh" && break
done
for _d in $ZSH_PLUGIN_DIRS; do
  [[ -r "$_d/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] &&
    source "$_d/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" && break
done
unset _d
