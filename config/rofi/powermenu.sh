#!/bin/bash

THEME="$HOME/.config/rofi/config.rasi"

options="⏻ Shutdown\n🔄 Reboot\n💤 Suspend\n🔒 Lock\n🚪 Logout\n🌙 Hibernate"

chosen=$(echo -e "$options" | rofi -dmenu -i -p "Power Menu" -theme "$THEME")

lock() {
    # use hyprlock properly
    if command -v hyprlock >/dev/null 2>&1; then
        hyprlock
    else
        notify-send "Hyprlock not found!"
    fi
}

case "$chosen" in
    "⏻ Shutdown")
        systemctl poweroff
        ;;
    "🔄 Reboot")
        systemctl reboot
        ;;
    "💤 Suspend")
        lock
        sleep 0.5
        systemctl suspend
        ;;
    "🔒 Lock")
        lock
        ;;
    "🚪 Logout")
        hyprctl dispatch exit
        ;;
    "🌙 Hibernate")
        lock
        sleep 0.5
        systemctl hibernate
        ;;
esac
