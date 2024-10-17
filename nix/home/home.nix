{
 inputs,
 outputs,
 lib,
 config,
 pkgs,
 ... }:
let
  obsidian = pkgs.obsidian.override {
    electron = pkgs.electron_24.overrideAttrs (_: {
      preFixup = "patchelf --add-needed ${pkgs.libglvnd}/lib/libEGL.so.1 $out/bin/electron"; # NixOS/nixpkgs#272912
      meta.knownVulnerabilities = [ ]; # NixOS/nixpkgs#273611
    });
  };
in
{
  
  home.username = "ellie";
  home.homeDirectory = "/home/ellie";

  home.stateVersion = "24.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    nixpkgs-fmt
    unzip
    discord
    jq
    vlc
    obsidian
    
  ];

  home.file = {
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    NIX_PATH = "nixpkgs=flake:nixpkgs$\{NIX_PATH:+:$NIX_PATH}";
  };
  imports = [
    ./programs/kitty.nix
    ./programs/git.nix
    ./programs/neovim
  ];
  programs.home-manager.enable = true;
  systemd.user.startServices = "sd-switch";
}
