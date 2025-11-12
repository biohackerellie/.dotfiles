# My current dotfiles

## Primary Components
* Hyprland
* Waybar
* swww
* rofi
* kitty/ghostty
* Hypridle/Hyprlock
* zsh

## Install
1. Install GNU/stow
2. Clone the repo
3. (optional) remove any directories in `config/.config/` that you dont need like godot, lazygit, nvim, etc
4. From the root of the repo, run 
```sh
stow config

## If you get an error
stow config --adopt
## This will merge your existing files from your .config directory, so using git, check through the changes and undo any that overwrite these dots
```

## Note for niri on wayland

If using uwsm, add the following entry  `/usr/share/wayland-sessions/niri-uwsm.desktop` : 
```sh
[Desktop Entry]
Name=Niri (UWSM)
Comment=A scrollable-tiling Wayland compositor
Exec=uwsm start -F -- niri-session
Type=Application
DesktopNames=niri`
```
