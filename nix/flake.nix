{
  description = "Ellies nix config";

  inputs = {
    
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";
    impermanence.url = "github:nix-community/impermanence/63f4d0443e32b0dd7189001ee1894066765d18a5";
    
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    agenix,
    impermanence,
    ...
  } @ inputs:

    let
      overlays = [
        inputs.neovim-nightly-overlay.overlays.default
	(self: super: {
         vimPlugins = super.vimPlugins.extend (self': super': {
            nvim-treesitter = super'.nvim-treesitter.overrideAttrs (old: {
              version = "nightly";
              src = super.fetchFromGitHub {
                owner = "nvim-treesitter";
                repo = "nvim-treesitter";
                rev = "093b29f2b409278e2ed69a90462fee54714b5a84";
                sha256 = "sha256-ZC3ks3TWO0UrAvDgzlIOb6IZe2xVt+BJnEPdd9oZAmg=";
              };
            });
          });
        })
      ];

      config = {
        allowUnfree = true;
	permittedInsecurePackages = [ "electron-24.8.6" ];
      };


      x86Pkgs = import nixpkgs {
        system = "x86_64-linux";
        inherit config overlays;
      };

      armPkgs = import nixpkgs {
        system = "aarch64-linux";
        config = { allowUnfree = true; allowUnsupportedSystem = true; };
        inherit overlays;
      };

      darwinPkgs = import nixpkgs {
        system = "aarch64-darwin";
        config = { allowUnfree = true; };
        inherit overlays;
      };

    in
    {
      homeConfigurations = {
        "ellie@pop-os" = home-manager.lib.homeManagerConfiguration {
          pkgs = x86Pkgs;
          modules = [
            ./home/home.nix
          ];
        };
      };

   };

}
