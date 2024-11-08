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
  xdg.configFile.kitty.source = mkOutOfStoreSymlink "/Users/ellie/.dotfiles/config/.config/kitty";
  programs = {
    zsh = import ../home/zsh.nix {inherit config pkgs lib;};
    zoxide = import ../home/zoxide.nix {inherit config pkgs;};
    fzf = import ../home/fzf.nix {inherit pkgs;};
  }
}

