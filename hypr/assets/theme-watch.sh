#!/bin/bash
# Auto-update window border when quickshell theme changes
LAST_THEME=""
while true; do
    THEME=$(cat ~/.config/quickshell/state/theme.json 2>/dev/null | grep -o '"theme":"[^"]*"' | cut -d'"' -f4)
    if [ "$THEME" != "$LAST_THEME" ] && [ -n "$THEME" ]; then
        bash /home/sob/hyprland-minions/hypr/assets/update-border.sh
        LAST_THEME="$THEME"
    fi
    sleep 1
done
