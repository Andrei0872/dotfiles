export ZSH="$HOME/.oh-my-zsh"
if command -v nvim >/dev/null 2>&1; then
  export MANPAGER='nvim +Man!'
fi

ZSH_THEME="mgutz"

DISABLE_AUTO_TITLE="true"

plugins=(git)

if command -v docker >/dev/null 2>&1; then
  if [[ ! -f ~/.docker/completions/_docker ]]; then
    mkdir -p ~/.docker/completions
    docker completion zsh > ~/.docker/completions/_docker
  fi
  fpath=(~/.docker/completions $fpath)
fi

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
bindkey -M vicmd "^W" backward-kill-word
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

# Ctrl-R leaves the cursor at the start of the matched text instead of the
# end of the recalled line, which starves Ctrl-W (backward-kill-word) of
# anything to delete. Jump to end-of-line once the search is accepted.
function zle-isearch-exit() {
  zle end-of-line
}
zle -N zle-isearch-exit

function vi_mode_prompt_info() {
  echo "${${KEYMAP/vicmd/[% NORMAL]%}/(main|viins)/[% INSERT]%}"
}

RPS1='$(vi_mode_prompt_info)'
RPS2=$RPS1

export PATH="$HOME/.local/bin:$PATH"

# code-bridge.nvim (nvim/after/plugin/code-bridge.lua) targets a tmux window
# literally named "claude" by default. Auto-rename the current window on
# launch so it's discoverable without a manual `tmux rename-window`, unless
# a "claude" window already exists in this session (avoid stealing/clashing
# with it). Restore the previous name on exit if we renamed.
if [[ -n "$TMUX" ]]; then
  claude() {
    local prev_name renamed=0
    if ! tmux list-windows -F '#{window_name}' | grep -qx claude; then
      prev_name=$(tmux display-message -p '#W')
      tmux rename-window claude
      renamed=1
    fi
    command claude "$@"
    local status=$?
    (( renamed )) && tmux rename-window "$prev_name"
    return $status
  }
fi

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^Xe' edit-command-line

# pnpm
export PNPM_HOME="/Users/andrei/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Go
export PATH="$HOME/go/bin:$PATH"
