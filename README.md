The hello kitty image require imgborders with a patch that renders them in the center of the top edge.
To apply the patch, make sure you've got the Hyprland headers for the Hyprland version you're running.

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

#### To install:

## Dots installation

```bash
rm -rf ~/.config/quickshell
git clone https://github.com/Sobserius/hellokitty-slopified /tmp/hks
cp -rf /tmp/hks/quickshell ~/.config/
rm -rf /tmp/hks
```

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/a66d2584-2fb2-4161-bbb3-d33fa79fc486" />

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/a1ee4ebf-9525-41e7-85e6-c7d272eca9fd" />


