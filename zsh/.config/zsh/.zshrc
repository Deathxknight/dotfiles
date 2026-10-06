
export ZSH_CONFIG="$HOME/.config/zsh"
export ZSH_PLUGINS="$ZSH_CONFIG/plugins"
export PATH="$HOME/.local/bin:$PATH"

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

[ -f "$ZSH_CONFIG/colors.zsh" ] && source "$ZSH_CONFIG/colors.zsh"

HISTSIZE=10000
SAVEHIST=10000
HISTFILE="$HOME/.zsh_history"

autoload -Uz compinit
compinit

autoload -Uz vcs_info
precmd() { vcs_info }
setopt prompt_subst

# prompt: user@host ~/dir (branch) %
PROMPT='(˶˃⤙˂˶) ➤'

alias ls='ls --color=auto'
alias ll='ls -la'
alias l='ls -l'
alias la='ls -A'
alias grep='grep --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias ssh="TERM=xterm-256color ssh"

mkcd() { mkdir -p "$1" && cd "$1"; }

# stow helper
stowall() {
    cd ~/dotfiles
    for pkg in */; do
        stow "${pkg%/}"
    done
    cd - > /dev/null
}

# up/down arrows search history
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end

# glob dotfiles
setopt globdots

# local overrides
[ -f "$ZSH_CONFIG/local.zsh" ] && source "$ZSH_CONFIG/local.zsh"
