#!/bin/bash
ip -4 addr show $(ip route | awk '/default/ {print $5}') | \
grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -n1 | xclip -selection clipboard

notify-send "Ethernet IP copied" "$(xclip -o -selection clipboard)"
