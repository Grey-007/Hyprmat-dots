#!/bin/bash

THEME="$HOME/.config/rofi/config.rasi"
ICONS="$HOME/.config/rofi/assets"

# Options with labels and icon metadata for rofi 1.7.5
options="Shutdown\x00icon\x1f$ICONS/shutdown.png\n"
options+="Reboot\x00icon\x1f$ICONS/reboot.png\n"
options+="Suspend\x00icon\x1f$ICONS/suspend.png\n"
options+="Lock\x00icon\x1f$ICONS/lock.png\n"
options+="Logout\x00icon\x1f$ICONS/logout.png\n"
options+="Hibernate\x00icon\x1f$ICONS/hibernate.png"

chosen=$(echo -e "$options" | rofi -dmenu -i -p "Power Menu" -theme "$THEME" -show-icons)

lock() {
    # use hyprlock properly
    if command -v hyprlock >/dev/null 2>&1; then
        hyprlock
    else
        notify-send "Hyprlock not found!"
    fi
}

case "$chosen" in
    "Shutdown")
        systemctl poweroff
        ;;
    "Reboot")
        systemctl reboot
        ;;
    "Suspend")
        lock
        sleep 0.5
        systemctl suspend
        ;;
    "Lock")
        lock
        ;;
    "Logout")
        hyprctl dispatch exit
        ;;
    "Hibernate")
        lock
        sleep 0.5
        systemctl hibernate
        ;;
esac