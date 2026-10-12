# Install:
```console
git clone https://github.com/Sobserius/hellokitty-slopified ~/Documents/hks
~/Documents/hks/install.sh
```

install.sh checks the packages, installs whatever is missing, and copies `hypr/`
and `quickshell/` into `~/.config/`. anything already there gets moved aside as
`*.slop-backup`.

this does not touch a sway setup, both can sit in the display manager.

```console
SUPER + RETURN      terminal
SUPER + E           file manager
SUPER + D           app menu
SUPER + Q           close window
SUPER + SHIFT + Q   quit hyprland
SUPER + V           float
SUPER + F           fullscreen
SUPER + SHIFT + S   screenshot region
```

### Or by hand:

```sh
rm -rf ~/.config/quickshell
git clone https://github.com/Sobserius/hellokitty-slopified /tmp/hks
cp -rf /tmp/hks/quickshell ~/.config/
cp -rf /tmp/hks/hypr ~/.config/
rm -rf /tmp/hks
sudo pacman -S --needed hyprland hyprlock hypridle hyprpm quickshell swaybg xdg-desktop-portal xdg-desktop-portal-hyprland xdg-desktop-portal-wlr polkit-gnome kitty thunar
```

# Optional - the window border kitty:

The hello kitty image require imgborders with a patch that renders them in the center of the top edge.
To apply the patch, make sure you've got the Hyprland headers for the Hyprland version you're running.
without it hyprland prints one error at startup and carries on, the rice still works.

### 1. Clone imgborders

```sh
git clone https://codeberg.org/zacoons/imgborders ~/Documents/imgborders
cd ~/Documents/imgborders
```

### 2. Apply the patch

```sh
git apply imgborders.patch
```

### 3. Build

```sh
cmake -B build
cmake --build build -j$(nproc)
```

### 4. Load it

```sh
hyprctl plugin load ~/Documents/imgborders/build/libimgborders.so
```

Make sure to also enable hyprbars to allow the windows to be dragged

```sh
hyprpm update
hyprpm add https://github.com/hyprwm/hyprland-plugins
hyprpm enable hyprbars
```

#### To install by hand:

```sh
rm -rf ~/.config/quickshell
git clone https://github.com/Sobserius/hellokitty-slopified /tmp/hks
cp -rf /tmp/hks/quickshell ~/.config/
cp -rf /tmp/hks/hypr ~/.config/
rm -rf /tmp/hks
```

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/a66d2584-2fb2-4161-bbb3-d33fa79fc486" />

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/a1ee4ebf-9525-41e7-85e6-c7d272eca9fd" />


