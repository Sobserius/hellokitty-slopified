#!/bin/bash
# Update window border image + hyprbar color based on theme ID
THEME="${1:-bubblegum}"
ASSETS_DIR="/home/sob/hyprland-minions/hypr/assets"
HYPR_CONFIG="$HOME/.config/hypr/hyprland.lua"

case "$THEME" in
    bubblegum)
        cp "$ASSETS_DIR/bubblegum_window.png" "$ASSETS_DIR/border_hellokitty.png"
        cp "$ASSETS_DIR/bubblegum_window2.png" "$ASSETS_DIR/hellokitty_face.png"
        BAR_COLOR="rgb(d27b99)"
        ;;
    blueberry)
        cp "$ASSETS_DIR/blueberry_window.png" "$ASSETS_DIR/border_hellokitty.png"
        cp "$ASSETS_DIR/blueberry_window2.png" "$ASSETS_DIR/hellokitty_face.png"
        BAR_COLOR="rgb(6ba3d6)"
        ;;
    grape)
        cp "$ASSETS_DIR/grape_window.png" "$ASSETS_DIR/border_hellokitty.png"
        cp "$ASSETS_DIR/grape_window2.png" "$ASSETS_DIR/hellokitty_face.png"
        BAR_COLOR="rgb(9c8de6)"
        ;;
    graphite)
        cp "$ASSETS_DIR/graphite_window.png" "$ASSETS_DIR/border_hellokitty.png"
        cp "$ASSETS_DIR/graphite_window2.png" "$ASSETS_DIR/hellokitty_face.png"
        BAR_COLOR="rgb(606b64)"
        ;;
    lemon)
        cp "$ASSETS_DIR/lemon_window.png" "$ASSETS_DIR/border_hellokitty.png"
        cp "$ASSETS_DIR/lemon_window2.png" "$ASSETS_DIR/hellokitty_face.png"
        BAR_COLOR="rgb(d4c94e)"
        ;;
    lime)
        cp "$ASSETS_DIR/lime_window.png" "$ASSETS_DIR/border_hellokitty.png"
        cp "$ASSETS_DIR/lime_window2.png" "$ASSETS_DIR/hellokitty_face.png"
        BAR_COLOR="rgb(8bc34a)"
        ;;
    *)
        cp "$ASSETS_DIR/bubblegum_window.png" "$ASSETS_DIR/border_hellokitty.png"
        cp "$ASSETS_DIR/bubblegum_window2.png" "$ASSETS_DIR/hellokitty_face.png"
        BAR_COLOR="rgb(d27b99)"
        ;;
esac

# Update ~/.config for the running session
cp "$ASSETS_DIR/border_hellokitty.png" ~/.config/hypr/assets/border_hellokitty.png
cp "$ASSETS_DIR/hellokitty_face.png" ~/.config/hypr/assets/hellokitty_face.png

# Update hyprbar color in config
sed -i "s/bar_color = \"[^\"]*\"/bar_color = \"$BAR_COLOR\"/" "$HYPR_CONFIG"
cp "$HYPR_CONFIG" /home/sob/hyprland-minions/hypr/hyprland.lua

# Reload hyprland config so imgborders + hyprbars pick up changes
hyprctl reload

echo "Border + bar updated for theme: $THEME"
