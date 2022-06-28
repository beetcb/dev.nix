{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  # mirror
  nix = {
    binaryCaches = [
      "https://cache.nixos.org/"
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
    ];
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    autoOptimiseStore = true;
  };

  environment.systemPackages =
    with pkgs; [
      vscode
      neovim
      alacritty
      git
      nixpkgs-fmt
    ];

  # users
  users.users = {
    beet = {
      description = "beet's home";
      home = "/Users/beet";
      shell = pkgs.zsh;
    };
  };

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
