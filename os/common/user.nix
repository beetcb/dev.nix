user:
{ config, pkgs, unstablePkgs, nvim, ... }:
with builtins;

let
  enablePkgs = { ... } @ args: mapAttrs (n: v: v // { enable = true; }) args;
in
{
  programs = enablePkgs {
    nixvim = {
      extraConfigLua = ''
	require("extra")
      '';
      globals.mapleader = " ";
      plugins = enablePkgs {
        # Autocompletion
        nvim-cmp = {
	  auto_enable_sources = true;
          sources = [
            { name = "nvim_lsp"; }
            { name = "lua"; }
            { name = "path"; }
            { name = "buffer"; }
          ];
        };
        # Highlight & TreeSitter
        treesitter = { };
        # Git helpers
        fugitive = { };
        gitsigns = { };
        # Status line
        lualine = { };
        # Fuzzy finder
        telescope = {
          extensions.fzy-native = enablePkgs {};
        };
        # LSP
        lsp = {
          servers = enablePkgs {
            gopls = { };
            rnix-lsp = { };
            rust-analyzer = { };
          };
        };
      };
      colorschemes.nord = {};
    };
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

  home.stateVersion = "22.11";
}

