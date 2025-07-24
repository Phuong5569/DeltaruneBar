#!/bin/bash

output="$HOME/.config/eww/scripts/bluetooth/bluetooth_all.json"
echo -n "[" > "$output"

bluetoothctl devices | while read -r _ mac name_rest; do
  name=$(echo "$name_rest" | sed 's/^ *//')
  info=$(bluetoothctl info "$mac")

  connected=$(echo "$info" | grep "Connected:" | awk '{print $2}')
  trusted=$(echo "$info" | grep "Trusted:" | awk '{print $2}')

  is_connected=false
  is_trusted=false

  [ "$connected" = "yes" ] && is_connected=true
  [ "$trusted" = "yes" ] && is_trusted=true

  echo -n "{\"mac\":\"$mac\",\"name\":\"$name\",\"connected\":$is_connected,\"trusted\":$is_trusted}," >> "$output"
done

# Remove trailing comma
sed -i '$ s/,$//' "$output"
echo "]" >> "$output"
