#!/bin/bash

# Kill existing Waybar
pkill -x waybar
sleep 0.2

# Ensure Wayland env (important when run from rofi)
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
export WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-wayland-1}"

# Restart Waybar with explicit config paths
nohup waybar \
  -c "$HOME/.config/waybar/config.jsonc" \
  -s "$HOME/.config/waybar/style.css" \
  >/tmp/waybar.log 2>&1 &
