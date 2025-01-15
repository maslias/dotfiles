alias lf="y"
alias cl="clear"
alias ls='ls --color'
alias c='clear'
alias nv='nvim'
alias nv.='nvim .'
alias lg='lazygit'

if command -v kubectl &>/dev/null; then
alias k="kubectl"
fi

 if command -v eza &>/dev/null; then
    alias lsm='eza -lhg'
    alias ls='eza -alhg'
    alias tree='eza --tree'
  fi



