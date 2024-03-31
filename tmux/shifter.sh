# Colors
WINDOW_FORMAT=" #I "
BACKGROUND="#111111"
PRIMARY="#313340"
FOREGROUND="#FAFAFA"

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
