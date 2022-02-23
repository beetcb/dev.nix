{ config, pkgs, ... }:
with builtins;

let
  enablePkgs = { ... } @ args: mapAttrs (n: v: v // { enable = true; }) args;
  user = "beet";
  home = "/home/${user}";
in
{
  home.username = user;
  home.homeDirectory = home;

  programs = enablePkgs {
    git = {
      userName = user;
      userEmail = "63141491+beetcb@users.noreply.github.com";
      signing = {
        key = "A577D88811B9B09A";
        signByDefault = true;
      };
      extraConfig = {
        init = {
          defaultBranch = "main";
        };
        pull = {
          rebase = false;
        };
      };
    };
    bat = {
      config = {
        style = "plain";
      };
    };
    exa = { };
    go = {
      goPath = "go";
    };
    alacritty = {
      settings = {
        window = {
          padding = {
            x = 8;
            y = 0;
          };
        };
        background_opacity = 0.7;
        font = {
          size = 25;
        };
      };
    };
    vscode = { 
      extensions = [
      ];
    };
    bash = { };
    starship = { };

    home-manager = { };
  };

  home.packages = with pkgs; [
    ripgrep
    nodejs-16_x
    rustc
    cargo
    rustfmt
    dprint
    pngquant
    vscode
    xsel
    qrcp
    du-dust
  ];

  home.file = {
    ".npmrc" = {
      text = ''
      //registry.npmjs.org/:_authToken=''\${NPM_TOKEN}
      prefix=${home}/.local
      cache=${home}/.local/share/npm
      '';
    };
    ".config/leftwm" = {
      source = ./wm;
      recursive = true;
    };
    ".config/rustfmt/rustfmt.toml" = {
      text = ''
      max_width = 60 
      '';
    };
    "repo/shell.rs.nix" = {
      text = ''
        let
          pkgs = import <nixpkgs> {};
        in pkgs.mkShell {
          buildInputs = [
            pkgs.cargo
            pkgs.rustc
            pkgs.rustfmt
            # Necessary for the openssl-sys crate 
            pkgs.openssl
            pkgs.pkg-config
          ];

          RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
        }
      '';
    };
  };

  xsession = { enable = true; };

  home.shellAliases = {
    g = "git";
    v = "nvim";
    l = "exa -a";
    ls = "exa";
    ll = "exa -l";
    cat = "bat";
    vim = "nvim";
    vmshare = "vmhgfs-fuse .host:/ /mnt/";
    sys-rebuild-flake = "sudo nixos-rebuild switch --flake ${home}/dot#be";
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
  };

  home.stateVersion = "21.11";
}
