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
setopt HIST_IGNORE_DUPS HIST_IGNORE_SPACE APPEND_HISTORY SHARE_HISTORY

# ----------------------------------------------------------------------------
# Shell options
# ----------------------------------------------------------------------------
setopt AUTO_CD INTERACTIVE_COMMENTS

# ----------------------------------------------------------------------------
# Aliases
# ----------------------------------------------------------------------------
[ -f ~/.aliases ] && source ~/.aliases

# ----------------------------------------------------------------------------
# PATH
# ----------------------------------------------------------------------------
export PATH=/opt/homebrew/bin/:$PATH
export PATH="/opt/homebrew/opt/node@14/bin:$PATH"
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Java / Android
export JAVA_HOME="/Applications/Android Studio.app/Contents/jbr/Contents/Home"
export ANDROID_HOME="$HOME/Library/Android/sdk"

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
bindkey '^[[A' up-line-or-beginning-search    # Up arrow
bindkey '^[[B' down-line-or-beginning-search  # Down arrow
