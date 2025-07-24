# #!/bin/bash

# # Ensure UTF-8 encoding
# export LANG=en_US.UTF-8
# export LC_ALL=en_US.UTF-8

# # Check if nvidia-smi is available
# if ! command -v nvidia-smi &> /dev/null; then
#     echo "Error: nvidia-smi not found. Make sure NVIDIA drivers are installed."
#     exit 1
# fi

# # Get GPU usage %
# usage=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null | head -n1)

# # Check valid response
# if [ -z "$usage" ]; then
#     echo "Error: Could not get GPU usage data"
#     exit 1
# fi

# usage=$(echo "$usage" | tr -d '[:space:]' | grep -o '[0-9]*')

# if [ -z "$usage" ]; then
#     usage=0
# fi

# if [ "$usage" -gt 100 ]; then
#     usage=100
# fi

# # Bar config
# width=10 # number of characters in bar
# char_full="█"
# char_empty="░"

# # Polybar color codes
# color_full="%{F#ee00ff}"    # Susie color
# color_empty="%{F#70000a}"   # Heart
# color_reset="%{F-}"         # default foreground 

# # Calculate filled/empty chars
# filled=$(( usage * width / 100 ))
# empty=$(( width - filled ))

# # Build the bar
# if [ "$filled" -gt 0 ]; then
#     bar_filled=$(printf "%*s" "$filled" | sed "s/ /${color_full}${char_full}${color_reset}/g")
# else
#     bar_filled=""
# fi

# if [ "$empty" -gt 0 ]; then
#     bar_empty=$(printf "%*s" "$empty" | sed "s/ /${color_empty}${char_empty}${color_reset}/g")
# else
#     bar_empty=""
# fi

# bar="$bar_filled$bar_empty"

# echo "SUSIE $bar"


#!/bin/bash
# Ensure UTF-8 encoding
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Check if nvidia-smi is available
if ! command -v nvidia-smi &> /dev/null; then
    echo "Error: nvidia-smi not found. Make sure NVIDIA drivers are installed."
    exit 1
fi

# Get GPU usage %
usage=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null | head -n1)

# Check valid response
if [ -z "$usage" ]; then
    echo "Error: Could not get GPU usage data"
    exit 1
fi

usage=$(echo "$usage" | tr -d '[:space:]' | grep -o '[0-9]*')
if [ -z "$usage" ]; then
    usage=0
fi

if [ "$usage" -gt 100 ]; then
    usage=100
fi

# Bar config
width=10 # number of characters in bar
char_full="█"
char_empty="░"

# Calculate filled/empty chars
filled=$(( usage * width / 100 ))
empty=$(( width - filled ))

# Build the bar
if [ "$filled" -gt 0 ]; then
    bar_filled=$(printf "%*s" "$filled" | sed "s/ /${char_full}/g")
else
    bar_filled=""
fi

if [ "$empty" -gt 0 ]; then
    bar_empty=$(printf "%*s" "$empty" | sed "s/ /${char_empty}/g")
else
    bar_empty=""
fi

bar="$bar_filled$bar_empty"
echo "SUSIE $bar"