source "$HOME/.config/zsh/exports.zsh"
source "$HOME/.config/zsh/aliases.zsh"


if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
# zinit light olets/zsh-transient-prompt

# zinit ice depth=1
# zinit light jeffreytse/zsh-vi-mode

zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::aws
zinit snippet OMZP::command-not-found
zinit snippet OMZP::ssh-agent

autoload -Uz compinit && compinit

zinit cdreplay -q

HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'


source "$HOME/.config/zsh/keybinds.zsh"

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}


if ! tmux has-session -t="dailynote" 2>/dev/null; then

  # check resources for second-brain
  newsecondbrainnote "structure"

  # check for todos
  newsecondbrainnote "todo"

  #check for dailynote
  local daily_name=$(newsecondbrainnote "daily")

  #check for dailynote
  local todo_name=$(newsecondbrainnote "todo")

  #check hubs entrys
  hubssecondbrain

  # tmux new-session -ds "dailynote" -c "$XDG_SECOND_BRAIN_HOME/dailys" "nvim $daily_name" \; split-window h "nvim $todo_name"
  # tmux new-session -ds "dailynote" -c "$XDG_SECOND_BRAIN_HOME/dailys"
  # tmux split-window -h -t "dailynote" -c "$XDG_SECOND_BRAIN_HOME/todos/"
  # tmux send-keys -t "dailynote":1.1 "nvim $daily_name" C-m
  # tmux send-keys -t "dailynote":1.2 "nvim $todo_name" C-m
 tmux new-session -ds "dailynote" -c "$XDG_SECOND_BRAIN_HOME/dailys" \; split-window -t "dailynote":0 -h -c "$XDG_SECOND_BRAIN_HOME/todos/" \; send-keys -t "dailynote":0.1 "nvim $daily_name" C-m \; send-keys -t "dailynote":0.2 "nvim $todo_name" C-m
fi


if ! tmux has-session -t="$(date +"%F-%A")" 2>/dev/null; then
  tmux new-session -ds "$(date +"%F-%A")" -c "$HOME" 
fi


if [[  ! "$TMUX" ]]; then
  tmux attach
fi


# Load Starship
eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(oh-my-posh init zsh --config $XDG_CONFIG_HOME/ohmyposh/zen.toml)"
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
eval "$(direnv hook zsh)"
eval "$(task --completion zsh)"

