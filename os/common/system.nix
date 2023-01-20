# The variable pkgs contains Nixpkgs (by default, it takes the nixpkgs entry of NIX_PATH)A,
# while config contains the full system configuration. 
{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
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
      shells = [ pkgs.bashInteractive ];
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
