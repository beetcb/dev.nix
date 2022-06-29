{
  description = "beet's home";

  inputs = {
    nixos.url = "github:NixOS/nixpkgs/nixos-22.05";
    nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-22.05";
    home-manager.inputs.nixpkgs.follows = "nixos";
  };

  outputs = { home-manager, nixos, nixos-unstable, ... }: {
    nixosConfigurations = {
      be = nixos.lib.nixosSystem rec {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
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
            home-manager.users.beet = import ./home.nix;
          }
        ];
      };
    };
  };
}
