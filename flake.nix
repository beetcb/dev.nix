{
  description = "beet's home";

  inputs = {
    nixos.url = "github:NixOS/nixpkgs/nixos-22.11";
    nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nur.url = "github:nix-community/NUR";
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixos-unstable";
    };
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

      enablePkgs = { ... } @ args: builtins.mapAttrs (n: v: v // { enable = true; }) args;
      pkgsWithUnfree = system: import nixos-unstable {
        system = system;
        config = { allowUnfree = true; };
      };
      nurPkgs = system: import nur {
        nurpkgs = pkgsWithUnfree system;
        pkgs = pkgsWithUnfree system;
      };

      homeConf = homeConfFile: system: {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.beet = {
            imports = [ homeConfFile ];
          };
          extraSpecialArgs = {
            nixvim = nixvim;
            enablePkgs = enablePkgs;
            pkgs = pkgsWithUnfree system;
            nur = nurPkgs system;
          };
        };
      };
    in
    {
      nixosConfigurations = {
        be = nixos.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = { inherit nixvim; inherit enablePkgs; };
          modules = [
            ./os/nixos/configuration.nix
            # Custom hardware kernel
            nixos-hardware.nixosModules.microsoft-surface-pro-intel
            # Add config.nur
            nur.nixosModules.nur
            # nur.hmModules.nur
            home-manager.nixosModules.home-manager
            (homeConf ./os/nixos/users/beet.nix system)
          ];
        };
      };

      darwinConfigurations = {
        be = darwin.lib.darwinSystem rec {
          system = "x86_64-darwin";
          specialArgs = { inherit nixvim; inherit enablePkgs; };
          modules = [
            ./os/macos/configuration.nix
            home-manager.darwinModules.home-manager
            (homeConf ./os/macos/users/beet.nix system)
          ];
        };

        be_aarch = darwin.lib.darwinSystem rec {
          system = "aarch64-darwin";
          specialArgs = { inherit nixvim; inherit enablePkgs; };
          modules = [
            ./os/macos/configuration.nix
            home-manager.darwinModules.home-manager
            (homeConf ./os/macos/users/beet.nix system)
          ];
        };
      };
    };
}
