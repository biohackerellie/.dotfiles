{
  description = "Top level flake for nixos";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOs/nixos-hardware/master";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home Manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Alacritty theme
    alacritty-theme.url = "github:alexghr/alacritty-theme.nix";
    alacritty-theme.inputs.nixpkgs.follows = "nixpkgs";
    # Templ
    templ.url = "github:a-h/templ";
    templ.inputs.nixpkgs.follows = "nixpkgs";

    # Ags
    ags.url = "github:Aylur/ags";
    ags.inputs.nixpkgs.follows = "nixpkgs";

    # Matugen
    matugen.url = "github:InioX/matugen?ref=v2.2.0";
    matugen.inputs.nixpkgs.follows = "nixpkgs";
     # NixVim
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

    # Zen browser
    zen-browser.url = "github:MarceColl/zen-browser-flake";
  };

  outputs = {
    self,
    nixpkgs,
    disko,
    home-manager,
    alacritty-theme,
    templ,
    nixpkgs-unstable,
    nixos-hardware,
    ags,
    ...
  } @ inputs: let
    inherit (self) outputs;

    systems = [
      "x86_64-linux" 
    ];
    hosts = [
      {name = "elliepc"; hardware = null;}
    ];
    forAllSystems = fn: nixpkgs.lib.genAttrs systems (system: fn {pkgs = import nixpkgs {inherit system;};});
  in {
    overlays = import ./overlays {inherit inputs;};

    formatter = forAllSystems ({pkgs}: pkgs.alejandra);

    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    nixosConfigurations = builtins.listToAttrs (map (host: {
        name = host.name;
        value = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
            meta = {
              hostname = host.name;
            };
          };
          system = "x86_64-linux";
          modules =
            [
              # Modules
              # System Specific
              ./machines/${host.name}/hardware-configuration.nix
              # General
              ./configuration.nix
              # Home Manager
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.ellie = import ./home/home.nix;
                home-manager.extraSpecialArgs = {
                  inherit inputs;
                  meta = host;
                };
              }
            ]
            ++ (
              if host.hardware != null
              then [host.hardware]
              else []
            );
        };
      })
      hosts);
  };
}
