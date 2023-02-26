#!/usr/bin/env bash
# vim:noswapfile:number

set -eou pipefail

# kitty @ ls | ./kitty-convert-dump.py > session.conf

kitty @ ls |  "$HOME/.config/kitty/kitty-convert-dump.py" > "$HOME/.config/kitty/session.conf"

kitty @ send-text "kitty session dumped"
