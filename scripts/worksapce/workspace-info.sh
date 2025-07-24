#!/bin/bash  

while true; do
  workspaces=$(hyprctl workspaces -j | jq -r 'map({(.id | tostring): (.windows | length)}) | add')
  current=$(hyprctl activeworkspace -j | jq -r '.id')
  eww update workspace-windows="$workspaces"
  eww update current-workspace="$current"
  sleep 0.5
done