# see -> https://daiderd.com/nix-darwin/manual/index.html
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

  networking = {
    hostName = "be";
  };
}
