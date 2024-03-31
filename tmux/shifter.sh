# Constants
WINDOW_FORMAT=" #I: #W "
BACKGROUND="#111111"
PRIMARY="#313340"

# Window
tmux set -g window-status-separator ""

## Current
tmux set -g window-status-current-format 
tmux set -g window-status-current-style "bg=$PRIMARY"

## General
tmux set -g window-status-style "bg=$BACKGROUND, fg=#767C9D"
tmux set -g window-status-format "$WINDOW_FORMAT"

# Status
tmux set -g status-bg "$BACKGROUND"
tmux set -g status-fg "#FAFAFA"

# Status Left
tmux set -g status-left ""
tmux set -g status-right ""
