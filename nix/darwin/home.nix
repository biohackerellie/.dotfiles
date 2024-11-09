{ config, pkgs, lib, ...}:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
in
{
  programs.home-manager.enable = true;

  home.username = "elliekerns";
  home.homeDirectory = "/Users/elliekerns";
  xdg.enable = true;
  home.stateVersion = "23.11";
  xdg.configFile.nvim.source = mkOutOfStoreSymlink "/Users/elliekerns/.dotfiles/config/.config/nvim";
  xdg.configFile.kitty.source = mkOutOfStoreSymlink "/Users/elliekerns/.dotfiles/config/.config/kitty";
  xdg.configFile.alacritty.source = mkOutOfStoreSymlink "/Users/elliekerns/.dotfiles/config/.config/alacritty";
}

