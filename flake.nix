{
  description = "beet's home";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { home-manager, nixpkgs, nixos-unstable, ... }: {
    nixosConfigurations = {
      be = nixpkgs.lib.nixosSystem rec{
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
