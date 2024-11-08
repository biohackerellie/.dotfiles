
nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake ~/.dotfiles/nix/darwin#apple

darwin-rebuild switch --flake ~/.dotfiles/nix/darwin#apple
