# see -> https://daiderd.com/nix-darwin/manual/index.html
{ config, pkgs, nixvim, enablePkgs, ... }:
{
  imports =
    [
      ../common/system.nix
    ];

  users.users = {
    beet = {
      home = "/Users/beet";
      shell = pkgs.fish;
    };
  };

  programs = enablePkgs {
    fish = { };
  };

  services = {
    nix-daemon.enable = true;
  };

  system = {
    defaults = {
      NSGlobalDomain = {
        AppleInterfaceStyle = "Dark";
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        InitialKeyRepeat = 10;
        KeyRepeat = 2;
        "com.apple.trackpad.scaling" = 2.5;
      };
      dock = {
        autohide = true;
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
      userKeyMapping = [
        # Swap CapsLock with Ctrl
        # { HIDKeyboardModifierMappingSrc = 30064771296; HIDKeyboardModifierMappingDst = 30064771129; }
        # { HIDKeyboardModifierMappingSrc = 30064771129; HIDKeyboardModifierMappingDst = 30064771296; }
      ];
    };
    # We need to manually `chsh` to the nix-version shell
    activationScripts.postActivation.text = ''sudo chsh -s ${pkgs.fish}/bin/fish beet'';
  };

  homebrew = {
    enable = true;
    brews = [
      # /usr/bin/git was managed by Apple SIP, can't be removed,
      # nix bin path is after the /usr/bin/, can't be picked up,
      # well home bin path is before the /usr/bin/.
      "git"
      "egoist/tap/dum"
    ];
    casks = [
      "google-chrome"
      "raycast"
      # https://apple.stackexchange.com/a/372964
      "background-music"
      "warp"
      "logseq"
      "licecap"
    ];
    masApps = {
      "wecom-business-im-work-tools" = 1189898970;
      "wechat" = 836500024;
    };
    taps = [
      "egoist/tap"
    ];
  };

  environment.loginShellInit = ''
  w2 --help
  miniserve .config/miniserve/hostdir --port 7891 &
  '';

}
