#!/bin/bash

dir="$HOME/.config/eww/resources/star_animation"
files=($(ls "$dir" | sort))

while true; do
    for file in "${files[@]}"; do
        echo "$dir/$file"
        sleep 1
    done
done
