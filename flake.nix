{
  description = "beet's home";

  inputs = {
    macos.url = "github:NixOS/nixpkgs/nixpkgs-22.11-darwin";
    nixos.url = "github:NixOS/nixpkgs/nixos-22.11";
    nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nur.url = "github:nix-community/NUR";
    home-manager.url = "github:nix-community/home-manager/release-22.11";
    home-manager.inputs.nixpkgs.follows = "nixos";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "macos";
  };

  outputs =
    { home-manager, nixos, nixos-unstable, nixos-hardware, nur, darwin, ... }: {
      nixosConfigurations = {
        be = nixos.lib.nixosSystem rec {
          system = "x86_64-linux";
          modules = [
            ./os/nixos/configuration.nix
            # Custom hardware kernel
            nixos-hardware.nixosModules.microsoft-surface-pro-intel
            # Add config.nur
            nur.nixosModules.nur
            # Pass args to home.nix
            ({ ... }: {
              home-manager.users.beet.config = {
                _module.args = {
                  unstablePkgs = import nixos-unstable {
                    inherit system;
                    config = { allowUnfree = true; };
                  };
                  nur = nur.nurpkgs;
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
        "be" = darwin.lib.darwinSystem rec {
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
