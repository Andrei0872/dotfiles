export ZSH="$HOME/.oh-my-zsh"
if command -v nvim >/dev/null 2>&1; then
  export MANPAGER='nvim +Man!'
fi

ZSH_THEME="mgutz"

DISABLE_AUTO_TITLE="true"

plugins=(git)

source $ZSH/oh-my-zsh.sh

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

[ -f ~/.zsh_aliases ] && source ~/.zsh_aliases

# KEY BINDINGS
# -----------------

# https://rm-rf.ca/posts/2020/zsh-vi-mode/
bindkey -v
bindkey ^R history-incremental-search-backward 
bindkey ^S history-incremental-search-forward
bindkey -M vicmd "^V" edit-command-line
# https://www.johnhawthorn.com/2012/09/vi-escape-delays/
export KEYTIMEOUT=1
bindkey "^[OA" up-line-or-beginning-search
bindkey "^[OB" down-line-or-beginning-search
bindkey -M vicmd "k" up-line-or-beginning-search
bindkey -M vicmd "j" down-line-or-beginning-search
bindkey "^P" history-search-backward
bindkey "^N" history-search-forward
bindkey -M vicmd '?' history-incremental-search-backward
bindkey -M vicmd '/' history-incremental-search-forward
bindkey -M viins '^R' history-incremental-pattern-search-backward
bindkey -M viins '^F' history-incremental-pattern-search-forward

# CUSTOM ZLE WIDGETS
# -----------------

# Reference: https://stratus3d.com/blog/2017/10/26/better-vi-mode-in-zshell/.

# Updates editor information when the keymap changes.
function zle-keymap-select() {
  zle reset-prompt
  zle -R
}

zle -N zle-keymap-select

function vi_mode_prompt_info() {
  echo "${${KEYMAP/vicmd/[% NORMAL]%}/(main|viins)/[% INSERT]%}"
}

RPS1='$(vi_mode_prompt_info)'
RPS2=$RPS1

export PATH="$HOME/.local/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/andrei/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
