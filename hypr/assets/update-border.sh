#!/bin/bash
# Update window border image based on theme ID passed from quickshell
THEME="${1:-bubblegum}"
ASSETS_DIR="/home/sob/hyprland-minions/hypr/assets"

case "$THEME" in
    bubblegum)
        cp "$ASSETS_DIR/bubblegum_window.png" "$ASSETS_DIR/border_hellokitty.png"
        cp "$ASSETS_DIR/bubblegum_window2.png" "$ASSETS_DIR/hellokitty_face.png"
        ;;
    blueberry)
        cp "$ASSETS_DIR/blueberry_window.png" "$ASSETS_DIR/border_hellokitty.png"
        cp "$ASSETS_DIR/blueberry_window2.png" "$ASSETS_DIR/hellokitty_face.png"
        ;;
    grape)
        cp "$ASSETS_DIR/grape_window.png" "$ASSETS_DIR/border_hellokitty.png"
        cp "$ASSETS_DIR/grape_window2.png" "$ASSETS_DIR/hellokitty_face.png"
        ;;
    graphite)
        cp "$ASSETS_DIR/graphite_window.png" "$ASSETS_DIR/border_hellokitty.png"
        cp "$ASSETS_DIR/graphite_window2.png" "$ASSETS_DIR/hellokitty_face.png"
        ;;
    lemon)
        cp "$ASSETS_DIR/lemon_window.png" "$ASSETS_DIR/border_hellokitty.png"
        cp "$ASSETS_DIR/lemon_window2.png" "$ASSETS_DIR/hellokitty_face.png"
        ;;
    lime)
        cp "$ASSETS_DIR/lime_window.png" "$ASSETS_DIR/border_hellokitty.png"
        cp "$ASSETS_DIR/lime_window2.png" "$ASSETS_DIR/hellokitty_face.png"
        ;;
    *)
        cp "$ASSETS_DIR/bubblegum_window.png" "$ASSETS_DIR/border_hellokitty.png"
        cp "$ASSETS_DIR/bubblegum_window2.png" "$ASSETS_DIR/hellokitty_face.png"
        ;;
esac

# Also update ~/.config for the running session
cp "$ASSETS_DIR/border_hellokitty.png" ~/.config/hypr/assets/border_hellokitty.png
cp "$ASSETS_DIR/hellokitty_face.png" ~/.config/hypr/assets/hellokitty_face.png

# Reload imgborders plugin so it picks up the new images
hyprctl plugin unload imgborders 2>/dev/null
sleep 0.2
hyprctl plugin load ~/Documents/imgborders/build/libimgborders.so 2>/dev/null

echo "Border updated for theme: $THEME"
