{
  description = "beet's home";

  inputs = {
    home-manager.url = "github:nix-community/home-manager/release-21.11";
    nixos.url = "github:NixOS/nixpkgs/nixos-21.11";
    nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
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
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.beet = import ./home.nix;
          }
        ];
      };
    };
  };
}
