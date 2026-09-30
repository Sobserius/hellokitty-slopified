#!/bin/bash
# Auto-update window border when quickshell theme changes (inotifywait version)
THEME_FILE="$HOME/.config/quickshell/state/theme.json"
STATE_DIR="$HOME/.config/quickshell/state"

mkdir -p "$STATE_DIR"

# Run once on start
bash /home/sob/hyprland-minions/hypr/assets/update-border.sh

# Watch the directory for theme file changes
inotifywait -m -e modify,create,move "$STATE_DIR" 2>/dev/null | while read -r dir event file; do
    if [ "$file" = "theme.json" ]; then
        bash /home/sob/hyprland-minions/hypr/assets/update-border.sh
    fi
done
