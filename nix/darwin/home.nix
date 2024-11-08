{ config, pkgs, ...}:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
in
{
  programs.home-manager.enable = true;

  home.username = "ellie";
  home.homeDirectory = "/Users/ellie";
  xdg.enable = true;

  xdg.configFile.nvim.source = mkOutOfStoreSymlink "/Users/ellie/.dotfiles/config/.config/nvim";
  xdg.configFile.kitty.source =
}
