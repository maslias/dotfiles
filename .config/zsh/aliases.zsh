alias lf="y"
alias task="go-task"
alias cl="clear"
alias ls='ls --color'
alias c='clear'
alias nv='nvim'
alias nv.='nvim .'
alias lg='lazygit'
alias sbnd="newsecondbrainnote 'daily'"
alias sbnm="newsecondbrainnote 'meeting'"
alias sbnt="newsecondbrainnote 'task'"
alias sbnto="newsecondbrainnote 'todo'"
alias sbn="newsecondbrainnote 'note'"

if command -v kubectl &>/dev/null; then
alias k="kubectl"
fi

if command -v eza &>/dev/null; then
  alias lsm='eza -lhg'
  alias ls='eza -alhg'
  alias tree='eza --tree'
fi



