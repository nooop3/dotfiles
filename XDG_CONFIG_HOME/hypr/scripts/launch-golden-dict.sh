#!/bin/bash

goldendict "$(wl-paste -p -n)"

# Wait for window to appear
# sleep 0.3

# Get window address
ADDR=$(hyprctl clients -j | jq -r '.[] | select(.class | test("^(.*goldendict-ng.*)$")) | .address')

# Get cursor position
read -r X Y <<<"$(hyprctl cursorpos | awk -F, '{print $1, $2}')"

# Offset slightly (e.g., up-left of cursor)
((X -= 100))
((Y -= 50))

# Move the window
hyprctl dispatch movewindowpixel exact "$X $Y,address:$ADDR"
