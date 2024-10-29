#!/bin/sh

nix run nix-darwin -- switch --flake ~/.dotfiles#mini --extra-experimental-features "nix-command flakes"
