{ config, pkgs, ... }:
{
  nix = {
    gc = {
      automatic = true;
      # dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      (nerdfonts.override {
        fonts = [ "Hack" ];
      })
    ];
  };

  environment =
    {
      shells = [ pkgs.fish pkgs.bash ];
      loginShell = pkgs.fish;
      systemPackages =
        with pkgs; [
          alacritty
          unzip
          zip
          gnupg
        ];

    };

  programs = { };

  homebrew = {
    enable = true;
    brews = [
      # /usr/bin/git was managed by Apple SIP, can't be removed,
      # nix bin path is after the /usr/bin/, can't be picked up,
      # well home bin path is before the /usr/bin/.
      "git"
    ];
    casks = [
      "raycast"
    ];
  };

  networking = {
    hostName = "be";
  };
}
