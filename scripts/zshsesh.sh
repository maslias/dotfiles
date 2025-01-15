#!/usr/bin/env bash


sesh connect $( \
    sesh list | fzf \
    --no-sort --prompt '󱐋  ' \
 --border --border-label '   sesh   ' \
    --header '^a all ^t tmux ^g configs ^x zoxide ^d kill session' \
    --bind 'tab:down,btab:up' \
    --bind 'ctrl-a:change-prompt(󱐋  )+reload(sesh list)' \
    --bind 'ctrl-t:change-prompt(  )+reload(sesh list -t)' \
    --bind 'ctrl-g:change-prompt(  )+reload(sesh list -c)' \
    --bind 'ctrl-x:change-prompt(  )+reload(sesh list -z)' \
    --bind 'ctrl-d:execute(tmux kill-session -t {})+change-prompt(⚡  )+reload(sesh list)' \
    )

