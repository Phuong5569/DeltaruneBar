#!/bin/bash

# Infinite loop to stream the latest scroll output for Polybar
~/.config/eww/scripts/module/scroll_media -t 4 -l 20 | while read -r line; do
    echo "$line"
    sleep 0.4
done
