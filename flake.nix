{
  description = "beet's home";

  inputs = {
    macos.url = "github:NixOS/nixpkgs/nixpkgs-22.11-darwin";
    nixos.url = "github:NixOS/nixpkgs/nixos-22.11";
    nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    darwin.url = "github:lnl7/nix-darwin/master";
    nur.url = "github:nix-community/NUR";
    nixvim = {
      url = "github:pta2002/nixvim";
      inputs.nixpkgs.follows = "nixos-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixos-unstable";
    };
  };

  outputs =
    { home-manager, nixos, nixos-unstable, nixos-hardware, nur, nixvim, darwin, ... }:
    let
      system = "x86_64-linux";
      unstablePkgs = import nixos-unstable {
        inherit system;
        config = { allowUnfree = true; };
      };
      nurPkgs = import nur {
        nurpkgs = unstablePkgs;
        pkgs = unstablePkgs;
      };
      homeConf = {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.beet = {
            imports = [ ./os/nixos/users/beet.nix nixvim.homeManagerModules.nixvim ];
          };
          extraSpecialArgs = {
            pkgs = unstablePkgs;
            nur = nurPkgs;
          };
        };
      };
    in
    {
      nixosConfigurations = {
        be = nixos.lib.nixosSystem rec {
          inherit system;
          modules = [
            ./os/nixos/configuration.nix
            # Custom hardware kernel
            nixos-hardware.nixosModules.microsoft-surface-pro-intel
            # Add config.nur
            nur.nixosModules.nur
            # nur.hmModules.nur
            home-manager.nixosModules.home-manager
            homeConf
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
