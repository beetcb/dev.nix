user:
{ config, pkgs, nixvim, enablePkgs, ... }:
with builtins;

let
  nixvimPkg = (nixvim.legacyPackages.${pkgs.system}.makeNixvim ((import ../common/files/.config/nvim/nixvim.nix) enablePkgs pkgs));
in
rec {
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
    fzf = {
      enableFishIntegration = true;
    };
    zoxide = { };
    go = {
      goPath = "go";
    };
    fish = {
      interactiveShellInit = ''
        set fish_greeting  
      '';
    };
    starship = { 
      enableFishIntegration = true;
    };
  };

  home.username = user.name;
  home.homeDirectory = user.home;
  home.packages = with pkgs; [
    nixvimPkg
    fd
    gh
    # xsel
    ripgrep
    jless
    as-tree
    nodejs-16_x
    # nodePackages.typescript
    yarn
    git-extras
    du-dust
  ];

  home.shellAliases = {
    g = "git";
    v = "nvim";
    l = "exa -a";
    ls = "exa";
    ll = "exa -l";
    cat = "bat";
    git = "${pkgs.git}/bin/git";
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
    VISUAL = "nvim";
  };

  home.stateVersion = "23.05";
}

