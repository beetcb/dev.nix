{ config, pkgs, ... }:

let
  enablePkgs = { ... } @ args: builtins.mapAttrs (n: v: v // { enable = true; }) args;
in
{
  home.username = "beet";
  home.homeDirectory = "/home/beet";

  programs = enablePkgs {
    git = {
      userName = "beet";
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
    pngquant
    google-chrome
    xsel
    qrcp
    du-dust
  ];

  home.file = {
    ".config/leftwm" = {
      source = ./wm;
      recursive = true;
    };
  };

  home.shellAliases = {
    g = "git";
    sys-rebuild-flake = "sudo nixos-rebuild switch --flake '/home/beet/dot#be'";
    v = "nvim";
    vmshare = "vmhgfs-fuse .host:/ /mnt/";
  };

  home.stateVersion = "21.11";
}
