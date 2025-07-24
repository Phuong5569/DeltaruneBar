#!/bin/bash

# Force scan
nmcli device wifi rescan > /dev/null 2>&1
sleep 1

# Capture JSON list
json=$(
  nmcli -t -f SSID,SIGNAL,SECURITY,IN-USE dev wifi list | \
  awk -F: 'NF && $1 != "" {
    gsub(/"/, "\\\"", $1);
    if (NR > 1) printf ",";
    printf "{\"ssid\":\"%s\",\"signal\":%s,\"security\":\"%s\",\"connected\":%s}",
    $1, $2, $3, ($4 == "*" ? "true" : "false")
  }' | sed '1s/^/[/' | sed '$s/$/]/'
)

# Write to file (optional)
echo "$json" > ~/.config/eww/scripts/network/list-wifi.json

# Push to eww
eww update wifi-networks="$json"
