{
  description = "beet's home";

  inputs = {
    macos.url = "github:NixOS/nixpkgs/nixpkgs-22.11-darwin";
    nixos.url = "github:NixOS/nixpkgs/nixos-22.11";
    nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nur.url = "github:nix-community/NUR";
    darwin = {
	url = "github:lnl7/nix-darwin/master";
     inputs.nixpkgs.follows = "macos";
};
    nixvim = {
      url = "github:pta2002/nixvim";
      inputs.nixpkgs.follows = "nixos-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixos-unstable";
      # inputs.nixpkgs.follows = "macos";
    };
  };

  outputs =
    { home-manager, nixos, nixos-unstable, nixos-hardware, nur,macos, nixvim, darwin, ... }:
    let
      system = "x86_64-linux";
      unstablePkgs = import nixos-unstable {
        inherit system;
        config = { allowUnfree = true; };
      };
       darwinPkgs = import macos {
        inherit system;
        config = { allowUnfree = true; };
      };

       nurPkgs = import nur {
         nurpkgs = unstablePkgs;
         pkgs = unstablePkgs;
       };
      homeConf = homeConfFile: {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.beet = {
            imports = [ homeConfFile /*nixvim.homeManagerModules.nixvim*/ ];
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
            (homeConf ./os/nixos/users/beet.nix)
          ];
        };
      };

      darwinConfigurations = {
        be = darwin.lib.darwinSystem rec {
system = "x86_64-darwin";
          modules = [
            ./os/macos/configuration.nix
            home-manager.darwinModules.home-manager
            (homeConf ./os/macos/users/beet.nix)
          ];
        };
      };
    };
}
