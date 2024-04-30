{ config, pkgs, ... }@args:

let
  user = rec {
    name = "beet";
    gitUsername = "alexphzhou";
    home = "/Users/${name}";
    email = "alexphzhou@tencent.com";
    flakeRepo = "/etc/build";
    rebuildSysName = "darwin";
    rebuildDeviceName = "be_aarch";
  };
  files = import ./files/files.nix;
  shardFiles = import ../../common/files/files.nix;
  shardUserConf =
    (import ../../common/user.nix user) args;
in
{
  imports = [
    shardUserConf
  ];

  home.file = pkgs.lib.recursiveUpdate shardFiles files;

  programs = pkgs.lib.recursiveUpdate
    {
      # Use homebrew instead
      # vscode = {
      #   enable = true;
      #   extensions = with pkgs.vscode-extensions; [
      #     dbaeumer.vscode-eslint
      #     
      #     bbenoist.nix
      #     tamasfe.even-better-toml
      #   ];
      # };
    }
    shardUserConf.programs;

  home.packages = with pkgs; [
    volta
    miniserve
  ] ++ shardUserConf.home.packages;
}
