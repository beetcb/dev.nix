{ config, pkgs, ... }:

let
  user = rec {
    name = "beet";
    home = "/Users/${name}";
    email = "alexphzhou@tencent.com";
    flakeRepo = "/etc/build";
    rebuildSysName = "darwin";
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
