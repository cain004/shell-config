# ============================================================================
# Zsh Configuration
# ============================================================================

[[ $- != *i* ]] && return

# ----------------------------------------------------------------------------
# Completion
# ----------------------------------------------------------------------------
fpath+=~/.zfunc
autoload -Uz compinit && compinit
autoload bashcompinit && bashcompinit

# ----------------------------------------------------------------------------
# History
# ----------------------------------------------------------------------------
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS HIST_FIND_NO_DUPS HIST_IGNORE_SPACE APPEND_HISTORY SHARE_HISTORY

# ----------------------------------------------------------------------------
# Shell options
# ----------------------------------------------------------------------------
setopt AUTO_CD INTERACTIVE_COMMENTS

# ----------------------------------------------------------------------------
# Aliases
# ----------------------------------------------------------------------------
[ -f ~/.aliases ] && source ~/.aliases

# ----------------------------------------------------------------------------
# Editor
# ----------------------------------------------------------------------------
export EDITOR="nvim"
export VISUAL="nvim"

# ----------------------------------------------------------------------------
# PATH
# ----------------------------------------------------------------------------
[ -d /opt/homebrew/bin ] && export PATH="/opt/homebrew/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# ----------------------------------------------------------------------------
# Starship prompt (install: brew install starship)
# ----------------------------------------------------------------------------
eval "$(starship init zsh)"

# ----------------------------------------------------------------------------
# Key bindings — history substring search (must be after starship init)
# ----------------------------------------------------------------------------
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search   # Up arrow (application mode)
bindkey "${terminfo[kcud1]}" down-line-or-beginning-search # Down arrow (application mode)
bindkey "^[[A" up-line-or-beginning-search                 # Up arrow (normal mode)
bindkey "^[[B" down-line-or-beginning-search               # Down arrow (normal mode)

# ----------------------------------------------------------------------------
# Terminal title
# ----------------------------------------------------------------------------
set_terminal_title() { echo -en "\e]1;$@\a"; }

# ----------------------------------------------------------------------------
# Local overrides (machine-specific, not in repo)
# ----------------------------------------------------------------------------
[ -f ~/.local.zshrc ] && source ~/.local.zshrc
