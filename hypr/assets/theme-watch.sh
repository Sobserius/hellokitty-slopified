#!/bin/bash
# Auto-update window border when quickshell theme changes (inotifywait version)
THEME_FILE="$HOME/.config/quickshell/state/theme.json"

# Run once on start
bash /home/sob/hyprland-minions/hypr/assets/update-border.sh

# Watch for changes
inotifywait -m -e modify,create,move "$THEME_FILE" 2>/dev/null | while read -r; do
    bash /home/sob/hyprland-minions/hypr/assets/update-border.sh
done
