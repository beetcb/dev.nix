{ config, pkgs, unstablePkgs, ... }:
with builtins;

let
  enablePkgs = { ... } @ args: mapAttrs (n: v: v // { enable = true; }) args;
  user = "beet";
  home = "/Users/${user}";
  os = "${home}/dot";
in
{
  home.username = user;
  home.homeDirectory = home;

  programs = enablePkgs {
    git = {
      userName = user;
      userEmail = "alexphzhou@tencent.com";
      extraConfig = {
        init = {
          defaultBranch = "main";
        };
        pull = {
          rebase = true;
        };
        safe = {
          directory = os;
        };
      };
    };
    bat = {
      config = {
        style = "plain";
      };
    };
    exa = { };
    zoxide = { };
    go = {
      goPath = "go";
    };
    alacritty = {
      settings = {
        window = {
          padding = {
            x = 8;
            y = 8;
          };
          opacity = 0.75;
          decorations = "transparent";
        };
        font = {
          normal = {
            family = "Hack Nerd Font";
          };
          size = 16;
        };
        key_bindings = [
          { 
            key = "Paste"; 
            mods = "Control";
            action = "CreateNewWindow";          
          }
        ];
      };
    };
    bash = { };
    starship = { };

    home-manager = { };
  };

  home.packages = with unstablePkgs; [
    fd
    ripgrep
    nodejs-16_x
    dprint
    pngquant
    vscode
    xsel
    qrcp
    yarn
    du-dust
  ];

  home.file = {
    ".npmrc" = {
      text = ''
        //registry.npmjs.org/:_authToken=''\${NPM_TOKEN}
        prefix=${home}/.local
        cache=${home}/.local/share/npm
        registry=https://mirrors.tencent.com/npm/
      '';
    };
    ".config/rustfmt/rustfmt.toml" = {
      text = ''
        max_width = 60 
      '';
    };
    "repo/shell.rs.nix" = {
      text = ''
            let
              pkgs = import <nixos-unstable> {};
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
        TMPDIR = "/tmp";
            }
      '';
    };
  };

  # xsession = { enable = true; };

  home.shellAliases = {
    g = "git";
    v = "nvim";
    l = "exa -a";
    ls = "exa";
    ll = "exa -l";
    cd = "z";
    cat = "bat";
    vim = "nvim";
    vmshare = "vmhgfs-fuse .host:/ /mnt/";
    os-rebuild = "darwin-rebuild switch --flake ${os}";
    os-update = ''
      cd ${os} &&
      nix flake update &&
      os-rebuild
    '';
    os-cleanup = ''
      sudo rm -f /nix/var/nix/gcroots/auto/* &&
      nix-collect-garbage -d &&
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
    NPM_TOKEN = "fake palceholder";

    EDITOR = "nvim";
  };

  home.stateVersion = "22.05";
}
