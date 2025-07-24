#!/bin/bash

# Automatically find first non-loopback ethernet device
for dev in /sys/class/net/*; do
  [[ "$(cat "$dev/type")" == "1" && "$(basename "$dev")" != "lo" ]] && iface=$(basename "$dev") && break
done

# Check if the interface is up
if [[ "$(cat /sys/class/net/$iface/operstate)" == "up" ]]; then
  echo 1   # true
else
  echo 0   # false
fi
