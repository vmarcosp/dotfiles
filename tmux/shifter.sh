# Colors
WINDOW_FORMAT=" #I: #W "
BACKGROUND="#000000"
PRIMARY="#151515"
FOREGROUND="#D2D2D2"

# Window
tmux set -g window-status-separator ""

## Current
tmux set -g window-status-current-format "$WINDOW_FORMAT"
tmux set -g window-status-current-style "bg=$PRIMARY"

## General
tmux set -g window-status-style "bg=$BACKGROUND, fg=$FOREGROUND"
tmux set -g window-status-format "$WINDOW_FORMAT"

# Status
tmux set -g status-bg "$BACKGROUND"
tmux set -g status-fg "$FOREGROUND"

# Status Left
tmux set -g status-left ""
tmux set -g status-right ""
