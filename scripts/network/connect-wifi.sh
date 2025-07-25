https://elkowar.github.io/eww/widgets.html#!/bin/bash

SSID="$1"
SECURITY="$2"
CON_NAME="eww-${SSID// /_}" # Replace spaces with underscores

# Exit if no SSID
[ -z "$SSID" ] && exit 1

# For open networks
if [[ "$SECURITY" == "none" ]]; then
  nmcli dev wifi connect "$SSID" name "$CON_NAME"
  exit $?
fi

# Prompt for password
PASS=$(zenity --password --title="Wi-Fi Password for $SSID")
[ -z "$PASS" ] && exit 1

# Delete existing connection with that name (if exists)
nmcli con delete "$CON_NAME" 2>/dev/null

# Add a new connection with full key-mgmt
nmcli con add type wifi ifname wlo1 con-name "$CON_NAME" ssid "$SSID" \
  wifi-sec.key-mgmt wpa-psk wifi-sec.psk "$PASS"

# Bring it up
nmcli con up "$CON_NAME"
