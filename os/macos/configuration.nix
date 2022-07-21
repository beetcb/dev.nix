{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  # mirror
  nix = {
    binaryCaches = [
      # "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      # "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://cache.nixos.org/"
    ];
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # desk
  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      (nerdfonts.override {
        fonts = [ "Hack" ];
      })
      hack-font
      # noto-fonts-emoji
      # source-han-mono
      # source-han-sans
      # source-han-serif
    ];
  };


  environment =
    {
      shells = [ pkgs.bashInteractive ];
      systemPackages =
        with pkgs; [
          neovim
          alacritty
          unzip
          zip
          gnupg
          nixpkgs-fmt
        ];
    };

  # users
  users.users = {
    beet = {
      description = "beet's home";
      home = "/Users/beet";
      # We need to manually `chsh` to the nix-version
      # bash because this option will point our
      # default shell to the macos-version bash
      # shell = pkgs.bashInteractive;
    };
  };

  # programs
  programs = {
    bash = {
      enable = true;
      enableCompletion = true;
    };
  };

  # services
  services = {
    nix-daemon.enable = true;
  };

  # network
  networking.computerName = "be";

  # system
  system = {
    defaults = {
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        InitialKeyRepeat = 10;
        KeyRepeat = 2;
        _HIHideMenuBar = true;
      };
      dock = {
        wvous-bl-corner = 4;
        wvous-br-corner = 1;
        wvous-tl-corner = 3;
        wvous-tr-corner = 1;
      };
      finder = {
        ShowPathbar = true;
      };
      spaces = {
        spans-displays = false;
      };
      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };

    };
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
    stateVersion = 4;
  };
}
