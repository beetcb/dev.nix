user:
{ config, pkgs, unstablePkgs, ... }:
with builtins;

let
  enablePkgs = { ... } @ args: mapAttrs (n: v: v // { enable = true; }) args;
in
{
  programs = enablePkgs {
    git = {
      userName = user.name;
      userEmail = user.email;
      extraConfig = {
        init = {
          defaultBranch = "main";
        };
        safe = {
          directory = user.flakeRepo;
        };
        pull.ff = "only";
      };
    };
    bat = {
      config = {
        style = "plain";
      };
    };
    exa = { };
    fzf = { };
    zoxide = { };
    go = {
      goPath = "go";
    };
    alacritty = { };
    bash = { };
    starship = { };
    home-manager = { };
  };

  home.username = user.name;
  home.homeDirectory = user.home;
  home.packages = with unstablePkgs; [
    fd
    ripgrep
    jless
    as-tree
    nodejs-16_x
    dprint
    pngquant
    vscode
    xsel
    yarn
    git-extras
    du-dust
    rnix-lsp
  ];

  home.file = import ./files/files.nix;

  home.shellAliases = {
    g = "git";
    v = "nvim";
    l = "exa -a";
    ls = "exa";
    ll = "exa -l";
    cat = "bat";
    vim = "nvim";
    vmshare = "vmhgfs-fuse .host:/ /mnt/";
    os-rebuild = pkgs.lib.optionalString pkgs.stdenv.isLinux "sudo "
      +
      "${user.rebuildSysName}-rebuild switch --flake ${user.flakeRepo}";
    os-update = ''
      cd ${user.flakeRepo} &&
      nix flake update &&
      os-rebuild
    '';
    os-cleanup = ''
      sudo rm -f /nix/var/nix/gcroots/auto/* &&
      nix-collect-garbage -d &&
      sudo nix-collect-garbage -d && 
      os-rebuild
    '';
  };

  home.sessionPath = [
    "$HOME/.cargo/bin"
    "$HOME/go/bin"
    "$HOME/.local/bin"
  ];

  home.sessionVariables = {
    # Set XDG Base Directory
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_STATE_HOME = "$HOME/.local/state";

    # NPM
    NPM_TOKEN = "";

    EDITOR = "nvim";
  };

  home.stateVersion = "22.05";
}

