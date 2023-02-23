{ config, pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
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
        fonts = [ "Hack"];
      })
    ];
  };

  environment =
    {
      # shells = [ pkgs.bashInteractive ];
      systemPackages =
        with pkgs; [
          alacritty
          unzip
          zip
          gnupg
        ];
    };

  programs = {
    bash = {
      enableCompletion = true;
    };
    gnupg.agent = {
      enable = true;
    };
  };

  networking.hostName = "be";
}
