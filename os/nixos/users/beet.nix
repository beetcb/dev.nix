{ config, pkgs, ... }:

let
  user = rec {
    name = "beet";
    home = "/home/${name}";
    email = "63141491+beetcb@users.noreply.github.com";
    flakeRepo = "/etc/build";
    rebuildSysName = "nixos";
  };
  files = import ./files/files.nix;
  shardFiles = import ../../common/files/files.nix;
in
{
  imports = [
    (import ../../common/user.nix user)
  ];

  home.file = pkgs.lib.recursiveUpdate shardFiles files;
}
