#!/bin/bash

# List all Ethernet interfaces (type 'ether') that are UP
ether_devs=$(ip -o link show | awk -F': ' '/state UP/ {print $2}' | xargs -n1 -I{} bash -c 'cat /sys/class/net/{}/type' | grep -w 1 | awk -F: '{print $1}')

# Try to get the IPv4 address of the first Ethernet interface
for iface in $(ls /sys/class/net); do
  if [[ "$(cat /sys/class/net/$iface/type)" == "1" ]] && [[ "$(cat /sys/class/net/$iface/operstate)" == "up" ]]; then
    ip=$(ip -4 addr show "$iface" | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -n1)
    if [[ -n "$ip" ]]; then
      echo "$ip" | xclip -selection clipboard
      notify-send "Ethernet IP copied" "$ip"
      exit 0
    fi
  fi
done

notify-send "No active Ethernet interface found"
