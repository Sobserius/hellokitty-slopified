#!/usr/bin/env bash
# Builds the patched imgborders plugin and enables hyprbars.
# Run this after install.sh, otherwise the rice boots without the kitty border
# and the border_plugin keys in hyprland.lua stay switched off.
set -euo pipefail

HERE="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$HOME/Documents/imgborders"
SO="$SRC/build/libimgborders.so"

ok()   { printf '  \033[32mok\033[0m    %s\n' "$*"; }
warn() { printf '  \033[33mwarn\033[0m  %s\n' "$*"; }
err()  { printf '  \033[31mfail\033[0m  %s\n' "$*"; }
step() { printf '\n\033[1m%s\033[0m\n' "$*"; }

step "build tools"
missing=()
for c in git cmake make g++; do
    command -v "$c" >/dev/null 2>&1 || missing+=("$c")
done
if [ "${#missing[@]}" -gt 0 ]; then
    err "missing: ${missing[*]}"
    printf '  sudo pacman -S --needed base-devel cmake git\n'
    exit 1
fi
ok "cmake $(cmake --version | head -1 | awk '{print $3}')"

step "headers"
if [ -d /usr/include/hyprland ]; then
    ok "/usr/include/hyprland present"
else
    err "Hyprland headers missing - plugin will not compile against anything"
    printf '  sudo pacman -S --needed hyprland\n'
    printf '  (headers ship with hyprland, and must match your running version)\n'
    exit 1
fi

step "imgborders"
if [ -d "$SRC/.git" ]; then
    ok "already cloned, updating"
    git -C "$SRC" pull -q --rebase || warn "could not pull, using what is there"
else
    git clone -q https://codeberg.org/zacoons/imgborders "$SRC"
    ok "cloned to $SRC"
fi

if git -C "$SRC" apply --reverse --check "$HERE/imgborders.patch" 2>/dev/null; then
    ok "patch already applied"
elif git -C "$SRC" apply --check "$HERE/imgborders.patch" 2>/dev/null; then
    git -C "$SRC" apply "$HERE/imgborders.patch"
    ok "patch applied (kitty face on the top border edge)"
else
    err "patch will not apply cleanly - upstream ImgBorder.cpp changed"
    printf '  cd %s && git stash && git apply %s\n' "$SRC" "$HERE/imgborders.patch"
    exit 1
fi

step "compile"
if cmake -B "$SRC/build" -S "$SRC" >/dev/null 2>&1 && cmake --build "$SRC/build" -j"$(nproc)" >/dev/null 2>&1; then
    if [ -f "$SO" ]; then
        ok "built $SO ($(stat -c%s "$SO") bytes)"
    else
        err "build finished but $SO is not there"
        exit 1
    fi
else
    err "build failed, this is the real output:"
    cmake -B "$SRC/build" -S "$SRC" && cmake --build "$SRC/build" -j"$(nproc)"
    exit 1
fi

step "hyprbars"
command -v hyprpm >/dev/null 2>&1 || { warn "hyprpm not installed, skipping"; exit 0; }

# hyprpm can leave a cache dir holding only state.toml when its clone is
# interrupted. Every plugin then reports "failed to build" because there is no
# source to build, and hyprpm refuses to re-add because it thinks it is installed.
CACHE="/var/cache/hyprpm/$(id -un)/hyprland-plugins"
if [ -d "$CACHE" ] && [ ! -d "$CACHE/.git" ]; then
    err "hyprland-plugins cache is broken, only state.toml in it"
    printf '  this one needs sudo, hyprpm cannot clear its own root-owned cache:\n\n'
    printf '    sudo rm -rf %s\n' "$CACHE"
    printf '    hyprpm add https://github.com/hyprwm/hyprland-plugins\n'
    printf '    hyprpm enable hyprbars\n\n'
    exit 1
fi

hyprpm update >/dev/null 2>&1 || true
if hyprpm list 2>/dev/null | grep -q "Repository hyprland-plugins"; then
    ok "hyprland-plugins registered"
else
    hyprpm add https://github.com/hyprwm/hyprland-plugins >/dev/null 2>&1 &&
        ok "hyprland-plugins added"
fi

hyprpm enable hyprbars >/dev/null 2>&1 || true
sleep 1
if hyprpm list 2>/dev/null | grep -A1 "Plugin hyprbars" | grep -q "failed"; then
    err "hyprbars still will not build"
    printf '  plugins that fail here usually mean the headers do not match the\n'
    printf '  running hyprland version. check with:  hyprctl version\n'
    printf '  and rebuild after:  hyprpm enable hyprbars\n'
    exit 1
fi
ok "hyprbars enabled"

step "done"
cat <<EOF
  log out and back into hyprland, it will pick the plugin up on start.

  the load line only runs when $SO exists, so nothing breaks if
  you delete the build folder later.

  to go back to no kitty border:  rm -rf $SRC/build
EOF