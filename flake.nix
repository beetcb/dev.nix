{
  description = "beet's home";

  inputs = {
    macos.url = "github:NixOS/nixpkgs/nixpkgs-22.05-darwin";
    nixos.url = "github:NixOS/nixpkgs/nixos-22.05";
    nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-22.05";
    home-manager.inputs.nixpkgs.follows = "nixos";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "macos";
  };

  outputs =
    { home-manager, nixos, nixos-unstable, darwin, ... }: {
      nixosConfigurations = {
        be = nixos.lib.nixosSystem rec {
          system = "x86_64-linux";
          modules = [
            ./os/nixos/configuration.nix
            # Pass args to home.nix
            ({ ... }: {
              home-manager.users.beet.config = {
                _module.args.unstablePkgs = import nixos-unstable {
                  inherit system;
                  config = { allowUnfree = true; };
                };
              };
            })
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.beet = import ./os/nixos/users/beet.nix;
            }
          ];
        };
      };

      darwinConfigurations = {
        "bedeMacBook-Pro" = darwin.lib.darwinSystem rec {
          system = "x86_64-darwin";
          modules = [
            ./os/macos/configuration.nix
            # Pass args to home.nix
            ({ ... }: {
              home-manager.users.beet.config = {
                _module.args.unstablePkgs = import nixos-unstable {
                  inherit system;
                  config = { allowUnfree = true; };
                };
              };
            })
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.beet = import ./os/macos/users/beet.nix;
            }
          ];
        };
      };
    };
}
