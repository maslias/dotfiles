#xdg 
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CONFIG_HOME=$HOME/.config
export XDG_STATE_HOME=$HOME/.local/state
export XDG_CACHE_HOME=$HOME/.cache
export XDG_BIN_HOME=$HOME/.local/bin
export XDG_ZETTELKASTEN_HOME=$HOME/zettelkasten
export XDG_SCRIPTS_HOME=$HOME/scripts

#executeable bins
export PATH=$XDG_BIN_HOME:$PATH
export PATH=$XDG_SCRIPTS_HOME:$PATH

# adds ~/.local/bin and subfolders to $PATH
# export PATH="${$(find $XDG_BIN_HOME -maxdepth 1 -type d -printf %p:)%%:}$PATH"

#default
export EDITOR=nvim
export TERMINAL=kitty
export BROWSER=firefox


#zsh
export HISTFILE=$XDG_STATE_HOME/zsh/history
# ZVM_INIT_MODE=sourcing
autoload -Uz compinit
compinit -d $XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION

# pnpm
export PNPM_HOME=$XDG_DATA_HOME/pnpm
export PATH=$PNPM_HOME:$PATH

#go lang
export GOROOT=/usr/local/go
export GOPATH=$XDG_DATA_HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
# export PATH=$PATH:$GOPATH/bin:$GOROOT/bin

#less
export LESSHISTFILE="$XDG_STATE_HOME"/less/history

#nvm
export NVM_DIR=$XDG_DATA_HOME/nvm
# [ -s "$NVM_DIR/nvm.sh" ] && \. $NVM_DIR/nvm.sh  
# [ -s "$NVM_DIR/bash_completion" ] && \. $NVM_DIR/bash_completion  

#rust & cargo
export CARGO_HOME=$XDG_DATA_HOME/cargo
export RUSTUP_HOME=$XDG_DATA_HOME/rustup
#$CARGO_HOME/env


#fzf
# export FZF_DEFAULT_COMMAND='rg --files --hidden -g "!.git" '
export FZF_DEFAULT_COMMAND='find . \! \( -type d -path ./.git -prune \) \! \( -type d -path ./remote -prune \) \! -type d \! -name '\''*.tags'\'' -printf '\''%P\n'\'
export FZF_CTRL_T_COMMAND='find . \! \( -type d -path ./.git -prune \) \! \( -type d -path ./remote -prune \) \! -type d \! -name '\''*.tags'\'' -printf '\''%P\n'\'
export FZF_ALT_C_COMMAND='find . \! \( -type d -path ./.git -prune \) \! \( -type d -path ./remote -prune \)  \! -name '\''*.tags'\'' -printf '\''%P\n'\'

# export SSH_ASKPASS_REQUIRE=force
# export SSH_ASKPASS="asksshpass"


#zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
