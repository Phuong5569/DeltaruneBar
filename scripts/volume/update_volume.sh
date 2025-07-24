#!/bin/bash
if [ "$1" = "up" ]; then
    pactl set-sink-volume @DEFAULT_SINK@ +5%
else
    pactl set-sink-volume @DEFAULT_SINK@ -5%
fi

eww update _vol="$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -1 | tr -d '%')"