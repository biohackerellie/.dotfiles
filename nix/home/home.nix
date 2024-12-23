{ config, pkgs, meta, lib, ...}:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
in
{
  programs.home-manager.enable = true;

  home.username = "ellie";
  home.homeDirectory = "/home/ellie";
  xdg.enable = true;
  home.stateVersion = "23.11";
  xdg.configFile.nvim.source = mkOutOfStoreSymlink "/home/ellie/.dotfiles/config/.config/nvim";
  xdg.configFile.kitty.source = mkOutOfStoreSymlink "/home/ellie/.dotfiles/config/.config/kitty";
  xdg.configFile.alacritty.source = mkOutOfStoreSymlink "/home/ellie/.dotfiles/config/.config/alacritty";

}

