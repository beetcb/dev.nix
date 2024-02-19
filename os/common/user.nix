user:
# see -> https://nix-community.github.io/home-manager/
{ config, pkgs, nixvim, enablePkgs, ... }:
with builtins;

let
  nixvimPkg = (nixvim.legacyPackages.${pkgs.system}.makeNixvimWithModule {
    inherit pkgs;
    module = {
      config = (import ../common/files/.config/nvim/nixvim.nix) enablePkgs pkgs;
    };
  });
in
rec {
  programs = enablePkgs {
    git = {
      userName = user.gitUsername or user.name;
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
    eza = { 
      enableAliases = true;
    };
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
        eval "$(/opt/homebrew/bin/brew shellenv)"
      '';


      functions = {
        os-rebuild = pkgs.lib.optionalString pkgs.stdenv.isLinux "sudo "
          +
          "${user.rebuildSysName}-rebuild switch --flake ${user.flakeRepo}#${user.rebuildDeviceName}";

        os-update = ''
          cd ${user.flakeRepo} &&
          nix flake update &&
          os-rebuild
        '';

        os-cleanup = ''
          sudo rm -f "/nix/var/nix/gcroots/auto/*" &&
          sudo nix-collect-garbage -d && 
          os-rebuild
        '';
      };
    };
    tmux = {
      mouse = true;
      keyMode = "vi";
      plugins = with pkgs; [
        {
          plugin = tmuxPlugins.nord;
          extraConfig = "set -g @plugin 'arcticicestudio/nord-tmux'";
        }
      ];
      extraConfig = ''
        bind-key c command-prompt -p "window name:" "new-window; rename-window '%%'"
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
    ripgrep
    jless
    as-tree
    yarn

    # pkgs need manually setup, and not configurable by using home-manager
    ## see -> https://github.com/NixOS/nixpkgs/pull/217233#issuecomment-1487646724
    bun
    volta

    # overlays
    npm_whistle
  ];

  home.shellAliases = {
    g = "git";
    v = "nvim";
    cd = "z";
    cat = "bat";
    git = "${pkgs.git}/bin/git";
    poweron = "w2 start && miniserve .config/miniserve/hostdir --port 7891";
  };

  home.sessionPath = [
    "$VOLTA_HOME/bin"
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

    # VOLTA JS Launcher
    VOLTA_HOME = "$HOME/.volta";
  };

  home.stateVersion = "23.05";
}

