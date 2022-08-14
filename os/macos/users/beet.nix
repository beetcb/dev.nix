{ config, pkgs, unstablePkgs, ... }:

let
  user = rec {
    name = "beet";
    home = "/Users/${name}";
    email = "alexphzhou@tencent.com";
    flakeRepo = "/etc/build";
    rebuildSysName = "darwin";
  };
in
{
  imports = [
    (import ../../common/user.nix user)
  ];

  home.file = import ../files/files.nix;
}
