#!/usr/bin/env bash
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source $CURRENT_DIR/scripts/theme.sh

window_number_active="#($CURRENT_DIR/scripts/custom_number.sh #I dsquare)"
window_number_inactive="#($CURRENT_DIR/scripts/custom_number.sh #I hsquare)"

set() {
    local option=$1
    local value=$2
    tmux_commands+=(set-option -gq "$option" "$value" ";")
}

setw() {
    local option=$1
    local value=$2
    tmux_commands+=(set-window-option -gq "$option" "$value" ";")
}


main() {

    ## style stuff
    set status-bg default
    set status-style bg=default
    set status-left-length 200
    set status-right-length 200
    set status-justify "absolute-centre"

    set message-style "fg=${THEME[orange]},bg=${THEME[bg]}"
    set message-command-style "fg=${THEME[white]},bg=${THEME[orange]}"

    set pane-border-style "fg=${THEME[dark]}"
    set pane-active-border-style "fg=${THEME[orange]}"
    set display-panes-active-colour "${THEME[white]}"
    set display-panes-colour "${THEME[orange]}"

    set status-left "#[fg=${THEME[bg]},bold,nodim]#{?client_prefix,#[bg=${THEME[orange]}],#{?#{==:#{pane_current_command},ssh},#[bg=${THEME[pink]}],#[bg=${THEME[yellow]}]}} Tmux #[bg=${THEME[bg]}]#[fg=${THEME[white]}]  #S"
    setw window-status-separator "#[fg=${THEME[white]}]  •  "
    setw window-status-current-format " #{?#{==:#{pane_current_command},ssh},#[fg=${THEME[pink]}],#[fg=${THEME[yellow]}]}$window_number_active #{?#{==:#{pane_current_command},ssh},󰢹,}"
    setw window-status-format "#[fg=${THEME[grey]}]$window_number_inactive #{?#{==:#{pane_current_command},ssh},󰢹,}"

    set status-right "#[fg=${THEME[white]}]󰢹 #{hostname} #[fg=${THEME[bg]}]#{?client_prefix,#[bg=${THEME[orange]}],#{?#{==:#{pane_current_command},ssh},#[bg=${THEME[pink]}],#[bg=${THEME[yellow]}]}}   "

    tmux "${tmux_commands[@]}"

 }


 main "$@"

