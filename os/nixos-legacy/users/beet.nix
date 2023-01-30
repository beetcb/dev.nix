{ config, pkgs, ... }:

let
  user = rec {
    name = "beet";
    home = "/home/${name}";
    email = "63141491+beetcb@users.noreply.github.com";
    flakeRepo = "/etc/build";
    rebuildSysName = "nixos";
  };
in
{
  imports = [
    (import ../../common/user.nix user)
  ];

  home.file = {
    "./.config" = {
      source = ./files/.config;
      recursive = true;
    };
  };

  xsession = { enable = true; };
  home.stateVersion = "22.05";
}
