{
  description = "beet's home";

  inputs = {
    macos.url = "github:NixOS/nixpkgs/nixpkgs-22.11-darwin";
    nixos.url = "github:NixOS/nixpkgs/nixos-22.11";
    nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nur.url = "github:nix-community/NUR";
    nixvim.url = "github:beetcb/nixvim";
    home-manager.url = "github:nix-community/home-manager/release-22.11";
    darwin.url = "github:lnl7/nix-darwin/master";
  };

  outputs =
    { home-manager, nixos, nixos-hardware, nur, nixvim, darwin, ... }: {
      nixosConfigurations = {
        be = nixos.lib.nixosSystem rec {
          system = "x86_64-linux";
          modules = [
            ./os/nixos/configuration.nix
            # Custom hardware kernel
            nixos-hardware.nixosModules.microsoft-surface-pro-intel
            # Add config.nur
            nur.nixosModules.nur
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                users.beet = {
                  imports = [ ./os/nixos/users/beet.nix nixvim.homeManagerModules.nixvim ];
                };
                extraSpecialArgs = {
                  nur = nur.nurpkgs;
                };
              };
            }
          ];
        };
      };

      darwinConfigurations = {
        be = darwin.lib.darwinSystem rec {
          system = "x86_64-darwin";
          modules = [
            ./os/macos/configuration.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.users.beet = import ./os/macos/users/beet.nix;
            }
          ];
        };
      };
    };
}
