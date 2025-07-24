killall eww
eww open bar --debug 
eww open wifi-bar --debug
eww open essensial-bar --debug  
sleep 1
eww update wifi-revealed=false
eww open volume-bar --debug
eww update _vol="$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -1 | tr -d '%')"
~/.config/eww/scripts/network/scan-wifi.sh
