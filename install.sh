#!/usr/bin/env bash
# Installer for the Hello Kitty Hyprland rice.
# Hyprland 0.55+ reads ~/.config/hypr/hyprland.lua, so this just puts the two
# folders where they belong and makes sure the packages are there.
set -euo pipefail

_self="${BASH_SOURCE[0]}"
while [ -L "$_self" ]; do
    _dir="$(cd -P "$(dirname "$_self")" && pwd)"
    _self="$(readlink "$_self")"
    case "$_self" in /*) ;; *) _self="$_dir/$_self" ;; esac
done
HERE="$(cd -P "$(dirname "$_self")" && pwd)"
CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}"

ok()   { printf '  \033[32mok\033[0m    %s\n' "$*"; }
warn() { printf '  \033[33mwarn\033[0m  %s\n' "$*"; }
err()  { printf '  \033[31mfail\033[0m  %s\n' "$*"; }
step() { printf '\n\033[1m%s\033[0m\n' "$*"; }

PKGS=(hyprland hyprlock hypridle hyprpm quickshell swaybg
      xdg-desktop-portal xdg-desktop-portal-hyprland xdg-desktop-portal-wlr
      polkit-gnome kitty thunar)

step "packages"
missing=()
for p in "${PKGS[@]}"; do
    pacman -Q "$p" >/dev/null 2>&1 || missing+=("$p")
done
if [ "${#missing[@]}" -eq 0 ]; then
    ok "all ${#PKGS[@]} packages already installed"
else
    printf '  missing: %s\n\n' "${missing[*]}"
    printf '  needs your password:\n\n    sudo pacman -S %s\n\n' "${missing[*]}"
    read -r -p "  run it now? [y/N] " go
    case "$go" in
        [yY]*) sudo pacman -S --needed "${missing[@]}" || { err "install failed, stopping"; exit 1; } ;;
        *) warn "skipped - install these before starting Hyprland"; exit 1 ;;
    esac
fi

step "configs"
[ -d "$CONFIG/hypr" ] && warn "$CONFIG/hypr exists, moving it to hypr.slop-backup" && mv "$CONFIG/hypr" "$CONFIG/hypr.slop-backup"
[ -d "$CONFIG/quickshell" ] && warn "$CONFIG/quickshell exists, moving it to quickshell.slop-backup" && mv "$CONFIG/quickshell" "$CONFIG/quickshell.slop-backup"
mkdir -p "$CONFIG"
cp -rf "$HERE/hypr" "$CONFIG/hypr"
ok "$CONFIG/hypr/hyprland.lua + assets"
cp -rf "$HERE/quickshell" "$CONFIG/quickshell"
ok "$CONFIG/quickshell/ (bar, popups, notifications)"

if [ -f "$HOME/Documents/imgborders/build/libimgborders.so" ]; then
    ok "imgborders plugin found, it will load"
else
    warn "imgborders plugin not built - the config will print one error at"
    warn "startup and carry on, that is expected and harmless"
fi

step "done"
cat <<'EOF'
  log out, pick Hyprland at your display manager, log back in.

  this rice does NOT touch your sway setup, both can sit side by side.

    SUPER + RETURN      terminal (kitty)
    SUPER + E           file manager (thunar)
    SUPER + D           app menu
    SUPER + Q           close window
    SUPER + SHIFT + Q   quit hyprland
    SUPER + V           float,  SUPER + F  fullscreen
    SUPER + SHIFT + S   screenshot region

  if the bar is missing:  qs ipc call bar toggle
EOF
printf '\n'