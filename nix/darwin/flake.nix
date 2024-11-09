{
  description = "Ellie's system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew"; 
  };

  outputs = { self, nix-darwin, nixpkgs, home-manager, nix-homebrew, ... }@inputs:
  let
    add-unstable-packages = final: _prev: {
	unstable = import inputs.nixpkgs-unstable {
	  system = "aarch64-darwin";
	  };
	};
    configuration = { pkgs, lib, config, ... }: 
  {
      
      users.users.elliekerns = {
          name = "elliekerns";
          home = "/Users/elliekerns";
        };

      nixpkgs.config.allowUnfree = true;
      nixpkgs.overlays = [
	add-unstable-packages
	];
      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";
      
      environment.systemPackages = 
          [
            pkgs.oh-my-zsh
            pkgs.bun
            pkgs.neovim
            pkgs.ripgrep
            pkgs.rustup
            pkgs.unstable.go_1_23
            pkgs.lua-language-server
            pkgs.stylua
            pkgs.mkalias
            pkgs.gh
            pkgs.zoxide
            pkgs.nodejs_22
            pkgs.sqlc
            pkgs.gum
            pkgs.turbo
            pkgs.lazygit
            pkgs.pnpm
            pkgs.obsidian
            pkgs.tailwindcss
            pkgs.tailwindcss-language-server
          ];
      fonts.packages = [
          pkgs.cascadia-code
        ];
      homebrew = {
          enable = true;
          brews = [
            "mas"
            "fzf"
            "htop"
          ];
          casks = [
            "amethyst"
            "notion"
            "discord"
          ];
          masApps = {

          };
          onActivation.cleanup = "zap";
        };
      system.activationScripts.applications.text = let
        env = pkgs.buildEnv {
          name = "system-applications";
          paths = config.environment.systemPackages;
          pathsToLink = "/Applications";
        };
      in
        pkgs.lib.mkForce ''
        # Set up applications.
        echo "setting up /Applications..." >&2
        rm -rf /Applications/Nix\ Apps
        mkdir -p /Applications/Nix\ Apps
        find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
        while read -r src; do
          app_name=$(basename "$src")
          echo "copying $src" >&2
          ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
        done
            '';

      system.defaults = {
          finder.FXPreferredViewStyle = "clmv";
          loginwindow.GuestEnabled = false;
          NSGlobalDomain.AppleInterfaceStyle = "Dark";
          NSGlobalDomain.KeyRepeat = 2;
        }; 


      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;  # default shell on catalina
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."apple" = nix-darwin.lib.darwinSystem {
      modules = [ 
          configuration 
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              enableRosetta = true;
              user = "elliekerns";
            };
          }
          home-manager.darwinModules.home-manager
          {
            # `home-manager` config
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.elliekerns = import ./home.nix;
          }
        ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."apple".pkgs;
  };
}
